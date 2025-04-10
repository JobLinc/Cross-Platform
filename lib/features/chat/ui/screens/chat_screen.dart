import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/helpers/auth_helpers/auth_service.dart';
import 'package:joblinc/features/chat/data/models/chat_model.dart';
import 'package:joblinc/features/chat/data/models/message_model.dart';
import 'package:joblinc/features/chat/logic/cubit/chat_list_cubit.dart';
import 'package:joblinc/features/chat/ui/screens/video_player_screen.dart';
import 'package:joblinc/features/chat/ui/widgets/chat_avatar.dart';
import 'package:joblinc/features/chat/ui/widgets/star_button.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:open_file/open_file.dart';
import 'package:video_player/video_player.dart';

class ChatScreen extends StatefulWidget {
  final Chat chat; // Chat object with name, picture, etc.

  const ChatScreen({Key? key, required this.chat}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String? userId;
  late IO.Socket socket;
  TextEditingController messageController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  final ImagePicker picker = ImagePicker();
  List<Message> messages = [];
  List<Participant> participants = [];
  bool isTyping = false;
  String status = "offline";

  Future<void> _loadUserAndConnect() async {
    final Auth = getIt<AuthService>();
    userId = await Auth.getUserId();
    if (userId == null) {
      return;
    }
    _initializeSocket(userId!);
  }

  @override
  void initState() {
    super.initState();
    _loadUserAndConnect();
    context.read<ChatListCubit>().getChatDetails(widget.chat.chatId);
  }

  // ==================================Socket Handeling=============================================//



// void _initializeSocket(String userId) {
//   print("🛠️ Initializing socket…");
//   socket = IO.io('http://10.0.2.2:3000', <String, dynamic>{
//     'transports': ['websocket'],
//     'autoConnect': false,
//   });

//   // debug all incoming events
//   socket.onAny((event, data) {
//     print('🛎️ [socket event] $event → $data');
//   });

//   socket
//     ..on('connect', (_) {
//       print('✅ Socket connected (id=${socket.id})');
//       socket.emit('openChat', widget.chat.chatId);
//       print('➡️ openChat → ${widget.chat.chatId}');
//     })
//     ..on('receiveMessage', (data) {
//       print('📩 receiveMessage → $data');
//       final Map<String, dynamic> map = Map<String, dynamic>.from(data);
//       final msg = Message.fromJson(map);
//       setState(() => messages.add(msg));
//       _scrollToBottom();
//     })
//     ..on('messageTyping', (_) {
//       setState(() => isTyping = true);
//     })
//     ..on('stopTyping', (_) {
//       setState(() => isTyping = false);
//     })
//     ..on('disconnect', (reason) {
//       print('⚠️ Socket disconnected: $reason');
//     });

//   socket.connect();
// }

// void sendMessage() {
//   final text = messageController.text.trim();
//   if (text.isEmpty) return;

//   final payload = {
//     'content': { 'text': text },
//     'chatId': widget.chat.chatId,
//   };

//   // send with ack so we know the server saved it
//   socket.emitWithAck('sendMessage', payload, ack: (ackData) {
//     print('✅ sendMessage acknowledged by server');
//   });

//   // optimistic UI
//   final newMsg = Message(
//     messageId: DateTime.now().millisecondsSinceEpoch.toString(),
//     type: 'text',
//     seenBy: [],
//     content: MessageContent(text: text),
//     sentDate: DateTime.now(),
//     senderId: userId!,
//   );

//   setState(() {
//     messages.add(newMsg);
//     messageController.clear();
//   });
//   _scrollToBottom();

//   // let others know we stopped typing
//   socket.emit('stopTyping', widget.chat.chatId);
// }

// void startTyping() {
//   socket.emit('messageTyping', widget.chat.chatId);
// }

// void stopTyping() {
//   socket.emit('stopTyping', widget.chat.chatId);
// }

// void markMessagesAsRead() {
//   // note the correct spelling:
//   socket.emit('messageReceived', widget.chat.chatId);
// }

// void _scrollToBottom() {
//   Future.delayed(const Duration(milliseconds: 100), () {
//     if (_scrollController.hasClients) {
//       _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
//     }
//   });
// }

// @override
// void dispose() {
//   socket.emit('leaveChat', widget.chat.chatId);
//   socket.disconnect();
//   super.dispose();
// }


// ─── inside your _ChatScreenState ───

void _initializeSocket(String userId) {
  print("🛠️ Initializing socket…");
  socket = IO.io('http://10.0.2.2:3000', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
  });

  // Log *every* event for debugging
  socket.onAny((event, data) {
    print('🛎️ [socket event] $event → $data');
  });

  socket
    // Fired when the socket is connected to the server
    ..on('connect', (_) {
      print('✅ Socket connected (id=${socket.id})');
      // Join the room
      socket.emit('openChat', widget.chat.chatId);
      print('➡️ openChat → ${widget.chat.chatId}');
    })

    // Our incoming chat messages
    ..on('receiveMessage', (data) {
      print('📩 receiveMessage → $data');
      try {
        final Map<String, dynamic> map = Map<String, dynamic>.from(data);
        final msg = Message.fromJson(map);
        setState(() => messages.add(msg));
        _scrollToBottom();
      } catch (e) {
        print('⚠️ Error parsing receiveMessage: $e');
      }
    })

    // Typing indicators
    ..on('messageTyping', (_) {
      print('⌨️ someone is typing…');
      setState(() => isTyping = true);
    })
    ..on('stopTyping', (_) {
      print('✋ stopped typing');
      setState(() => isTyping = false);
    })

    // Read receipts (if you care)
    ..on('messageRead', (readerId) {
      print('👀 messageRead by $readerId');
    })

    // Clean up
    ..on('disconnect', (reason) {
      print('⚠️ Socket disconnected: $reason');
    });

  socket.connect();
}

void sendMessage() {
  final text = messageController.text.trim();
  if (text.isEmpty) return;

  final payload = {
    'content': { 'text': text },
    'chatId': widget.chat.chatId,
  };

  print('✋ sending message');  
  socket.emit('sendMessage', payload);

  // Optimistic UI
  final newMsg = Message(
    messageId: DateTime.now().millisecondsSinceEpoch.toString(),
    type: 'text',
    seenBy: [],
    content: MessageContent(text: text),
    sentDate: DateTime.now(),
    senderId: userId!,
  );
  setState(() {
    messages.add(newMsg);
    messageController.clear();
  });
  _scrollToBottom();

  // Tell server we stopped typing
  socket.emit('stopTyping', widget.chat.chatId);
}

void startTyping() {
  socket.emit('messageTyping', widget.chat.chatId);
}

void stopTyping() {
  socket.emit('stopTyping', widget.chat.chatId);
}

void markMessagesAsRead() {
  // Note: backend listens on "messageReceived" (capital R)
  socket.emit('messageReceived', widget.chat.chatId);
}

void _scrollToBottom() {
  Future.delayed(const Duration(milliseconds: 100), () {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.minScrollExtent);
    }
  });
}

