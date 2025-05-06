import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/features/posts/data/models/post_model.dart';
import 'package:joblinc/features/posts/logic/cubit/post_cubit.dart';
import 'package:joblinc/features/posts/logic/cubit/post_state.dart';
import 'package:joblinc/features/posts/ui/widgets/post_widget.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mocktail/mocktail.dart';

class MockPostCubit extends Mock implements PostCubit {}

void main() {
  late MockPostCubit mockPostCubit;

  setUp(() {
    mockPostCubit = MockPostCubit();
    when(() => mockPostCubit.state).thenReturn(PostStateInitial());
    getIt.registerFactory<PostCubit>(() => mockPostCubit);
  });

  tearDown(() {
    getIt.reset();
  });

  Widget createTestWidget(PostModel postModel) {
    return MaterialApp(
      onGenerateRoute: (settings) => MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(child: Text('Navigated to ${settings.name}')),
        ),
      ),
      home: BlocProvider<PostCubit>(
        create: (_) => getIt<PostCubit>(),
        child: Post(data: postModel),
      ),
    );
  }

  group('Post Widget Tests', () {
    testWidgets('Post widget displays post content', (tester) async {
      final mockPost = PostModel(
        postID: '1',
        senderID: '2',
        isCompany: false,
        username: 'Test User',
        headline: 'Test Headline',
        profilePictureURL: '',
        text: 'This is a test post.',
        timeStamp: DateTime.now(),
        attachmentURLs: [],
        commentCount: 0,
        likeCount: 0,
        repostCount: 0,
      );

      when(() => mockPostCubit.state).thenReturn(PostStateInitial());

      await tester.pumpWidget(createTestWidget(mockPost));

      expect(find.text('Test User'), findsOneWidget);
      expect(find.text('This is a test post.'), findsOneWidget);
    });

    testWidgets(
        'Post widget navigates to comment section on comment button tap',
        (tester) async {
      final mockPost = PostModel(
        postID: '1',
        senderID: '2',
        isCompany: false,
        username: 'Test User',
        headline: 'Test Headline',
        profilePictureURL: '',
        text: 'This is a test post.',
        timeStamp: DateTime.now(),
        attachmentURLs: [],
        commentCount: 0,
        likeCount: 0,
        repostCount: 0,
      );

      when(() => mockPostCubit.state).thenReturn(PostStateInitial());

      await tester.pumpWidget(createTestWidget(mockPost));

      final commentButton = find.byKey(Key('post_actionBar_comment'));
      expect(commentButton, findsOneWidget);

      await tester.tap(commentButton);
      await tester.pumpAndSettle();

      expect(find.text('Navigated to /comments'), findsOneWidget);
    });

    testWidgets('Post widget reacts to post on reaction button tap',
        (tester) async {
      final mockPost = PostModel(
        postID: '1',
        senderID: '2',
        isCompany: false,
        username: 'Test User',
        headline: 'Test Headline',
        profilePictureURL: '',
        text: 'This is a test post.',
        timeStamp: DateTime.now(),
        attachmentURLs: [],
        commentCount: 0,
        likeCount: 0,
        repostCount: 0,
      );

      when(() => mockPostCubit.state).thenReturn(PostStateInitial());

      await tester.pumpWidget(createTestWidget(mockPost));

      final reactionButton = find.byType(ReactionButton);
      expect(reactionButton, findsOneWidget);

      await tester.tap(reactionButton);
      await tester.tap(find.byIcon(LucideIcons.thumbsUp));
      await tester.pumpAndSettle();

      verify(() => mockPostCubit.reactToPost(any())).called(1);
    });
  });
}
