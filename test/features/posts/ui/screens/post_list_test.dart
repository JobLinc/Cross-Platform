import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:joblinc/features/posts/data/models/post_model.dart';
import 'package:joblinc/features/posts/logic/cubit/post_cubit.dart';
import 'package:joblinc/features/posts/logic/cubit/post_state.dart';
import 'package:joblinc/features/posts/ui/widgets/post_list.dart';
import 'package:mocktail/mocktail.dart';

class MockPostCubit extends MockCubit<PostState> implements PostCubit {}

void main() {
  final getIt = GetIt.instance;
  late MockPostCubit mockPostCubit;

  setUp(() {
    // Register mock PostCubit in GetIt
    mockPostCubit = MockPostCubit();
    when(() => mockPostCubit.state).thenReturn(PostStateInitial());
    getIt.registerFactory<PostCubit>(() => mockPostCubit);
  });

  tearDown(() {
    getIt.reset();
  });

  group('PostList', () {
    testWidgets('PostList displays posts when list is not empty',
        (WidgetTester tester) async {
      final posts = [mockPostData, mockPostData];

      await tester.pumpWidget(
        ScreenUtilInit(
          child: MaterialApp(
            home: Scaffold(
              body: PostList(posts: posts),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(mockPostData.username), findsNWidgets(2));
    });

    testWidgets('PostList displays "No posts yet" when list is empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PostList(posts: []),
          ),
        ),
      );

      expect(find.text('No posts yet'), findsOneWidget);
    });
  });
}