@override
void dispose() {
  socket.emit('leaveChat', widget.chat.chatId);
  socket.disconnect();
  super.dispose();
}


  //=============================================Attachement Handelling=============================================//


  Future<void> pickDocument() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result == null) return;
    final path = result.files.first.path!;
    sendFile(path, FileType.any);
  }

  Future<void> pickFromGallery() async {
    // allow both images & videos
    final result = await FilePicker.platform.pickFiles(type: FileType.media);
    if (result == null) return;
    final path = result.files.first.path!;
    sendFile(
        path,
        result.files.first.extension!.startsWith("mp4")
            ? FileType.video
            : FileType.image);
  }

  Future<void> capturePhoto() async {
    final photo =
        await picker.pickImage(source: ImageSource.camera, maxWidth: 1280);
    if (photo == null) return;
    sendFile(photo.path, FileType.image);
  }

  Future<void> captureVideo() async {
    final video = await picker.pickVideo(
        source: ImageSource.camera, maxDuration: const Duration(seconds: 30));
    if (video == null) return;
    sendFile(video.path, FileType.video);
  }

  void sendFile(String path, FileType type) {
  // Create the proper payload structure
  Map<String, dynamic> contentMap = {};
  String msgType;
  
  if (type == FileType.image) {
    contentMap["image"] = path;
    msgType = "image";
  } else if (type == FileType.video) {
    contentMap["video"] = path;
    msgType = "video";
  } else {
    contentMap["document"] = path;
    msgType = "document";
  }
  
  // Format according to the documentation structure
  final messagePayload = {
    "content": contentMap,
    "chatId": widget.chat.chatId
  };

  socket.emit("sendMessage", messagePayload);
  
  // Local message handling for UI updates
  final content = MessageContent(
    image: type == FileType.image ? path : "",
    video: type == FileType.video ? path : "",
    document: type == FileType.any ? path : "",
    text: "",
  );

  final msg = Message(
    messageId: DateTime.now().millisecondsSinceEpoch.toString(),
    type: msgType,
    seenBy: [],
    content: content,
    sentDate: DateTime.now(),
    senderId: userId!,
  );

  setState(() => messages.add(msg));
  Future.delayed(const Duration(milliseconds: 100), () {
    _scrollController.jumpTo(_scrollController.position.minScrollExtent);
  });
}

  

  void showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.insert_drive_file, size: 24.sp),
              title: Text("Send a document", style: TextStyle(fontSize: 16.sp)),
              onTap: () {
                Navigator.pop(context);
                pickDocument();
              },
            ),
            ListTile(
              leading: Icon(Icons.image, size: 24.sp),
              title: Text("Select from gallery",
                  style: TextStyle(fontSize: 16.sp)),
              onTap: () {
                Navigator.pop(context);
                pickFromGallery();
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt, size: 24.sp),
              title: Text("Take a photo", style: TextStyle(fontSize: 16.sp)),
              onTap: () {
                Navigator.pop(context);
                capturePhoto();
              },
            ),
            ListTile(
              leading: Icon(Icons.videocam, size: 24.sp),
              title: Text("Record a video", style: TextStyle(fontSize: 16.sp)),
              onTap: () {
                Navigator.pop(context);
                captureVideo();
              },
            ),
          ],
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: BlocListener<ChatListCubit, ChatListState>(
        listener: (context, state) {
          if (state is ChatDetailLoaded) {
            setState(() {
              participants = state.chatDetail.participants;
              messages = state.chatDetail.messages;
            });
          }
        },
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatListCubit, ChatListState>(
                builder: (context, state) {
                  if (state is ChatDetailLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  // if (state is ChatDetailLoaded) {
                  //   messages = state.chatDetail.messages;
                  //   // if (messages.isEmpty) {
                  //   //   return Center(child: Text("Start the conversation"));
                  //   // }
                  //   return buildMessageList(messages);
                  // }
                  // } else {
                  //   return Center(child: Text("Start the conversation"));
                  if (messages.isEmpty) {
                    return Center(child: Text("Start the conversation"));
                  }
                  return buildMessageList(messages);
                },
              ),
            ),
            if (isTyping)
              const Padding(
                padding: EdgeInsets.only(left: 15, bottom: 5),
                child: Text("Typing...",
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
              ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, -1),
                  )
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                      icon: const Icon(Icons.attach_file),
                      onPressed: showAttachmentOptions),
                  buildMessageSender(),
                  IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: Colors.red,
                      ),
                      onPressed: sendMessage),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMessageSender() {
    return Expanded(
        child: Container(
      decoration: BoxDecoration(
        border: Border.all(
            color: Colors.grey.withOpacity(0.2),
            width: 1.0,
            style: BorderStyle.solid),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5.0,
            spreadRadius: 0.0,
            offset: Offset(1.0, 1.0),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: TextField(
          controller: messageController,
          decoration: InputDecoration(
            //labelText: ' Write a message...',
            labelStyle: TextStyle(color: Colors.grey[10]),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.grey
                      .withOpacity(0.2)), // Red underline when focused
            ),
            disabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.grey
                      .withOpacity(0.2)), // Red underline when disabled
            ),
            hintText: 'Write a message...', // Placeholder text
            hintStyle:
                TextStyle(color: Colors.grey[10]), // Placeholder text color
            border: InputBorder.none,
          ),
          textCapitalization: TextCapitalization.sentences,
          enableSuggestions: true,
          autocorrect: true,
          cursorColor: Colors.red,
          onChanged: (text) {
            if (text.isNotEmpty)
              startTyping();
            else
              stopTyping();
          },
          onEditingComplete: stopTyping,
        ),
      ),
    ));
  }

  Widget buildMessageList(List<Message> messages) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          reverse: true,
          controller: _scrollController,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: messages.map((message) {
                  bool isMe = message.senderId == userId;
                  final sender = isMe
                      ? 'You'
                      : participants
                          .firstWhere(
                            (p) => p.userId == message.senderId,
                            orElse: () => Participant(
                              userId: '',
                              firstName: widget.chat.chatName,
                              lastName: '',
                              profilePicture: '',
                            ),
                          )
                          .firstName;
                  // format time
                  final timeString = DateFormat.jm().format(message.sentDate);
                  return Align(
                    alignment:
                        isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          vertical: 10.h, horizontal: 10.w),
                      padding: EdgeInsets.all(10.h),
                      decoration: BoxDecoration(
                        color: isMe
                            ? const Color.fromARGB(255, 255, 109, 126)
                            : Color.fromARGB(255, 184, 184, 184),
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      child: Column(
                        crossAxisAlignment: isMe
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          // sender name
                          Text(
                            sender,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 4.h),

                          // message content
                          buildMessageContent(message),
                          SizedBox(height: 4.h),

                          // timestamp
                          Text(
                            timeString,
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget buildMessageContent(Message message) {
    final c = message.content;
    if (c.image.isNotEmpty) {
      return Image.file(
        File(c.image),
        width: 200.w,
        height: 200.h,
        fit: BoxFit.cover,
      );
    }
    if (c.video.isNotEmpty) {
      return GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => VideoPlayerScreen(url: c.video)),
        ),
        child: Container(
          width: 200.w,
          height: 200.h,
          color: Colors.black,
          child: Icon(Icons.play_arrow, size: 50.sp, color: Colors.white),
        ),
      );
    }
    if (c.document.isNotEmpty) {
      final name = c.document.split('/').last;
      return InkWell(
        onTap: () => OpenFile.open(c.document),
        child: Row(
          children: [
            Icon(Icons.insert_drive_file, size: 24.sp, color: Colors.grey),
            SizedBox(width: 8.w),
            Expanded(child: Text(name, style: TextStyle(fontSize: 14.sp))),
          ],
        ),
      );
    }
    return Text(
      c.text,
      style:
          TextStyle(fontSize: 20.sp, color:  Color.fromARGB(255, 0, 0, 0)),
    );
  }
  
  AppBar buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          buildChatAvatar(widget.chat.chatPicture),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.chat.chatName,
                  style: TextStyle(fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  status == "online" ? "Active now" : "Offline",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
            icon: const Icon(Icons.more_horiz), onPressed: showMoreOptions),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.video_call),
        ),
        StarButton(),
      ],
    );
  }

  void showMoreOptions() {
    showModalBottomSheet(
      context: context,
      builder: (_) => _MoreOptionsSheet(),
    );
  }
}

