import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/helpers/auth_helpers/auth_service.dart';
import 'package:joblinc/core/widgets/custom_snackbar.dart';
import 'package:joblinc/features/chat/data/models/chat_model.dart';
import 'package:joblinc/features/chat/data/models/message_model.dart';
import 'package:joblinc/features/chat/data/services/chat_socket_service.dart';
import 'package:joblinc/features/chat/logic/cubit/chat_cubit.dart';
import 'package:joblinc/features/chat/logic/cubit/chat_list_cubit.dart';
import 'package:joblinc/features/chat/ui/widgets/chat_avatar.dart';
import 'package:joblinc/features/chat/ui/widgets/media_displayer.dart';
import 'package:joblinc/features/chat/ui/widgets/new_message.dart';
import 'package:joblinc/features/chat/ui/widgets/star_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  const ChatScreen({Key? key, required this.chatId}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String? userId, accessToken;
  final socketService = ChatSocketService.instance;
  final ScrollController _scrollController = ScrollController();
  final ImagePicker picker = ImagePicker();
  List<Message> messages = [];
  List<Participant> participants = [];
  bool isTyping = false;
  bool isSocketInitialized = false;
  bool isConnecting = false;
  String connectionError = "";
  Chat? chat;
  bool isChatLoading = true;
  bool isChatDetailsLoading = true;
  final _seenMessageIds = <String>{};

  @override
  void initState() {
    super.initState();
    _loadChatAndDetails();
    _initSocket();
  }

  Widget buildReadReceipt(Message message) {
    if (message.senderId != userId || message.seenBy == null) {
      return const SizedBox.shrink();
    }

    if (message.seenBy!.isEmpty) {
      return Icon(
        Icons.check,
        size: 16.sp,
        color: Colors.grey[600],
      );
    } 
  }

  Future<void> _loadChatAndDetails() async {
    setState(() {
      isChatLoading = true;
      isChatDetailsLoading = true;
    });

    // load chat meta
    final loadedChat =
        await context.read<ChatListCubit>().getChatById(widget.chatId);
    setState(() {
      chat = loadedChat;
      isChatLoading = false;
    });

    // load chat history
    await context.read<ChatListCubit>().getChatDetails(widget.chatId);
    setState(() {
      isChatDetailsLoading = false;
    });

    // pull messages & participants from cubit state
    final state = context.read<ChatListCubit>().state;
    if (state is ChatDetailLoaded) {
      setState(() {
        participants = state.chatDetail.participants;
        messages = List.from(state.chatDetail.messages);
      });
      _scrollToBottom();
    }
  }

  Future<void> _initSocket() async {
    setState(() {
      isConnecting = true;
      connectionError = "";
    });

    final auth = getIt<AuthService>();
    userId = await auth.getUserId();
    accessToken = await auth.getAccessToken();
    if (userId == null || accessToken == null) {
      setState(() {
        connectionError = "Not authenticated. Please login again.";
        isConnecting = false;
      });
      return;
    }

    final connected = await socketService.initialize(
      userId: userId!,
      accessToken: accessToken!,
    );
    if (!connected) {
      setState(() {
        connectionError =
            "Could not connect to chat server. Please check your network.";
        isConnecting = false;
      });
      return;
    }

    socketService.onErrorReceived = handleErrorReceive;
    socketService.onMessageReceived = handleMessageRecieve;
    socketService.onTyping = (_) => setState(() => isTyping = true);
    socketService.onStopTyping = (_) => setState(() => isTyping = false);

    socketService.openChat(widget.chatId);

    setState(() {
      isSocketInitialized = true;
      isConnecting = false;
    });
  }

  // void _handleIncomingData(Map<String, dynamic> data) {
  //   final content = data['content'] as Map<String, dynamic>;
  //   final msg = Message(
  //     messageId: DateTime.now().millisecondsSinceEpoch.toString(),
  //     type: content.containsKey('text')
  //         ? 'text'
  //         : content.containsKey('image')
  //             ? 'image'
  //             : content.containsKey('video')
  //                 ? 'video'
  //                 : 'document',
  //     seenBy: [],
  //     content: MessageContent(
  //       text: content['text'] ?? "",
  //       image: content['image'] ?? "",
  //       video: content['video'] ?? "",
  //       document: content['document'] ?? "",
  //     ),
  //     sentDate: DateTime.now(),
  //     senderId: data['senderId'] ?? "unknown",
  //   );

  //   setState(() {
  //     messages.add(msg);
  //   });
  //   _scrollToBottom();
  // }

  handleErrorReceive(Map<String, dynamic> data) {
    final message = data['message'] ?? 'An unknown error occurred';
    if (!message.contains("Failed to mark")) {
      CustomSnackBar.show(
          context: context, message: message, type: SnackBarType.error);

      setState(() {
        messages.removeLast();
      });
    }
  }

  handleMessageRecieve(data) {
    print('📩 Received message: $data');
    try {
      final Map<String, dynamic> map = Map<String, dynamic>.from(data);
      // Check if this is a message intended for this chat
      //if (map['chatId'] == widget.chat.chatId) {
      // Create message from content
      final content = map['content'] as Map<String, dynamic>;
      final Message msg;
      if (map['senderId'] == userId) {
        return;
      }
      if (content.containsKey('text')) {
        msg = Message(
          messageId: DateTime.now().millisecondsSinceEpoch.toString(),
          type: 'text',
          seenBy: [],
          content: MessageContent(text: content['text']),
          sentDate: DateTime.now(),
          senderId: map['senderId'] ?? "unknown",
        );
      } else if (content.containsKey('image')) {
        msg = Message(
          messageId: DateTime.now().millisecondsSinceEpoch.toString(),
          type: 'image',
          seenBy: [],
          content: MessageContent(image: content['image']),
          sentDate: DateTime.now(),
          senderId: map['senderId'] ?? "unknown",
        );
      } else if (content.containsKey('video')) {
        msg = Message(
          messageId: DateTime.now().millisecondsSinceEpoch.toString(),
          type: 'video',
          seenBy: [],
          content: MessageContent(video: content['video']),
          sentDate: DateTime.now(),
          senderId: map['senderId'] ?? "unknown",
        );
      } else {
        msg = Message(
          messageId: DateTime.now().millisecondsSinceEpoch.toString(),
          type: 'document',
          seenBy: [],
          content: MessageContent(document: content['document']),
          sentDate: DateTime.now(),
          senderId: map['senderId'] ?? "unknown",
        );
      }

      if (mounted) {
        setState(() => messages.add(msg));
        _scrollToBottom();
      }
      //}
    } catch (e) {
      print('⚠️ Error parsing receiveMessage: $e');
    }
  }

  // void _handleIncomingData(Map<String, dynamic> data) {
  //   // 1. only process messages for this room
  //   if (data['chatId'] != widget.chatId) return;

  //   // 2. only process if not from self
  //   if (data['senderId'] == userId) return;

  //   // assume server gives you a stable messageId
  //   final incomingId = data['messageId'] as String?
  //                        ?? DateTime.now().millisecondsSinceEpoch.toString();
  //   if (_seenMessageIds.contains(incomingId)) return;
  //   _seenMessageIds.add(incomingId);

  //   final content = data['content'] as Map<String, dynamic>;
  //   final msg = Message(
  //     messageId: incomingId,
  //     type: content.containsKey('text') ? 'text' :
  //           content.containsKey('image') ? 'image' :
  //           content.containsKey('video') ? 'video' : 'document',
  //     seenBy: [],
  //     content: MessageContent(
  //       text: content['text'] ?? "",
  //       image: content['image'] ?? "",
  //       video: content['video'] ?? "",
  //       document: content['document'] ?? "",
  //     ),
  //     sentDate: DateTime.parse(data['sentDate'] ?? DateTime.now().toIso8601String()),
  //     senderId: data['senderId'] ?? "unknown",
  //   );

  //   setState(() => messages.add(msg));
  //   _scrollToBottom();
  // }

  // void _handleMessageSent(String text) {
  //   // echo locally
  //   final localMsg = Message(
  //     messageId: DateTime.now().millisecondsSinceEpoch.toString(),
  //     type: 'text',
  //     seenBy: [],
  //     content: MessageContent(text: text),
  //     sentDate: DateTime.now(),
  //     senderId: userId!,
  //   );
  //   setState(() => messages.add(localMsg));
  //   _scrollToBottom();

  //   // send to server
  //   socketService.sendMessage(widget.chatId, text);
  //   socketService.markAsRead(widget.chatId);
  // }

  void _handleMessageSent(String messageText) {
    // Create a local message object for immediate UI display
    final newMsg = Message(
      messageId: DateTime.now().millisecondsSinceEpoch.toString(),
      type: 'text',
      seenBy: [],
      content: MessageContent(text: messageText),
      sentDate: DateTime.now(),
      senderId: userId!,
    );

    // Add message to local list
    setState(() {
      messages.add(newMsg);
    });

    _scrollToBottom();

    if (isSocketInitialized) {
      socketService.markAsRead(widget.chatId);
    }
  }

