import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/features/chat/data/repos/chat_repo.dart';
import 'package:joblinc/features/chat/data/services/chat_api_service.dart';
import 'package:joblinc/features/chat/logic/cubit/chat_list_cubit.dart';
import 'package:joblinc/features/chat/ui/widgets/group_list_connections.dart';
import 'package:joblinc/features/connections/data/models/connectiondemoModel.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
    late final ChatRepo _chatRepo;
  late Future<List<UserConnection>> _connectionsFuture;
  
  @override
  void initState() {
    super.initState();
    final apiService = ChatApiService(getIt<Dio>());
    _chatRepo = ChatRepo(apiService);
    _connectionsFuture = _chatRepo.getConnections();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Group"),
      ),
      body: FutureBuilder<List<UserConnection>>(
        future: _connectionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Failed to load connections.'));
          }
          final connections = snapshot.data ?? [];
          if (connections.isEmpty) {
            return Center(child: Text('You have no connections to chat with.'));
          }
          // Wrap with BlocProvider<ChatListCubit> here
          return BlocProvider<ChatListCubit>(
            create: (_) => getIt<ChatListCubit>(),
            child: GroupChatConnectionsListView(
              connections: connections,
              isuser: true,
            ),
          );
        },
      ),
    );
  }
}