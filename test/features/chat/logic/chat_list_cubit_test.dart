// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:bloc_test/bloc_test.dart';
// import 'package:joblinc/features/chat/data/models/chat_model.dart';
// import 'package:joblinc/features/chat/data/repos/chat_repo.dart';
// import 'package:joblinc/features/chat/logic/cubit/chat_list_cubit.dart';

// class MockChatRepo extends Mock implements ChatRepo {}

// void main() {
//   late ChatListCubit chatListCubit;
//   late MockChatRepo mockChatRepo;
  
//   setUp(() {
//     mockChatRepo = MockChatRepo();
//     chatListCubit = ChatListCubit(mockChatRepo);
//   });

//   tearDown(() {
//     chatListCubit.close();
//   });

//   final chat1 = Chat(
//     id: "conv_001",
//     userID: "user1",
//     userName: "Alice",
//     userAvatar: null,
//     lastMessage: LastMessage(
//       senderID: "user1",
//       text: "Hello",
//       timestamp: DateTime.now(),
//       messageType: "text",
//     ),
//     lastUpdate: DateTime.now(),
//     unreadCount: 1,
//     lastSender: "Alice",
//     isOnline: true,
//   );

//   final chat2 = Chat(
//     id: "conv_002",
//     userID: "user2",
//     userName: "Bob",
//     userAvatar: null,
//     lastMessage: LastMessage(
//       senderID: "user2",
//       text: "Hey!",
//       timestamp: DateTime.now(),
//       messageType: "text",
//     ),
//     lastUpdate: DateTime.now(),
//     unreadCount: 0,
//     lastSender: "Bob",
//     isOnline: false,
//   );

//   final List<Chat> chatList = [chat1, chat2];

//   group('ChatListCubit Tests', () {
//     blocTest<ChatListCubit, ChatListState>(
//       'emits [ChatListLoading, ChatListLoaded] when getAllChats is called and succeeds',
//       build: () {
//         when(() => mockChatRepo.getAllChats()).thenAnswer((_) async => chatList);
//         return chatListCubit;
//       },
//       act: (cubit) => cubit.getAllChats(),
//       expect: () => [
//         ChatListLoading(),
//         ChatListLoaded(chats: chatList),
//       ],
//     );

//     blocTest<ChatListCubit, ChatListState>(
//       'emits [ChatListLoading, ChatListEmpty] when getAllChats returns an empty list',
//       build: () {
//         when(() => mockChatRepo.getAllChats()).thenAnswer((_) async => []);
//         return chatListCubit;
//       },
//       act: (cubit) => cubit.getAllChats(),
//       expect: () => [
//         ChatListLoading(),
//         ChatListEmpty(),
//       ],
//     );

//     blocTest<ChatListCubit, ChatListState>(
//       'emits ChatListSearch when searchChats is called with a valid query',
//       build: () {
//         chatListCubit.emit(ChatListLoaded(chats: chatList));
//         return chatListCubit;
//       },
//       act: (cubit) => cubit.searchChats("Alice"),
//       expect: () => [
//         ChatListSearch([chat1]),
//       ],
//     );

//     blocTest<ChatListCubit, ChatListState>(
//       'emits ChatListEmpty when searchChats finds no match',
//       build: () {
//         chatListCubit.emit(ChatListLoaded(chats: chatList));
//         return chatListCubit;
//       },
//       act: (cubit) => cubit.searchChats("Charlie"),
//       expect: () => [
//         ChatListEmpty(),
//       ],
//     );

//     blocTest<ChatListCubit, ChatListState>(
//       'emits ChatListFilter when filtering unread messages',
//       build: () {
//         chatListCubit.emit(ChatListLoaded(chats: chatList));
//         return chatListCubit;
//       },
//       act: (cubit) => cubit.filteredChats(true),
//       expect: () => [
//         ChatListFilter([chat1]),
//       ],
//     );

//     blocTest<ChatListCubit, ChatListState>(
//       'emits ChatListNewChat and ChatListLoaded when addNewChat is called',
//       build: () => chatListCubit,
//       act: (cubit) => cubit.addNewChat(chat1),
//       expect: () => [
//         ChatListNewChat(chat1),
//         ChatListLoaded(chats: [chat1]),
//       ],
//     );
//   });
// }


// void main() {
//   late ChatListCubit chatListCubit;
//   late MockChatRepo mockChatRepo;

