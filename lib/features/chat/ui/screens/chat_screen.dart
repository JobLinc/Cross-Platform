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
  bool isBlocked = false;
  // final _seenMessageIds = <String>{};

  @override
  void initState() {
    super.initState();
    _loadChatAndDetails();
    _initSocket();
  }

  // Different receipt statuses return different icons
  Widget buildReadReceipt(Message message) {
    // Only show for messages sent by current user
    if (message.senderId != userId) {
      return SizedBox.shrink(); // No read receipt for received messages
    }
    if (message.seenBy == null) {
      return SizedBox.shrink(); // No read receipt if seenBy is null
    } else {
      // Determine receipt status
      if (message.seenBy!.isEmpty) {
        // Message sent but not delivered - single gray tick
        return Icon(
          Icons.check, // Single check icon
          size: 14.sp,
          color: Colors.grey[600],
        );
      } else if (message.seenBy!.any((id) => id != userId)) {
        // Message read by recipient - blue double tick
        return Icon(
          Icons.done_all, // Double check icon
          size: 14.sp,
          color: Colors.blue, // Blue color signifies "read"
        );
      } else {
        // Message delivered but not read - gray double tick
        return Icon(
          Icons.done_all, // Double check icon
          size: 14.sp,
          color: Colors.grey[600], // Gray indicates "delivered but not read"
        );
      }
    }
  }

  void handleReadReceipt(String readerId) {
    setState(() {
      for (var message in messages) {
        // Only update messages sent by current user
        if (message.senderId == userId) {
          // Add reader to the seenBy array if not already there
          message.seenBy ??= [];
          if (!message.seenBy!.contains(readerId)) {
            message.seenBy!.add(readerId);
          }
        }
      }
    });
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
    socketService.onReadReceipt = handleReadReceipt;
    socketService.openChat(widget.chatId);

    setState(() {
      isSocketInitialized = true;
      isConnecting = false;
    });
  }

  handleErrorReceive(Map<String, dynamic> data) {
    String message = data['message'] ?? 'An unknown error occurred';
    if (message.contains("blocked")) {
      message = "You blocked or have been blocked by this user!";
      setState(() {
        isBlocked = true;
      });
    }
    if (!message.contains("Failed to mark")) {
      CustomSnackBar.show(
          context: context, message: message, type: SnackBarType.error);

      setState(() {
        messages.removeLast();
      });
    }
  }

  handleMessageRecieve(data) {
    try {
      final Map<String, dynamic> map = Map<String, dynamic>.from(data);
      // Check if this is a message intended for this chat
      //if (map['chatId'] == widget.chat.chatId) {
      // Create message from content
      final content = map['content'] as Map<String, dynamic>;
      final Message msg;

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
      // Handle parsing error
      print("Error parsing message: $e");
    }
  }

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
                  !isBlocked
                      ? IconButton(
                          icon: const Icon(Icons.attach_file),
                          onPressed: isSocketInitialized
                              ? showAttachmentOptions
                              : null,
                          color: isSocketInitialized ? null : Colors.grey,
                        )
                      : SizedBox(
                          width: 45.h,
                        ),
                  // Use the improved NewMessage widget with the socket
                  Expanded(
                    child: isSocketInitialized
                        ? (!isBlocked
                            ? NewMessage(
                                chatId: widget.chatId,
                                socket: socketService.socket,
                                onMessageSent: _handleMessageSent,
                              )
                            : Text(
                                "You blocked or have been blocked by this user!",
                                style: TextStyle(color: Colors.red),
                              ))
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
                          Row(
                            children: [
                              Text(
                                timeString,
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(width: 5.w),
                              buildReadReceipt(message),
                            ],
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
            ],
          ),
        ],
      ),
      actions: [StarButton()],
    );
  }

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
