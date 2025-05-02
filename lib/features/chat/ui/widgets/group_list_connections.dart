import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/core/widgets/custom_search_bar.dart';
import 'package:joblinc/core/widgets/custom_snackbar.dart';
import 'package:joblinc/core/widgets/profile_image.dart';
import 'package:joblinc/features/chat/data/models/chat_model.dart';
import 'package:joblinc/features/chat/data/models/message_model.dart';
import 'package:joblinc/features/chat/data/repos/chat_repo.dart';
import 'package:joblinc/features/chat/logic/cubit/chat_list_cubit.dart';
import 'package:joblinc/features/chat/ui/screens/chat_screen.dart';
import 'package:joblinc/features/connections/data/models/connectiondemoModel.dart';
import 'package:joblinc/features/connections/logic/cubit/connections_cubit.dart';

// ignore: must_be_immutable
class GroupChatConnectionsListView extends StatefulWidget {
  List<UserConnection> connections;
  bool isuser;
  GroupChatConnectionsListView(
      {Key? key, required this.connections, this.isuser = true})
      : super(key: key);

  @override
  State<GroupChatConnectionsListView> createState() =>
      _GroupChatConnectionsListViewState();
}

class _GroupChatConnectionsListViewState
    extends State<GroupChatConnectionsListView> {
  late List<UserConnection> filteredConnections;
  final TextEditingController _searchController = TextEditingController();
  final Set<String> selectedUserIds = {};
  String? groupTitle;
  bool showTitleInput = false;
  final TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fix: Always initialize filteredConnections, even if widget.connections is empty
    filteredConnections = List<UserConnection>.from(widget.connections);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _titleController.dispose();
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

  void _onCheckboxChanged(bool? checked, String userId) {
    setState(() {
      if (checked == true) {
        selectedUserIds.add(userId);
      } else {
        selectedUserIds.remove(userId);
      }
      print("Selected user IDs: $selectedUserIds");
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChatListCubit>(
      create: (_) => getIt<ChatListCubit>(),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  key: Key("create_group_button"),
                  onTap: () {
                    if (selectedUserIds.length >= 2) {
                      setState(() {
                        showTitleInput = true;
                      });
                    } else {
                      CustomSnackBar.show(
                        context: context,
                        message:
                            "Please select at least 2 connections to create a group.",
                        type: SnackBarType.error,
                      );
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 10.h, left: 8, top: 8),
                    child: Text(
                      "Proceed to create the group ",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (showTitleInput)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: "Group Title",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (val) {
                        groupTitle = val;
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
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
                            Text("Creating the group chat"),
                          ],
                        ),
                      );
                      scaffoldMessenger.showSnackBar(loadingSnackBar);

                      try {
                        final chatRepo = getIt<ChatRepo>();
                        final createdChat = await chatRepo.createChat(
                          receiverIds: selectedUserIds.toList(),
                          title: groupTitle ?? "Unnamed group chat",
                        );

                        // Safely parse the last message if it exists
                        String lastMessageText = '';
                        DateTime lastMessageDate = DateTime.now();
                        if (createdChat.messages.isNotEmpty) {
                          final lastMsgJson = createdChat.messages.last;
                          final lastMsg = Message.fromJson(
                              lastMsgJson as Map<String, dynamic>);
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

                        Navigator.pushNamed(
                            context,
                            // MaterialPageRoute(
                            //   builder: (_) => BlocProvider.value(
                            //     value: context.read<ChatListCubit>(),
                            //     child: ChatScreen(chat: chat),
                            //   ),
                            // ),
                            Routes.chatScreen,
                            arguments: chat.chatId);
                      } catch (e) {
                        scaffoldMessenger.hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to create chat: $e')),
                        );
                        print("Error creating chat: $e");
                      }
                    },
                    child: Text("Create"),
                  ),
                ],
              ),
            ),
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
                final isSelected = selectedUserIds.contains(connection.userId);

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
                            // Rounded Checkbox for selection
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15.h, horizontal: 15.w),
                              child: Transform.scale(
                                scale: 1.5
                                    .r, // Increase this value for a larger checkbox
                                child: Checkbox(
                                  shape: const CircleBorder(),
                                  value: isSelected,
                                  onChanged: (checked) => _onCheckboxChanged(
                                      checked, connection.userId),
                                  activeColor: ColorsManager.crimsonRed,
                                ),
                              ),
                            ),
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
