import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:joblinc/features/chat/data/repos/chat_repo.dart';
import 'package:joblinc/features/chat/logic/cubit/chat_list_cubit.dart';
import 'package:mockito/mockito.dart';
import 'package:joblinc/features/chat/data/models/chat_model.dart';
import 'package:joblinc/features/chat/data/models/message_model.dart';

// A manual mock of ChatRepo
class MockChatRepo extends Mock implements ChatRepo {}

void main() {
  group('ChatListCubit', () {
    late ChatListCubit cubit;
    late MockChatRepo mockRepo;
    final testChats = [
      Chat(
        chatId: 'c1',
        chatName: 'Alice',
        chatPicture: ['pic1.png'],
        lastMessage: 'Hi',
        sentDate: DateTime.now(),
        unreadCount: 0,
        isRead: true,
      ),
      Chat(
        chatId: 'c2',
        chatName: 'Bob',
        chatPicture: [],
        lastMessage: 'Hello',
        sentDate: DateTime.now(),
        unreadCount: 2,
        isRead: false,
      ),
    ];
    final testDetail = ChatDetail(
      chatType: 'group',
      participants: [],
      messages: [
        Message(
          messageId: 'm1',
          type: 'text',
          content: MessageContent(text: 'Hello'),
          sentDate: DateTime.now(),
          senderId: 'c1',
        ),
      ],
    );

    setUp(() {
      mockRepo = MockChatRepo();
      cubit = ChatListCubit(mockRepo);
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state is ChatListInitial', () {
      expect(cubit.state, isA<ChatListInitial>());
    });

    blocTest<ChatListCubit, ChatListState>(
      'getAllChats emits [Loading, Loaded] on non-empty repo result',
      build: () {
        when(mockRepo.getAllChats()).thenAnswer((_) async => testChats);
        return cubit;
      },
      act: (c) => c.getAllChats(),
      expect: () => [
        isA<ChatListLoading>(),
        isA<ChatListLoaded>(),
      ],
      verify: (_) {
        verify(mockRepo.getAllChats()).called(1);
      },
    );

    blocTest<ChatListCubit, ChatListState>(
      'getAllChats emits [Loading, Empty] on empty repo result',
      build: () {
        when(mockRepo.getAllChats()).thenAnswer((_) async => []);
        return cubit;
      },
      act: (c) => c.getAllChats(),
      expect: () => [
        isA<ChatListLoading>(),
        isA<ChatListEmpty>(),
      ],
    );

    blocTest<ChatListCubit, ChatListState>(
      'getChatDetails emits [DetailLoading, DetailLoaded]',
      build: () {
        when(mockRepo.getChatDetails('c1')).thenAnswer((_) async => testDetail);
        return cubit;
      },
      act: (c) => c.getChatDetails('c1'),
      expect: () => [
        isA<ChatDetailLoading>(),
        isA<ChatDetailLoaded>(),
        //ChatDetailLoaded(chatDetail: testDetail),
      ],
      verify: (_) {
        verify(mockRepo.getChatDetails('c1')).called(1);
      },
    );

    blocTest<ChatListCubit, ChatListState>(
      'searchChats filters correctly and emits ChatListSearch',
      build: () {
        // preload chats
        cubit
          ..emit(ChatListLoaded(chats: testChats))
          ..chats = testChats; // hack: set internal cache
        return cubit;
      },
      act: (c) => c.searchChats('bob'),
      expect: () => [
        isA<ChatListSearch>().having(
          (s) => (s as ChatListSearch).searchChats.first.chatName,
          'filtered chats',
          'Bob',
        ),
      ],
    );

    blocTest<ChatListCubit, ChatListState>(
      'filteredChats(true) emits ChatListFilter with only unread',
      build: () {
        cubit
          ..emit(ChatListLoaded(chats: testChats))
          ..chats = testChats;
        return cubit;
      },
      act: (c) => c.filteredChats(true),
      expect: () => [
        isA<ChatListFilter>().having(
          (s) => (s).filteredChats.length,
          'only one unread',
          1,
        ),
      ],
    );

    blocTest<ChatListCubit, ChatListState>(
      'toggleSelection and clearSelection work',
      build: () {
        cubit
          ..emit(ChatListLoaded(chats: testChats))
          ..chats = testChats;
        return cubit;
      },
      act: (c) {
        c.toggleSelection('c2');
        c.clearSelection();
      },
      expect: () => [
        isA<ChatListSelected>().having(
          (s) => (s as ChatListSelected).selectedIds.contains('c2'),
          'selected c2',
          isTrue,
        ),
        isA<ChatListLoaded>(),
      ],
    );

    // blocTest<ChatListCubit, ChatListState>(
    //   'addNewChat emits new chat events then reloads',
    //   build: () {
    //     return cubit;
    //   },
    //   act: (c) => c.addNewChat(testChats.first),
    //   expect: () => [
    //     ChatListNewChat(testChats.first),
    //     isA<ChatListLoaded>(),
    //   ],
    // );

    blocTest<ChatListCubit, ChatListState>(
      'markReadOrUnreadSelected calls repo and reloads',
      build: () {
        when(mockRepo.markReadOrUnread('c2')).thenAnswer((_) async {});
        when(mockRepo.getAllChats()).thenAnswer((_) async => testChats);
        cubit.selectedIds.add('c2');
        return cubit;
      },
      act: (c) => c.markReadOrUnreadSelected(true),
      expect: () => [
        isA<ChatListLoading>(),
        isA<ChatListLoaded>(),
      ],
    );

    blocTest<ChatListCubit, ChatListState>(
      'deleteSelected calls repo and reloads',
      build: () {
        when(mockRepo.deleteChat('c2')).thenAnswer((_) async {});
        when(mockRepo.getAllChats()).thenAnswer((_) async => []);
        cubit.selectedIds.add('c2');
        return cubit;
      },
      act: (c) => c.deleteSelected(),
      expect: () => [
        isA<ChatListLoading>(),
        isA<ChatListEmpty>(),
      ],
    );

    blocTest<ChatListCubit, ChatListState>(
      'archiveSelected calls repo and reloads',
      build: () {
        when(mockRepo.archiveChat('c2')).thenAnswer((_) async {});
        when(mockRepo.getAllChats()).thenAnswer((_) async => testChats);
        cubit.selectedIds.add('c2');
        return cubit;
      },
      act: (c) => c.archiveSelected(),
      expect: () => [
        isA<ChatListLoading>(),
        isA<ChatListLoaded>(),
      ],
    );
  });
}