class _MoreOptionsSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
              leading: const Icon(Icons.move_to_inbox),
              title: const Text("Move to Other"),
              onTap: () {}),
          ListTile(
              leading: const Icon(Icons.mark_chat_unread),
              title: const Text("Mark as unread"),
              onTap: () {}),
          ListTile(
              leading: const Icon(Icons.star),
              title: const Text("Star"),
              onTap: () {}),
          ListTile(
              leading: const Icon(Icons.notifications_off),
              title: const Text("Mute"),
              onTap: () {}),
          ListTile(
              leading: const Icon(Icons.archive),
              title: const Text("Archive"),
              onTap: () {}),
          ListTile(
              leading: const Icon(Icons.report),
              title: const Text("Report / Block"),
              onTap: () {}),
          ListTile(
              leading: const Icon(Icons.delete),
              title: const Text("Delete conversation"),
              onTap: () {}),
          ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Manage settings"),
              onTap: () {}),
        ],
      ),
    );
  }
}





// class _AttachmentOptionsSheet extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(15),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           ListTile(
//               leading: const Icon(Icons.insert_drive_file),
//               title: const Text("Send a document"),
//               onTap: () {}),
//           ListTile(
//               leading: const Icon(Icons.camera_alt),
//               title: const Text("Take a photo or video"),
//               onTap: () {}),
//           ListTile(
//               leading: const Icon(Icons.image),
//               title: const Text("Select a media from library"),
//               onTap: () {}),
//           ListTile(
//               leading: const Icon(Icons.gif),
//               title: const Text("Select a GIF"),
//               onTap: () {}),
//           ListTile(
//               leading: const Icon(Icons.alternate_email),
//               title: const Text("Mention a person"),
//               onTap: () {}),
//         ],
//       ),
//     );
//   }
// }


  // void sendMessage() {
  //   if (messageController.text.trim().isNotEmpty) {
  //     Message newMessage = Message(
  //       messageId: DateTime.now().millisecondsSinceEpoch.toString(),
  //       content: MessageContent(text: messageController.text.trim()),
  //       sentDate: DateTime.now(),
  //       senderId: userId,
  //       status: "sent",
  //     );

  //     socket.emit("sendMessage", newMessage.toJson());

  //     setState(() {
  //       messages.add(newMessage);
  //       messageController.clear();
  //     });

  //     Future.delayed(Duration(milliseconds: 500), () {
  //       _scrollController.jumpTo(_scrollController.position.minScrollExtent);
  //     });

  //     socket.emit("stopTyping", [widget.chat.chatId, userId]);
  //   }
  // }

    // void _showAttachmentOptions() {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (_) => _AttachmentOptionsSheet(),
  //   );
  // }

    // Widget buildMessageContent(Message message) {
  //   if (message.content.image.isNotEmpty) {
  //     return Image.network(message.content.image);
  //   } else if (message.content.video.isNotEmpty) {
  //     return Text("[Video] ${message.content.video}");
  //   } else if (message.content.document.isNotEmpty) {
  //     return Text("[Document] ${message.content.document}");
  //   }
  //   return Text(message.content.text);
  // }

    // void sendFile(String path, FileType type) {
  //   final content = MessageContent(
  //     image: type == FileType.image ? path : "",
  //     video: type == FileType.video ? path : "",
  //     document: (type == FileType.any) ? path : "",
  //   );
  //   final msg = Message(
  //     messageId: DateTime.now().millisecondsSinceEpoch.toString(),
  //     content: content,
  //     sentDate: DateTime.now(),
  //     senderId: userId,
  //     status: "sent",
  //   );
  //   socket.emit("sendMessage", msg.toJson());
  //   setState(() => messages.add(msg));
  //   Future.delayed(const Duration(milliseconds: 100), () {
  //     _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  //   });
  // }

    // void _initializeSocket(String userId) {
  //   socket = IO.io("http://localhost", {
  //     "transports": ["websocket"],
  //     "autoConnect": false,
  //   });
  //   socket.connect();
  //   socket.onConnect((_) {
  //     socket.emit("openChat", [widget.chat.chatId, userId]);
  //   });

  //   socket.on("receiveMessage", (data) {
  //     setState(() {
  //       messages.add(Message.fromJson(data));
  //     });

  //     Future.delayed(Duration(milliseconds: 100), () {
  //       _scrollController.jumpTo(_scrollController.position.minScrollExtent);
  //     });
  //   });

  //   socket.on("messageTyping", (_) {
  //     setState(() => isTyping = true);
  //   });

  //   socket.on("stopTyping", (_) {
  //     setState(() => isTyping = false);
  //   });

  //   socket.on("userStatus", (data) {
  //     setState(() => status = data["status"]);
  //   });
  // }

  // void sendMessage() {
  //   final text = messageController.text.trim();
  //   if (text.isEmpty) return;

  //   final newMessage = Message(
  //     messageId: DateTime.now().millisecondsSinceEpoch.toString(),
  //     type: "text",
  //     seenBy: [],
  //     content: MessageContent(text: text),
  //     sentDate: DateTime.now(),
  //     senderId: userId!,
  //   );

  //   socket.emit("sendMessage", newMessage.toJson());
  //   setState(() {
  //     messages.add(newMessage);
  //     messageController.clear();
  //   });
  //   Future.delayed(const Duration(milliseconds: 100), () {
  //     _scrollController.jumpTo(_scrollController.position.minScrollExtent);
  //   });
  //   socket.emit("stopTyping", [widget.chat.chatId, userId]);
  // }

  // void startTyping() {
  //   socket.emit("messageTyping", [widget.chat.chatId, userId]);
  // }

  // void stopTyping() {
  //   socket.emit("stopTyping", [widget.chat.chatId, userId]);
  // }

  // @override
  // void dispose() {
  //   socket.emit("leaveChat", widget.chat.chatId);
  //   socket.disconnect();
  //   super.dispose();
  // }

  // void sendFile(String path, FileType type) {
  //   final content = MessageContent(
  //     image: type == FileType.image ? path : "",
  //     video: type == FileType.video ? path : "",
  //     document: type == FileType.any ? path : "",
  //   );

  //   // determine the message type
  //   final msgType = type == FileType.image
  //       ? "image"
  //       : type == FileType.video
  //           ? "video"
  //           : "document";

  //   final msg = Message(
  //     messageId: DateTime.now().millisecondsSinceEpoch.toString(),
  //     type: msgType,
  //     seenBy: [],
  //     content: content,
  //     sentDate: DateTime.now(),
  //     senderId: userId!,
  //   );

  //   socket.emit("sendMessage", msg.toJson());
  //   setState(() => messages.add(msg));
  //   Future.delayed(const Duration(milliseconds: 100), () {
  //     _scrollController.jumpTo(_scrollController.position.minScrollExtent);
  //   });
  // }


  //   void _initializeSocket(String userId) {
