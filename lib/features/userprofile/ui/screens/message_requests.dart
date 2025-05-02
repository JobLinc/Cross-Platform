import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/widgets/custom_snackbar.dart';
import 'package:joblinc/features/chat/data/models/chat_model.dart';
import 'package:joblinc/features/userprofile/logic/cubit/message_requests_cubit.dart';

class MessageRequestsScreen extends StatelessWidget {
  const MessageRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Message Requests')),
      body: BlocConsumer<MessageRequestsCubit, MessageRequestsState>(
        listener: (context, state) {
          if (state is MessageRequestAccepted) {
            CustomSnackBar.show(
                context: context,
                message: state.message,
                type: SnackBarType.success);
          } else if (state is MessageRequestRejected) {
            CustomSnackBar.show(
                context: context,
                message: state.message,
                type: SnackBarType.error);
          }
        },
        builder: (context, state) {
          if (state is MessageRequestsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MessageRequestsError) {
            return Center(child: Text(state.message));
          } else if (state is MessageRequestsLoaded) {
            if (state.chats.isEmpty) {
              return const Center(child: Text('No message requests'));
            }
            return ListView.builder(
              itemCount: state.chats.length,
              itemBuilder: (context, index) {
                final chat = state.chats[index];
                return ChatRequestTile(chat: chat);
              },
            );
          } else if (state is MessageRequestsInitial) {
            context.read<MessageRequestsCubit>().fetchMessageRequests();
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class ChatRequestTile extends StatelessWidget {
  final Chat chat;

  const ChatRequestTile({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    final image = (chat.chatPicture != null && chat.chatPicture!.isNotEmpty)
        ? chat.chatPicture!.first
        : null;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: image != null ? NetworkImage(image) : null,
          child: image == null ? const Icon(Icons.person) : null,
        ),
        title: Text(chat.chatName),
        subtitle: Text(chat.lastMessage ?? ''),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              iconSize: 32.sp, // Responsive icon size
              icon: const Icon(Icons.check_circle, color: Colors.green),
              onPressed: () {
                context
                    .read<MessageRequestsCubit>()
                    .changeRequestStatus(chat.chatId, "Accepted");
              },
            ),
            SizedBox(width: 12.w), // Responsive horizontal spacing
            IconButton(
              iconSize: 32.sp,
              icon: const Icon(Icons.cancel, color: Colors.red),
              onPressed: () {
                context
                    .read<MessageRequestsCubit>()
                    .changeRequestStatus(chat.chatId, "Rejected");
              },
            ),
          ],
        ),
      ),
    );
  }
}
