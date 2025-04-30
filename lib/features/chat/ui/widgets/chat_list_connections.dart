import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/widgets/custom_search_bar.dart';
import 'package:joblinc/core/widgets/profile_image.dart';
import 'package:joblinc/features/chat/data/models/chat_model.dart';
import 'package:joblinc/features/chat/data/models/message_model.dart';
import 'package:joblinc/features/chat/data/repos/chat_repo.dart';
import 'package:joblinc/features/chat/logic/cubit/chat_list_cubit.dart';
import 'package:joblinc/features/chat/ui/screens/chat_screen.dart';
import 'package:joblinc/features/connections/data/models/connectiondemoModel.dart';
import 'package:joblinc/features/connections/logic/cubit/connections_cubit.dart';

// ignore: must_be_immutable
class ChatConnectionsListView extends StatefulWidget {
  List<UserConnection> connections;
  bool isuser;
  ChatConnectionsListView(
      {Key? key, required this.connections, this.isuser = true})
      : super(key: key);

  @override
  State<ChatConnectionsListView> createState() =>
      _ChatConnectionsListViewState();
}

class _ChatConnectionsListViewState extends State<ChatConnectionsListView> {
  late List<UserConnection> filteredConnections;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredConnections = widget.connections;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      filteredConnections = widget.connections.where((connection) {
        final first = connection.firstname.toLowerCase();
        final last = connection.lastname.toLowerCase();
        final fullName = "$first $last";
        return first.contains(query) ||
            last.contains(query) ||
            fullName.contains(query) ||
            connection.headline.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChatListCubit>(
      create: (_) => getIt<ChatListCubit>(),
      child: Column(
        children: [
          CustomSearchBar(
            keyName: "chat_connections_searchbar_textfield",
            text: "Search for a connection...",
            onPress: () {},
            onTextChange: (searched) {
              _searchController.text = searched;
            },
            controller: _searchController,
          ),
          Expanded(
            child: ListView.separated(
              itemCount: filteredConnections.length,
              itemBuilder: (context, index) {
                final connection = filteredConnections[index];

                return Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: InkWell(
                        key: Key("connection_profile_button"),
                        onTap: () async {
                          //todo: go to the profile of the user
                          print("go to ${connection.firstname} profile");
                          final shouldRefresh = await Navigator.pushNamed(
                                context,
                                Routes.otherProfileScreen,
                                arguments: connection.userId,
                              ) ??
                              false;

                          if (shouldRefresh == true) {
                            if (widget.isuser) {
                              context
                                  .read<ConnectionsCubit>()
                                  .fetchConnections();
                            } else {
                              // No action for non-user yet
                            }
                          }
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: ProfileImage(
                                  imageURL: connection.profilePicture,
                                  radius: 25.r,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${connection.firstname} ${connection.lastname}",
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  connection.headline != ""
                                      ? Text(
                                          connection.headline,
                                          style: TextStyle(
                                            fontSize: 18.sp,
                                            color: Colors.grey[600],
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      : SizedBox.shrink(),
                                ],
                              ),
                            ),
                            widget.isuser
                                ? IconButton(
                                    key: Key("connection_chat_button"),
                                    onPressed: () async {
                                      // Show loading snackbar
                                      final scaffoldMessenger = ScaffoldMessenger.of(context);
                                      final loadingSnackBar = SnackBar(
                                        duration: const Duration(minutes: 1),
                                        content: Row(
                                          children: [
                                            SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(strokeWidth: 2),
                                            ),
                                            SizedBox(width: 16),
                                            Text("Creating the chat"),
                                          ],
                                        ),
                                      );
                                      scaffoldMessenger.showSnackBar(loadingSnackBar);

                                      try {
                                        final chatRepo = getIt<ChatRepo>();
                                        final createdChat = await chatRepo.createChat(
                                          receiverIds: [connection.userId],
                                        );
                                        print("Chat created: Id: ${createdChat.chatId}");
                                        print("Chat created: Name: ${createdChat.chatName}");
                                        print("Chat created: ${createdChat.chatPicture}");

                                        // Safely parse the last message if it exists
                                        String lastMessageText = '';
                                        DateTime lastMessageDate = DateTime.now();
                                        if (createdChat.messages.isNotEmpty) {
                                          final lastMsgJson = createdChat.messages.last;
                                          final lastMsg = Message.fromJson(lastMsgJson as Map<String, dynamic>);
                                          lastMessageText = lastMsg.content.text;
                                          lastMessageDate = lastMsg.sentDate;
                                        }

                                        final chat = Chat(
                                          chatId: createdChat.chatId,
                                          chatName: createdChat.chatName,
                                          senderName: "",
                                          chatPicture: createdChat.chatPicture,
                                          lastMessage: lastMessageText,
                                          sentDate: lastMessageDate,
                                          unreadCount: 0,
                                          isRead: true,
                                        );

                                        scaffoldMessenger.hideCurrentSnackBar();

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => BlocProvider.value(
                                              value: context.read<ChatListCubit>(),
                                              child: ChatScreen(chat: chat),
                                            ),
                                          ),
                                        );
                                      } catch (e) {
                                        scaffoldMessenger.hideCurrentSnackBar();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Failed to create chat: $e')),
                                        );
                                        print("Error creating chat: $e");
                                      }
                                    },
                                    icon: Icon(Icons.send, size: 20.sp),
                                  )
                                : SizedBox.shrink(),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) => Divider(
                color: Colors.grey[300], // Line color
                thickness: 1, // Line thickness
                height: 0, // No extra spacing
              ),
            ),
          ),
        ],
      ),
    );
  }
}