//     print("trying to connect");
//   socket = IO.io('http://10.0.2.2:3000', {
//     "transports": ["websocket"],
//     "autoConnect": false,
//   });
//   socket.connect();
//   socket.onConnect((_) {
//     // OpenChat expects only chatId according to docs
//     socket.emit("openChat", widget.chat.chatId);
//     print("Socket connected successfully to ${widget.chat.chatId}");
//   });

//   socket.on("receiveMessage", (data) {
//     setState(() {
//       messages.add(Message.fromJson(data));
//       print("MessageReceived");
//     });

//     Future.delayed(Duration(milliseconds: 100), () {
//       _scrollController.jumpTo(_scrollController.position.minScrollExtent);
//     });
//   });

//   socket.on("messageTyping", (_) {
//     setState(() => isTyping = true);
//   });

//   socket.on("stopTyping", (_) {
//     setState(() => isTyping = false);
//   });

//   socket.on("userStatus", (data) {
//     setState(() => status = data["status"]);
//   });
// }

// void sendMessage() {
//   final text = messageController.text.trim();
//   if (text.isEmpty) return;

//   // Format according to the documentation structure
//   final messagePayload = {
//     "content": {
//       "text": text
//     },
//     "chatId": widget.chat.chatId
//   };

//   socket.emit("sendMessage", messagePayload);
  
//   // Local message handling
//   final newMessage = Message(
//     messageId: DateTime.now().millisecondsSinceEpoch.toString(),
//     type: "text",
//     seenBy: [],
//     content: MessageContent(text: text),
//     sentDate: DateTime.now(),
//     senderId: userId!,
//   );

//   setState(() {
//     messages.add(newMessage);
//     messageController.clear();
//   });
  
//   Future.delayed(const Duration(milliseconds: 100), () {
//     _scrollController.jumpTo(_scrollController.position.minScrollExtent);
//   });
  
//   socket.emit("stopTyping", widget.chat.chatId);
// }

// void startTyping() {
//   // messageTyping expects only chatId
//   socket.emit("messageTyping", widget.chat.chatId);
// }

// void stopTyping() {
//   // stopTyping expects only chatId
//   socket.emit("stopTyping", widget.chat.chatId);
// }

// void markMessagesAsRead() {
//   // Add message received functionality
//   socket.emit("messageRecieved", widget.chat.chatId);
// }

// @override
// void dispose() {
//   socket.emit("leaveChat", widget.chat.chatId);
//   socket.disconnect();
//   super.dispose();
// }