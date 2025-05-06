import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:joblinc/core/widgets/loading_overlay.dart';
import 'package:joblinc/features/posts/ui/screens/add_post.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/features/posts/logic/cubit/add_post_cubit.dart';
import 'package:joblinc/features/posts/logic/cubit/add_post_state.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';

// Mock class for AddPostCubit
class MockAddPostCubit extends MockCubit<AddPostState>
    implements AddPostCubit {}

void main() {
  late MockAddPostCubit mockCubit;

  setUp(() {
    mockCubit = MockAddPostCubit();
    when(() => mockCubit.state).thenReturn(AddPostStateInitial());
  });

  group('AddPostScreen', () {
    testWidgets('displays input and Post button', (WidgetTester tester) async {
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: Size(412, 924),
          minTextAdapt: true,
          builder: (context, child) => MaterialApp(
            home: BlocProvider<AddPostCubit>(
              create: (_) => mockCubit,
              child: AddPostScreen(),
            ),
          ),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Post'), findsOneWidget);
    });

    testWidgets('Post button is disabled when no text is entered',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: Size(412, 924),
          minTextAdapt: true,
          builder: (context, child) => MaterialApp(
            home: BlocProvider<AddPostCubit>(
              create: (_) => mockCubit,
              child: AddPostScreen(),
            ),
          ),
        ),
      );

      // The Post button should be disabled initially
      final postButton =
          tester.widget<TextButton>(find.widgetWithText(TextButton, 'Post'));
      expect(postButton.onPressed, isNull);

      await tester.tap(find.text('Post'));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets(
        'Tapping Post button triggers addPost and shows loading, then success',
        (WidgetTester tester) async {
      whenListen(
        mockCubit,
        Stream.fromIterable([
          AddPostStateLoading(),
          AddPostStateSuccess(),
        ]),
        initialState: AddPostStateInitial(),
      );
      when(() => mockCubit.addPost(any(), any(), any(), any()))
          .thenAnswer((_) async {});

      await tester.pumpWidget(
        ScreenUtilInit(
          minTextAdapt: true,
          builder: (context, child) => MaterialApp(
            routes: {
              '/': (context) => BlocProvider<AddPostCubit>(
                    create: (_) => mockCubit,
                    child: AddPostScreen(),
                  ),
              // Mock homeScreen route for navigation
              '/homeScreen': (context) =>
                  const Scaffold(body: Text('HomeScreen')),
            },
            initialRoute: '/',
          ),
        ),
      );
      await tester.pumpAndSettle();

      //find text field
      final textField = find.ancestor(
        of: find.text('Share your thoughts... Use @ to tag'),
        matching: find.byType(TextField),
      );

      // Enter text to enable the Post button
      await tester.enterText(textField, 'Hello world');
      await tester.pump();

      // Tap the Post button
      await tester.tap(find.text('Post'));
      await tester.pump(); // Start loading

      // Should show loading overlay
      expect(find.byType(LoadingIndicatorOverlay), findsOneWidget);

      // Simulate success state and pump for snackbar and navigation
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();

      // Should show success snackbar
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Post successful'), findsOneWidget);

      // Should navigate to home screen
      expect(find.text('HomeScreen'), findsOneWidget);
    });

    testWidgets(
        'Tapping Post button triggers addPost and shows failure snackbar',
        (WidgetTester tester) async {
      whenListen(
        mockCubit,
        Stream.fromIterable([
          AddPostStateLoading(),
          AddPostStateFailure('Failed to post'),
        ]),
        initialState: AddPostStateInitial(),
      );
      when(() => mockCubit.addPost(any(), any(), any(), any()))
          .thenAnswer((_) async {});

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: Size(412, 924),
          minTextAdapt: true,
          builder: (context, child) => MaterialApp(
            home: BlocProvider<AddPostCubit>(
              create: (_) => mockCubit,
              child: AddPostScreen(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Enter text to enable the Post button
      await tester.enterText(find.byType(TextField), 'Hello error');
      await tester.pump();

      // Tap the Post button
      await tester.tap(find.text('Post'));
      await tester.pump(); // Start loading

      // Should show loading overlay
      expect(find.byType(LoadingIndicatorOverlay), findsOneWidget);

      // Simulate failure state and pump for snackbar
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();

      // Should show error snackbar
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.textContaining('Failed to post'), findsOneWidget);
    });
  });
}
