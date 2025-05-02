import 'package:flutter/material.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/features/chat/data/repos/chat_repo.dart';
import 'package:joblinc/features/chat/data/services/chat_api_service.dart';
import 'package:dio/dio.dart';
import 'package:joblinc/features/chat/ui/widgets/chat_list_connections.dart';
import 'package:joblinc/features/connections/data/models/connectiondemoModel.dart';


class CreateChatScreen extends StatefulWidget {
  const CreateChatScreen({Key? key}) : super(key: key);

  @override
  State<CreateChatScreen> createState() => _CreateChatScreenState();
}

class _CreateChatScreenState extends State<CreateChatScreen> {
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
        title: Text('Start a Chat'),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, Routes.createGroupChatScreen);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.groups_rounded),
            ),
          ),
        ],
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
          return ChatConnectionsListView(
            connections: connections,
            isuser: true,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, Routes.createGroupChatScreen);
        },
        child: Icon(Icons.groups_rounded),
      ),
    );
  }
}