//   setUp(() {
//     mockChatRepo = MockChatRepo();
//     chatListCubit = ChatListCubit(mockChatRepo);
//   });

//   blocTest<ChatListCubit, ChatListState>(
//     'emits [ChatListLoading, ChatListLoaded] when getAllChats() is called and returns data',
//     build: () {
//     when(mockChatRepo.getAllChats() as Function()).thenAnswer((_) async => Future.value(mockChats));
//       return chatListCubit;
//     },
//     act: (cubit) => cubit.getAllChats(),
//     expect: () => [ChatListLoading(), ChatListLoaded(chats: mockChats)],
//   );

//   blocTest<ChatListCubit, ChatListState>(
//     'emits [ChatListLoading, ChatListEmpty] when getAllChats() returns an empty list',
//     build: () {
//       when(mockChatRepo.getAllChats() as Function()).thenAnswer((_) async => []);
//       return chatListCubit;
//     },
//     act: (cubit) => cubit.getAllChats(),
//     expect: () => [ChatListLoading(), ChatListEmpty()],
//   );
// }


import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:joblinc/features/chat/data/models/chat_model.dart';
import 'package:joblinc/features/chat/data/repos/chat_repo.dart';
import 'package:joblinc/features/chat/logic/cubit/chat_list_cubit.dart';
//import 'package:mocktail/mocktail.dart';
class MockChatRepo extends Mock implements ChatRepo {}
@GenerateMocks([ChatRepo])
void main() {
  late MockChatRepo mockChatRepo;
  late ChatListCubit chatListCubit;
  WidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    mockChatRepo = MockChatRepo();
    chatListCubit = ChatListCubit(mockChatRepo);
    when(mockChatRepo.getAllChats()).thenAnswer((_) async => []);
  });

  tearDown(() {
    chatListCubit.close();
  });

  group('ChatListCubit Tests', () {
    // final mockChats = [
    //   Chat(
    //     id: "1",
    //     userID: "user1",
    //     userName: "Alice",
    //     userAvatar: null,
    //     lastMessage: LastMessage(
    //       senderID: "user1",
    //       text: "Hello!",
    //       timestamp: DateTime.now(),
    //       messageType: "text",
    //     ),
    //     lastUpdate: DateTime.now(),
    //     unreadCount: 2,
    //     lastSender: "Alice",
    //     isOnline: true,
    //   ),
    // ];

    blocTest<ChatListCubit, ChatListState>(
      'emits [ChatListLoading, ChatListLoaded] when getAllChats is successful',
      build: () {
        when(mockChatRepo.getAllChats()).thenAnswer((_) async => mockChats);
        return chatListCubit;
      },
      act: (cubit) => cubit.getAllChats(),
      expect: () => [
        ChatListLoading(),
        ChatListLoaded(chats: mockChats),
      ],
    );

    blocTest<ChatListCubit, ChatListState>(
      'emits [ChatListLoading, ChatListEmpty] when getAllChats returns empty list',
      build: () {
        when(mockChatRepo.getAllChats()).thenAnswer((_) async => []);
        return chatListCubit;
      },
      act: (cubit) => cubit.getAllChats(),
      expect: () => [
        ChatListLoading(),
        ChatListEmpty(),
      ],
    );

    blocTest<ChatListCubit, ChatListState>(
      'emits [ChatListLoading, ChatListErrorLoading] when getAllChats fails',
      build: () {
        when(mockChatRepo.getAllChats()).thenThrow(Exception("Failed to load"));
        return chatListCubit;
      },
      act: (cubit) => cubit.getAllChats(),
      expect: () => [
        ChatListLoading(),
        isA<ChatListErrorLoading>(),
      ],
    );

    blocTest<ChatListCubit, ChatListState>(
      'emits [ChatListSearch] when searchChats is called',
      build: () {
        return chatListCubit;
      },
      act: (cubit) {
        cubit.emit(ChatListLoaded(chats: mockChats));
        cubit.searchChats("Alice");
      },
      expect: () => [
        ChatListSearch(mockChats),
      ],
    );

    blocTest<ChatListCubit, ChatListState>(
      'emits [ChatListFilter] when filteredChats is called',
      build: () {
        return chatListCubit;
      },
      act: (cubit) {
        cubit.emit(ChatListLoaded(chats: mockChats));
        cubit.filteredChats(true);
      },
      expect: () => [
        ChatListFilter(mockChats),
      ],
    );
  });
}
