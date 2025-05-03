// chat_list_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/helpers/auth_helpers/auth_service.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/core/widgets/custom_search_bar.dart';
import 'package:joblinc/features/chat/data/models/chat_model.dart';
import 'package:joblinc/features/chat/logic/cubit/chat_list_cubit.dart';
import 'package:joblinc/features/chat/data/services/chat_socket_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/features/chat/ui/widgets/chat_card.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});
  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  List<Chat>? chats;
  bool filter = false;
  final searchTextController = TextEditingController();

  final socketService = ChatSocketService.instance;
  String? userId, accessToken;
  bool isSocketInitialized = false;

  @override
  void initState() {
    super.initState();
    // load existing chats
    context.read<ChatListCubit>().getAllChats();
    _initSocket();
  }

  Future<void> _initSocket() async {
    final auth = getIt<AuthService>();
    userId = await auth.getUserId();
    accessToken = await auth.getAccessToken();
    if (userId == null || accessToken == null) return;

    // initialize once
    final connected = await socketService.initialize(
      userId: userId!,
      accessToken: accessToken!,
    );
    if (!connected) return;

    setState(() => isSocketInitialized = true);

    // subscribe via callbacks
    socketService.onListTyping = (chatId) {
      context.read<ChatListCubit>().setTyping(chatId, true);
    };
    socketService.onListStopTyping = (chatId) {
      context.read<ChatListCubit>().setTyping(chatId, false);
    };
    socketService.onCardUpdate = (data) {
      context.read<ChatListCubit>().updateChatCard(data);
    };
  }

  @override
  void dispose() {
    if (isSocketInitialized) {
      socketService.clearEventHandlers();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatListCubit, ChatListState>(
      builder: (context, state) {
        return Scaffold(
          appBar: _buildAppBar(
            context,
          ),
          body: SafeArea(
            child: Column(
              children: [
                SizedBox(height: 10.h),
                Expanded(child: _buildBody(state)),
              ],
            ),
          ),
          bottomNavigationBar: state is ChatListSelected
              ? _buildSelectionActions(context, state)
              : null,
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    final state = context.watch<ChatListCubit>().state;
    if (state is ChatListSelected) {
      // Selection mode AppBar
      return AppBar(
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: Icon(Icons.close, size: 24.sp),
          onPressed: () => context.read<ChatListCubit>().clearSelection(),
        ),
        title: Text(
          "${state.selectedIds.length} selected",
          style: TextStyle(fontSize: 18.sp),
        ),
      );
    }
    return AppBar(
      backgroundColor: ColorsManager.getPrimaryColor(context),
      elevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: kToolbarHeight + 40.h,
      flexibleSpace: SafeArea(
        child: SizedBox(
          height: kToolbarHeight + 40.h,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back,
                          size: 24.sp, color: Colors.white),
                    ),
                    Expanded(
                      child: CustomSearchBar(
                          keyName: "chatList_search_textField",
                          text: "search messages",
                          onPress: () {} /*startSearch*/,
                          onTextChange:
                              _searchChats /*addSearchedToSearchedList*/,
                          controller: searchTextController),
                    ),
                    IconButton(
                      key: Key("chatList_filter_iconButton"),
                      onPressed: () {
                        setState(() {
                          filter = !filter;
                        });
                        context.read<ChatListCubit>().filteredChats(filter);
                        //filterUnreadChats(filter);
                      },
                      icon: Icon(Icons.filter_list, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, Routes.createChat);
                      },
                      icon: Icon(Icons.add, color: Colors.white),
                    )
                    //MoreOptionsButton(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildBody(ChatListState state) {
    if (state is ChatListLoading)
      return Center(child: CircularProgressIndicator());
    if (state is ChatListEmpty)
      return Center(child: Text('No conversations yet'));

    final list = (state is ChatListLoaded)
        ? state.chats
        : (state is ChatListSearch)
            ? state.searchChats
            : (state is ChatListFilter)
                ? state.filteredChats
                : (state is ChatListSelected)
                    ? state.chats
                    : chats;

    if (list == null || list.isEmpty)
      return Center(child: Text('No conversations'));

    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (_, i) {
        final c = list[i];
        return ChatCard(
          key: ValueKey(c.chatId),
          chat: c,
          selectionMode: state is ChatListSelected,
          selected:
              state is ChatListSelected && state.selectedIds.contains(c.chatId),
          onTap: () async {
            if (state is ChatListSelected) {
              context.read<ChatListCubit>().toggleSelection(c.chatId);
            } else {
              await Navigator.pushNamed(context, Routes.chatScreen,
                  arguments: c.chatId);
              context.read<ChatListCubit>().reloadChats();
            }
          },
          onLongPress: () =>
              context.read<ChatListCubit>().toggleSelection(c.chatId),
        );
      },
    );
  }

  Widget _buildSelectionActions(BuildContext ctx, ChatListSelected s) {
    final anyUnread = s.chats
        .where((c) => s.selectedIds.contains(c.chatId))
        .any((c) => ((c.unreadCount! > 0) && (c.isRead == false)) || (c.isRead == false)) ;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
            onPressed: () => context
                .read<ChatListCubit>()
                .markReadOrUnreadSelected(anyUnread),
            child: Text(anyUnread ? 'Mark read' : 'Mark unread',
                style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => context.read<ChatListCubit>().deleteSelected(),
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => context.read<ChatListCubit>().archiveSelected(),
            child: Text('Archive', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _searchChats(String q) {
    if (q.isEmpty) {
      context.read<ChatListCubit>().getAllChats();
    } else {
      context.read<ChatListCubit>().searchChats(q);
    }
  }
}
