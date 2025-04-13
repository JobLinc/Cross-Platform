import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/helpers/auth_helpers/auth_service.dart';
import 'package:joblinc/features/chat/data/models/chat_model.dart';
import 'package:joblinc/features/chat/data/models/message_model.dart';
import 'package:joblinc/features/chat/data/services/chat_socket_service.dart';
import 'package:joblinc/features/chat/logic/cubit/chat_list_cubit.dart';
import 'package:joblinc/features/chat/ui/screens/video_player_screen.dart';
import 'package:joblinc/features/chat/ui/widgets/chat_avatar.dart';
import 'package:joblinc/features/chat/ui/widgets/new_message.dart';
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
  String? accessToken;
  late ChatSocketService socketService;
  ScrollController _scrollController = ScrollController();
  final ImagePicker picker = ImagePicker();
  List<Message> messages = [];
  List<Participant> participants = [];
  bool isTyping = false;
  String status = "offline";
  bool isSocketInitialized = false;
  bool isConnecting = false;
  String connectionError = "";

  Future<void> _loadUserAndConnect() async {
    setState(() {
      isConnecting = true;
      connectionError = "";
    });

    try {
      final auth = getIt<AuthService>();
      userId = await auth.getUserId();
      accessToken = await auth.getAccessToken();
      print("🔑 Access token from auth service: $accessToken");
      print("🔑 User ID from auth service: $userId");

      if (userId == null) {
        setState(() {
          connectionError = "Not authenticated. Please login again.";
          isConnecting = false;
        });
        return;
      }

      // Initialize socket service with userId from secure storage
      socketService = ChatSocketService(userId!, accessToken!);

      // Try to initialize socket connection
      bool connectionSuccess = await socketService.initialize();
      print("🔌 Socket connection success: $connectionSuccess");

      if (!connectionSuccess) {
        setState(() {
          connectionError =
              "Could not connect to chat server. Please check your network connection.";
          isConnecting = false;
        });
        return;
      }

      // Set up socket event handlers
      _setupSocketEventHandlers();

      // Join the chat room
      socketService.openChat(widget.chat.chatId);

      // Mark as initialized
      setState(() {
        isSocketInitialized = true;
        isConnecting = false;
      });

      // Load chat details
      context.read<ChatListCubit>().getChatDetails(widget.chat.chatId);
    } catch (e) {
      setState(() {
        connectionError = "Error connecting: ${e.toString()}";
        isConnecting = false;
      });
      print("❌ Error in _loadUserAndConnect: $e");
    }
  }

  void _setupSocketEventHandlers() {
    try {
      final socket = socketService.socket;

      // Log all socket events for debugging
      socket.onAny((event, data) {
        print('🛎️ [socket event] $event → $data');
      });

      // Handle incoming messages
      socket.on('receiveMessage', (data) {
        print('📩 Received message: $data');
        try {
          final Map<String, dynamic> map = Map<String, dynamic>.from(data);
          // Check if this is a message intended for this chat
          if (map['chatId'] == widget.chat.chatId) {
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
            } else {
              // Default case or unsupported message type
              return;
            }

            if (mounted) {
              setState(() => messages.add(msg));
              _scrollToBottom();
            }
          }
        } catch (e) {
          print('⚠️ Error parsing receiveMessage: $e');
        }
      });

      // Typing indicators
      socket.on('messageTyping', (_) {
        print('⌨️ someone is typing…');
        if (mounted) {
          setState(() => isTyping = true);
        }
      });

      socket.on('stopTyping', (_) {
        print('✋ stopped typing');
        if (mounted) {
          setState(() => isTyping = false);
        }
      });

      // Read receipts
      socket.on('messageRead', (readerId) {
        print('👀 messageRead by $readerId');
      });
    } catch (e) {
      print("❌ Error setting up socket handlers: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserAndConnect();
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
      socketService.markAsRead(widget.chat.chatId);
    }
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
    if (isSocketInitialized) {
      socketService.leaveChat(widget.chat.chatId);
    }
    super.dispose();
  }

  //=============================================Attachment Handling=============================================//

  Future<void> pickDocument() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result == null) return;
    final path = result.files.first.path!;
    sendFile(path, FileType.any);
  }

  Future<void> pickFromGallery() async {
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
    String fileType;

    if (type == FileType.image) {
      fileType = 'image';
    } else if (type == FileType.video) {
      fileType = 'video';
    } else {
      fileType = 'document';
    }

    // Simple emit without acknowledgment - matching frontend
    socketService.sendFileMessage(widget.chat.chatId, path, fileType);

    // Local message handling for UI updates
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
            // Mark messages as read when chat loads
            if (isSocketInitialized) {
              socketService.markAsRead(widget.chat.chatId);
            }
          }
        },
        child: Column(
          children: [
            // Show connection error if any
            if (connectionError.isNotEmpty)
              Container(
                padding: EdgeInsets.all(8),
                color: Colors.red[100],
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        connectionError,
                        style: TextStyle(color: Colors.red[900]),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.refresh),
                      onPressed: () {
                        setState(() {
                          connectionError = "";
                        });
                        _loadUserAndConnect();
                      },
                    )
                  ],
                ),
              ),
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
                            chatId: widget.chat.chatId,
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
      style: TextStyle(fontSize: 20.sp, color: Color.fromARGB(255, 0, 0, 0)),
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
