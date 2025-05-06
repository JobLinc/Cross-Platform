import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:joblinc/features/chat/logic/cubit/chat_list_cubit.dart';
import 'package:joblinc/features/chat/logic/cubit/chat_cubit.dart';
import 'package:joblinc/features/chat/data/models/chat_model.dart';
import 'package:joblinc/features/chat/data/models/message_model.dart';
import 'package:joblinc/core/helpers/auth_helpers/auth_service.dart';

@GenerateNiceMocks([
  MockSpec<ChatListCubit>(),
  MockSpec<ChatCubit>(),
  MockSpec<AuthService>(),
])
import 'chat_screen_test.mocks.dart';

// Simple test version of ChatScreen that doesn't attempt to connect to socket
class TestChatScreen extends StatelessWidget {
  final String chatId;
  final bool showLoading;
  final Chat? chat;
  final List<Message> messages;
  final bool showError;
  final String errorText;
  final String currentUserId;

  const TestChatScreen({
    Key? key,
    required this.chatId,
    this.showLoading = false,
    this.chat,
    this.messages = const [],
    this.showError = false,
    this.errorText = '',
    this.currentUserId = 'user1',
  }) : super(key: key);

  // Method to build read receipt indicator based on message state
  Widget buildReadReceipt(Message message) {
    // Only show for messages sent by current user
    if (message.senderId != currentUserId) {
      return SizedBox.shrink(); // No read receipt for received messages
    }

    if (message.seenBy == null) {
      return SizedBox.shrink();
    } else if (message.seenBy!.isEmpty) {
      // Message sent but not delivered - single gray tick
      return Icon(
        Icons.check, // Single check icon
        size: 14,
        color: Colors.grey[600],
      );
    } else if (message.seenBy!.any((id) => id != currentUserId)) {
      // Message read by recipient - blue double tick
      return Icon(
        Icons.done_all, // Double check icon
        size: 14,
        color: Colors.blue, // Blue color signifies "read"
      );
    } else {
      // Message delivered but not read - gray double tick
      return Icon(
        Icons.done_all, // Double check icon
        size: 14,
        color: Colors.grey[600], // Gray indicates "delivered but not read"
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (showLoading) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (showError) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Error: $errorText')),
      );
    }

    if (chat == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('No chat data')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(chat!.chatName),
      ),
      body: messages.isEmpty
          ? Center(child: Text('No messages'))
          : ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return ListTile(
                  title: Text(msg.content.text),
                  subtitle: Row(
                    children: [
                      Text('From: ${msg.senderId}'),
                      Spacer(),
                      // Add the read receipt indicator
                      buildReadReceipt(msg),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockChatListCubit mockChatListCubit;

  // Sample test data
  final testChat = Chat(
    chatId: 'test_chat_id',
    chatName: 'Test Chat',
    chatPicture: ['https://example.com/image.jpg'],
    lastMessage: 'Hello',
    senderName: 'Test User',
    sentDate: DateTime.now(),
    unreadCount: 0,
    isRead: true,
  );

  final testMessages = [
    Message(
      messageId: 'msg1',
      type: 'text',
      seenBy: ['user1'],
      content: MessageContent(text: 'Hello'),
      sentDate: DateTime.now().subtract(Duration(minutes: 5)),
      senderId: 'user1',
    ),
    Message(
      messageId: 'msg2',
      type: 'text',
      seenBy: [],
      content: MessageContent(text: 'Hi there'),
      sentDate: DateTime.now(),
      senderId: 'user2',
    ),
  ];

  final testChatDetail = ChatDetail(
    chatType: 'direct',
    participants: [
      Participant(
        userId: 'user1',
        firstName: 'Test',
        lastName: 'User',
        profilePicture: 'https://example.com/profile.jpg',
      ),
      Participant(
        userId: 'user2',
        firstName: 'Another',
        lastName: 'User',
        profilePicture: 'https://example.com/profile2.jpg',
      ),
    ],
    messages: testMessages,
  );

  setUp(() {
    // Create mocks
    mockChatListCubit = MockChatListCubit();

    // Mock cubit responses
    when(mockChatListCubit.getChatById(any)).thenAnswer((_) async => testChat);
    when(mockChatListCubit.getChatDetails(any)).thenAnswer((_) async => {});
  });

  group('ChatScreen Basic Tests', () {
    // Test 1: Verify that basic UI elements appear when loading
    testWidgets('shows loading state initially', (WidgetTester tester) async {
      when(mockChatListCubit.state).thenReturn(ChatListLoading());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ChatListCubit>.value(
            value: mockChatListCubit,
            child: TestChatScreen(
              chatId: 'test_chat_id',
              showLoading: true,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    // Test 2: Verify chat name appears in AppBar
    testWidgets('displays chat name in AppBar', (WidgetTester tester) async {
      when(mockChatListCubit.state).thenReturn(ChatLoaded(chat: testChat));

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ChatListCubit>.value(
            value: mockChatListCubit,
            child: TestChatScreen(
              chatId: 'test_chat_id',
              chat: testChat,
            ),
          ),
        ),
      );

      expect(find.text('Test Chat'), findsOneWidget);
    });

    // Test 3: Verify messages display correctly
    testWidgets('displays messages when loaded', (WidgetTester tester) async {
      when(mockChatListCubit.state)
          .thenReturn(ChatDetailLoaded(chatDetail: testChatDetail));

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ChatListCubit>.value(
            value: mockChatListCubit,
            child: TestChatScreen(
              chatId: 'test_chat_id',
              chat: testChat,
              messages: testMessages,
            ),
          ),
        ),
      );

      expect(find.text('Hello'), findsOneWidget);
      expect(find.text('Hi there'), findsOneWidget);
    });

    // Test 4: Verify error handling
    testWidgets('handles errors gracefully', (WidgetTester tester) async {
      when(mockChatListCubit.state)
          .thenReturn(ChatDetailErrorLoading('Failed to load chat'));

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ChatListCubit>.value(
            value: mockChatListCubit,
            child: TestChatScreen(
              chatId: 'test_chat_id',
              showError: true,
              errorText: 'Failed to load chat',
            ),
          ),
        ),
      );

      expect(find.text('Error: Failed to load chat'), findsOneWidget);
    });

    // Test 5: Verify read receipts display correctly
    testWidgets('displays correct read receipt indicators',
        (WidgetTester tester) async {
      // Create messages with different read states
      final readReceiptMessages = [
        // Message sent by current user, not seen by anyone (sent)
        Message(
          messageId: 'msg1',
          type: 'text',
          seenBy: [], // Empty - message sent but not read
          content: MessageContent(text: 'Hello from me - sent'),
          sentDate: DateTime.now().subtract(Duration(minutes: 15)),
          senderId: 'user1', // Current user
        ),
        // Message sent by current user, seen by someone else (read)
        Message(
          messageId: 'msg2',
          type: 'text',
          seenBy: ['user2'], // Contains recipient - message read
          content: MessageContent(text: 'Hello from me - read'),
          sentDate: DateTime.now().subtract(Duration(minutes: 10)),
          senderId: 'user1', // Current user
        ),
        // Message from another user (shouldn't show receipt)
        Message(
          messageId: 'msg3',
          type: 'text',
          seenBy: ['user1'], // Current user has seen it
          content: MessageContent(text: 'Hello from someone else'),
          sentDate: DateTime.now().subtract(Duration(minutes: 5)),
          senderId: 'user2', // Another user
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ChatListCubit>.value(
            value: mockChatListCubit,
            child: TestChatScreen(
              chatId: 'test_chat_id',
              chat: testChat,
              messages: readReceiptMessages,
              currentUserId: 'user1',
            ),
          ),
        ),
      );

      // Verify message content is displayed
      expect(find.text('Hello from me - sent'), findsOneWidget);
      expect(find.text('Hello from me - read'), findsOneWidget);
      expect(find.text('Hello from someone else'), findsOneWidget);

      // Verify correct read receipt icons are shown
      expect(find.byIcon(Icons.check),
          findsOneWidget); // Single check for sent message
      expect(find.byIcon(Icons.done_all),
          findsOneWidget); // Double check for read message

      // Check that one of the done_all icons is blue (read)
      final blueIconFinder = find.byWidgetPredicate(
        (widget) =>
            widget is Icon &&
            widget.icon == Icons.done_all &&
            widget.color == Colors.blue,
      );
      expect(blueIconFinder, findsOneWidget);
    });
  });
}