//   void _scrollToBottom() {
//     Future.delayed(const Duration(milliseconds: 100), () {
//       if (_scrollController.hasClients) {
//         _scrollController.jumpTo(_scrollController.position.minScrollExtent);
//       }
//     });

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.minScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    if (isSocketInitialized) {
      socketService.leaveChat(widget.chatId);
      socketService.clearEventHandlers();
    }
    _scrollController.dispose();
    super.dispose();
  }

  // @override
  // Widget build(BuildContext context) {
  //   if (isChatLoading || chat == null) {
  //     return Scaffold(appBar: AppBar(), body: Center(child: CircularProgressIndicator()));
  //   }
  //   if (isChatDetailsLoading) {
  //     return Scaffold(appBar: buildAppBar(), body: Center(child: CircularProgressIndicator()));
  //   }

  //   return Scaffold(
  //     appBar: buildAppBar(),
  //     body: Column(
  //       children: [
  //         if (connectionError.isNotEmpty)
  //           Container(
  //             padding: EdgeInsets.all(8),
  //             color: Colors.red[100],
  //             child: Row(
  //               children: [
  //                 Icon(Icons.error_outline, color: Colors.red),
  //                 SizedBox(width: 8),
  //                 Expanded(child: Text(connectionError, style: TextStyle(color: Colors.red[900]))),
  //                 IconButton(icon: Icon(Icons.refresh), onPressed: _initSocket),
  //               ],
  //             ),
  //           ),
  //         Expanded(
  //           child: messages.isEmpty
  //               ? Center(child: Text("No messages yet"))
  //               : SingleChildScrollView(
  //                   reverse: true,
  //                   controller: _scrollController,
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.end,
  //                     children: messages.map(_buildMessageBubble).toList(),
  //                   ),
  //                 ),
  //         ),
  //         if (isTyping)
  //           Padding(
  //             padding: const EdgeInsets.only(left: 15, bottom: 5),
  //             child: Text("Typing...", style: TextStyle(fontSize: 12, color: Colors.grey)),
  //           ),
  //         _buildInputBar(),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildMessageBubble(Message m) {
  //   final isMe = m.senderId == userId;
  //   final senderName = isMe
  //       ? 'You'
  //       : participants.firstWhere(
  //           (p) => p.userId == m.senderId,
  //           orElse: () => Participant(
  //             userId: '',
  //             firstName: chat!.chatName,
  //             lastName: '',
  //             profilePicture: '',
  //           ),
  //         ).firstName;
  //   final time = DateFormat.jm().format(m.sentDate);
  //   return Align(
  //     alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
  //     child: Container(
  //       margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
  //       padding: EdgeInsets.all(10.h),
  //       decoration: BoxDecoration(
  //         color: isMe ? Color(0xFFFF6D7E) : Color(0xFFB8B8B8),
  //         borderRadius: BorderRadius.circular(5.r),
  //       ),
  //       child: Column(
  //         crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
  //         children: [
  //           Text(senderName, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold)),
  //           SizedBox(height: 4.h),
  //           m.content.text.isNotEmpty
  //               ? Text(m.content.text, style: TextStyle(fontSize: 20.sp))
  //               : MediaDisplayer(message: m, chatId: chat!.chatId, socketService: socketService),
  //           SizedBox(height: 4.h),
  //           Text(time, style: TextStyle(fontSize: 10.sp, color: Colors.grey[600])),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildInputBar() {
  //   return Container(
  //     padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
  //     decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -1))]),
  //     child: Row(
  //       children: [
  //         IconButton(
  //           icon: Icon(Icons.attach_file),
  //           onPressed: isSocketInitialized ? showAttachmentOptions : null,
  //         ),
  //         Expanded(
  //           child: isSocketInitialized
  //               ? NewMessage(chatId: widget.chatId, socket: socketService.socket, onMessageSent: _handleMessageSent)
  //               : TextField(enabled: false, decoration: InputDecoration(hintText: isConnecting ? "Connecting..." : "Write a message...")),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    if (isChatLoading || chat == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (isChatDetailsLoading) {
      return Scaffold(
        appBar: buildAppBar(), // Only safe if buildAppBar uses chat!
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: buildAppBar(),
      body: BlocListener<ChatListCubit, ChatListState>(
        listener: (context, state) {
          if (state is ChatDetailLoaded) {
            setState(() {
              participants = state.chatDetail.participants;
              messages = state.chatDetail.messages;
            });
            // Mark messages as read when chat loads
            if (isSocketInitialized) {
              socketService.markAsRead(widget.chatId);
            }
          }
        },
        child: Column(
          children: [
            // Show connection error if any
            // if (connectionError.isNotEmpty)
            //   Container(
            //     padding: EdgeInsets.all(8),
            //     color: Colors.red[100],
            //     child: Row(
            //       children: [
            //         Icon(Icons.error_outline, color: Colors.red),
            //         SizedBox(width: 8),
            //         Expanded(
            //           child: Text(
            //             connectionError,
            //             style: TextStyle(color: Colors.red[900]),
            //           ),
            //         ),
            //         IconButton(
            //           icon: Icon(Icons.refresh),
            //           onPressed: () {
            //             setState(() {
            //               connectionError = "";
            //             });
            //             _loadUserAndConnect();
            //           },
            //         )
            //       ],
            //     ),
            //   ),
            Expanded(
              child: BlocBuilder<ChatListCubit, ChatListState>(
                builder: (context, state) {
                  if (state is ChatDetailLoading || isConnecting) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text(isConnecting
                              ? "Connecting to chat server..."
                              : "Loading messages...")
                        ],
                      ),
                    );
                  }
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
                    onPressed:
                        isSocketInitialized ? showAttachmentOptions : null,
                    color: isSocketInitialized ? null : Colors.grey,
                  ),
                  // Use the improved NewMessage widget with the socket
                  Expanded(
                    child: isSocketInitialized
                        ? NewMessage(
                            chatId: widget.chatId,
                            socket: socketService.socket,
                            onMessageSent: _handleMessageSent,
                          )
                        : TextField(
                            enabled: false,
                            decoration: InputDecoration(
                              hintText: isConnecting
                                  ? "Connecting..."
                                  : connectionError.isNotEmpty
                                      ? "Connection failed"
                                      : "Write a message...",
                              border: OutlineInputBorder(),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMessageContent(Message message) {
    final c = message.content;
    if ((c.image.isNotEmpty) ||
        (c.video.isNotEmpty) ||
        (c.document.isNotEmpty)) {
      return BlocProvider(
        create: (context) => getIt<ChatCubit>(),
        child: MediaDisplayer(
          message: message,
          chatId: chat!.chatId,
          socketService: socketService,
        ),
      );
    }

    return Text(
      c.text,
      style: TextStyle(fontSize: 20.sp, color: Color.fromARGB(255, 0, 0, 0)),
    );
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
                              firstName: chat!.chatName,
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

  AppBar buildAppBar() {
    return AppBar(
      leading: BackButton(),
      title: Row(
        children: [
          buildChatAvatar(chat!.chatPicture),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(chat!.chatName,
                  style: TextStyle(fontSize: 16),
                  overflow: TextOverflow.ellipsis),
              Text(isTyping ? "Typing..." : "Offline",
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(icon: Icon(Icons.more_horiz), onPressed: _showMore),
        IconButton(icon: Icon(Icons.video_call), onPressed: () {}),
        StarButton()
      ],
    );
  }

  void _showMore() => showModalBottomSheet(
      context: context, builder: (_) => _MoreOptionsSheet());
  //void _showAttachmentOptions() {/*…unchanged…*/}
  //   //=============================================Attachment Handling=============================================//

  Future<void> pickDocument() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result == null) return;
    final path = result.files.first.path!;
    handleMedia(path, FileType.any);
  }

  Future<void> pickFromGallery() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.media);
    if (result == null) return;
    final path = result.files.first.path!;
    handleMedia(
        path,
        result.files.first.extension!.startsWith("mp4")
            ? FileType.video
            : FileType.image);
  }

  Future<void> capturePhoto() async {
    final photo =
        await picker.pickImage(source: ImageSource.camera, maxWidth: 1280);
    if (photo == null) return;
    handleMedia(photo.path, FileType.image);
  }

  Future<void> captureVideo() async {
    final video = await picker.pickVideo(
        source: ImageSource.camera, maxDuration: const Duration(seconds: 30));
    if (video == null) return;
    handleMedia(video.path, FileType.video);
  }

  void handleMedia(String path, FileType type) {
    // void sendFile(String path, FileType type) {
    String fileType;

    if (type == FileType.image) {
      fileType = 'image';
    } else if (type == FileType.video) {
      fileType = 'video';
    } else {
      fileType = 'document';
    }

    //   // Simple emit without acknowledgment - matching frontend
    //   socketService.sendFileMessage(widget.chat.chatId, path, fileType);

    //   // Local message handling for UI updates
    final content = MessageContent(
      image: type == FileType.image ? path : "",
      video: type == FileType.video ? path : "",
      document: type == FileType.any ? path : "",
      text: "",
    );

    final msg = Message(
      messageId: DateTime.now().millisecondsSinceEpoch.toString(),
      type: fileType,
      seenBy: [],
      content: content,
      sentDate: DateTime.now(),
      senderId: userId!,
    );

    setState(() => messages.add(msg));
    _scrollToBottom();
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
}

class _MoreOptionsSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
      padding: EdgeInsets.all(15),
      child: Column(mainAxisSize: MainAxisSize.min, children: []));
}
  // String? userId, accessToken;
  // final socketService = ChatSocketService.instance;
  // final ScrollController _scrollController = ScrollController();
  // final ImagePicker picker = ImagePicker();

  // List<Message> messages = [];
  // List<Participant> participants = [];
  // bool isTyping = false;
  // bool isSocketInitialized = false;
  // bool isConnecting = false;
  // String connectionError = "";
  // Chat? chat;
  // bool isChatLoading = true;
  // bool isChatDetailsLoading = true;

  // @override
  // void initState() {
  //   super.initState();
  //   _loadChatAndDetails();
  //   _initSocket();
  // }

  // Future<void> _loadChatAndDetails() async {
  //   setState(() {
  //     isChatLoading = true;
  //     isChatDetailsLoading = true;
  //   });

  //   try {
  //     final loadedChat =
  //         await context.read<ChatListCubit>().getChatById(widget.chatId);
  //     setState(() {
  //       chat = loadedChat;
  //       isChatLoading = false;
  //     });

  //     await context.read<ChatListCubit>().getChatDetails(widget.chatId);
  //     setState(() {
  //       isChatDetailsLoading = false;
  //     });
  //   } catch (_) {
  //     setState(() {
  //       isChatLoading = false;
  //       isChatDetailsLoading = false;
  //     });
  //   }
  // }

  // Future<void> _initSocket() async {
  //   setState(() {
  //     isConnecting = true;
  //     connectionError = "";
  //   });

  //   final auth = getIt<AuthService>();
  //   userId = await auth.getUserId();
  //   accessToken = await auth.getAccessToken();

  //   if (userId == null || accessToken == null) {
  //     setState(() {
  //       connectionError = "Not authenticated. Please login again.";
  //       isConnecting = false;
  //     });
  //     return;
  //   }

  //   final connected = await socketService.initialize(
  //     userId: userId!,
  //     accessToken: accessToken!,
  //   );

  //   if (!connected) {
  //     setState(() {
  //       connectionError =
  //           "Could not connect to chat server. Please check your network.";
  //       isConnecting = false;
  //     });
  //     return;
  //   }

  //   // subscribe to socket callbacks
  //   socketService.onMessageReceived = _handleIncomingData;
  //   socketService.onTyping          = (_) => setState(() => isTyping = true);
  //   socketService.onStopTyping      = (_) => setState(() => isTyping = false);
  //   socketService.onReadReceipt     = (reader) => print("Read by $reader");

  //   socketService.openChat(widget.chatId);

  //   setState(() {
  //     isSocketInitialized = true;
  //     isConnecting = false;
  //   });
  // }

  // void _handleIncomingData(Map<String, dynamic> data) {
  //   final content = data['content'] as Map<String, dynamic>;
  //   final msg = Message(
  //     messageId: DateTime.now().millisecondsSinceEpoch.toString(),
  //     type: content.containsKey('text')
  //         ? 'text'
  //         : content.containsKey('image')
  //             ? 'image'
  //             : content.containsKey('video')
  //                 ? 'video'
  //                 : 'document',
  //     seenBy: [],
  //     content: MessageContent(
  //       text: content['text'] ?? "",
  //       image: content['image'] ?? "",
  //       video: content['video'] ?? "",
  //       document: content['document'] ?? "",
  //     ),
  //     sentDate: DateTime.now(),
  //     senderId: data['senderId'] ?? "unknown",
  //   );

  //   if (mounted) {
  //     setState(() => messages.add(msg));
  //     _scrollToBottom();
  //   }
  // }

  // void _handleMessageSent(String text) {
  //   _scrollToBottom();
  //   socketService.sendMessage(widget.chatId, text);
  //   socketService.markAsRead(widget.chatId);
  // }

  // void _scrollToBottom() {
  //   Future.delayed(const Duration(milliseconds: 100), () {
  //     if (_scrollController.hasClients) {
  //       _scrollController.jumpTo(_scrollController.position.minScrollExtent);
  //     }
  //   });
  // }

  // @override
  // void dispose() {
  //   if (isSocketInitialized) {
  //     socketService.leaveChat(widget.chatId);
  //     socketService.clearEventHandlers();
  //   }
  //   super.dispose();
  // }

  // // … attachment methods unchanged …

  // @override
  // Widget build(BuildContext context) {
  //   if (isChatLoading || chat == null) {
  //     return Scaffold(appBar: AppBar(), body: Center(child: CircularProgressIndicator()));
  //   }
  //   if (isChatDetailsLoading) {
  //     return Scaffold(appBar: buildAppBar(), body: Center(child: CircularProgressIndicator()));
  //   }

  //   return Scaffold(
  //     appBar: buildAppBar(),
  //     body: Column(
  //       children: [
  //         if (connectionError.isNotEmpty)
  //           Container(
  //             padding: EdgeInsets.all(8),
  //             color: Colors.red[100],
  //             child: Row(
  //               children: [
  //                 Icon(Icons.error_outline, color: Colors.red),
  //                 SizedBox(width: 8),
  //                 Expanded(child: Text(connectionError, style: TextStyle(color: Colors.red[900]))),
  //                 IconButton(icon: Icon(Icons.refresh), onPressed: _initSocket),
  //               ],
  //             ),
  //           ),
  //         Expanded(
  //           child: messages.isEmpty
  //               ? Center(child: Text("Start the conversation"))
  //               : SingleChildScrollView(
  //                   reverse: true,
  //                   controller: _scrollController,
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.end,
  //                     children: messages.map(_buildMessageBubble).toList(),
  //                   ),
  //                 ),
  //         ),
  //         if (isTyping)
  //           Padding(
  //             padding: const EdgeInsets.only(left: 15, bottom: 5),
  //             child: Text("Typing...", style: TextStyle(fontSize: 12, color: Colors.grey)),
  //           ),
  //         _buildInputBar(),
  //       ],
  //     ),
  //   );
  // }