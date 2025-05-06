import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:joblinc/features/posts/data/models/comment_model.dart';
import 'package:joblinc/features/posts/data/models/tagged_entity_model.dart';
import 'package:joblinc/features/posts/data/repos/comment_repo.dart';
import 'package:joblinc/features/posts/data/services/tag_suggestion_service.dart';
import 'package:joblinc/features/posts/ui/widgets/comment_section.dart';
import 'package:mocktail/mocktail.dart';

class MockCommentRepo extends Mock implements CommentRepo {
  Future<List<CommentModel>> getComments(String postId);
  Future<String> addComment(String postId, String text,
      {List<TaggedEntity>? taggedCompanies, List<TaggedEntity>? taggedUsers});
}

class MockTagSuggestionService extends Mock implements TagSuggestionService {}

void main() {
  late MockCommentRepo mockCommentRepo;
  late MockTagSuggestionService mockTagSuggestionService;
  late List<CommentModel> initialComments;
  final getIt = GetIt.instance;

  setUp(() {
    mockCommentRepo = MockCommentRepo();
    mockTagSuggestionService = MockTagSuggestionService();
    initialComments = [
      mockCommentData.copyWith(commentID: '1', text: 'First comment'),
      mockCommentData.copyWith(commentID: '2', text: 'Second comment'),
    ];

    // Mock the tag suggestion service to return empty lists
    when(() => mockTagSuggestionService.getUserSuggestions(any()))
        .thenAnswer((_) async => []);
    when(() => mockTagSuggestionService.getCompanySuggestions(any()))
        .thenAnswer((_) async => []);
    getIt.registerSingleton<TagSuggestionService>(mockTagSuggestionService);
    getIt.registerSingleton<CommentRepo>(mockCommentRepo);
  });

  tearDown(() {
    getIt.reset();
  });

  group('CommentSection', () {
    late Widget commentSectionWidget;

    setUp(() {
      commentSectionWidget = ScreenUtilInit(
        designSize: Size(800, 600),
        minTextAdapt: true,
        builder: (context, child) => MaterialApp(
          home: CommentSection(
            postId: 'post1',
            comments: initialComments,
          ),
        ),
      );
    });

    testWidgets('displays initial comments', (WidgetTester tester) async {
      await tester.pumpWidget(commentSectionWidget);

      expect(find.text('First comment'), findsOneWidget);
      expect(find.text('Second comment'), findsOneWidget);
    });

    testWidgets('displays "No comments yet" when no comments are provided',
        (WidgetTester tester) async {
      commentSectionWidget = MaterialApp(
        home: CommentSection(
          postId: 'post1',
          comments: [],
        ),
      );

      await tester.pumpWidget(commentSectionWidget);

      expect(find.text('No comments yet'), findsOneWidget);
    });

    testWidgets('adds a new comment and updates the list',
        (WidgetTester tester) async {
      when(() => mockCommentRepo.addComment(any(), any()))
          .thenAnswer((_) async => 'newCommentId');
      when(() => mockCommentRepo.getComments(any())).thenAnswer((_) async => [
            ...initialComments,
            mockCommentData.copyWith(commentID: '3', text: 'New comment'),
          ]);

      await tester.pumpWidget(commentSectionWidget);

      // Enter a new comment
      await tester.enterText(find.byType(TextField), 'New comment');
      await tester.tap(find.byIcon(Icons.send));
      await tester.pumpAndSettle();

      // Verify the new comment is displayed
      expect(find.text('New comment'), findsOneWidget);
    });

    testWidgets('shows error snackbar when adding a comment fails',
        (WidgetTester tester) async {
      when(() => mockCommentRepo.addComment(any(), any()))
          .thenThrow(Exception('Failed to add comment'));

      await tester.pumpWidget(commentSectionWidget);

      // Enter a new comment
      await tester.enterText(find.byType(TextField), 'New comment');
      await tester.tap(find.byIcon(Icons.send));
      await tester.pumpAndSettle();

      // Verify the error snackbar is displayed
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.textContaining('Failed to add comment'), findsOneWidget);
    });
  });
}
