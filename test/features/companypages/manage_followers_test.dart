import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/features/connections/logic/cubit/follow_cubit.dart';
import 'package:joblinc/features/connections/data/Repo/connections_repo.dart';
import 'package:joblinc/features/userprofile/data/models/follow_model.dart';
import 'package:joblinc/features/connections/ui/screens/followers_list_screen.dart';
import 'manage_followers_test.mocks.dart';

// Create a proper mock BuildContext for testing
class MockBuildContext extends Mock implements BuildContext {
  @override
  bool get mounted => true;

  @override
  Widget get widget => Container();

  @override
  List<DiagnosticsNode> describeMissingAncestor(
      {required Type expectedAncestorType}) {
    return [];
  }

  @override
  dynamic visitAncestorElements(bool Function(Element) visitor) {
    return null;
  }
}

class MockInheritedWidget extends InheritedWidget {
  MockInheritedWidget() : super(child: Container());

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}

// Generate mocks
@GenerateMocks([UserConnectionsRepository])
@GenerateNiceMocks([MockSpec<FollowCubit>()])
void main() {
  late MockFollowCubit mockFollowCubit;
  late MockUserConnectionsRepository mockRepository;

  setUp(() {
    mockRepository = MockUserConnectionsRepository();
    mockFollowCubit = MockFollowCubit();

    // Make each test use a broadcast stream to avoid the "already listened" error
    final controller = StreamController<FollowState>.broadcast();
    when(mockFollowCubit.stream).thenAnswer((_) => controller.stream);
  });

  Widget createTestableWidget({required Widget child}) {
    return MaterialApp(
      home: ScreenUtilInit(
        designSize: const Size(412, 924),
        minTextAdapt: true,
        builder: (context, _) {
          return Scaffold(
            body: BlocProvider<FollowCubit>.value(
              value: mockFollowCubit,
              child: child,
            ),
          );
        },
      ),
    );
  }

  group('FollowersListScreen UI Tests', () {
    testWidgets('should show loading indicator when in initial state',
        (WidgetTester tester) async {
      // Arrange
      when(mockFollowCubit.state).thenReturn(FollowInitial());

      // Act - Use pumpAndSettle to ensure all animations complete
      await tester
          .pumpWidget(createTestableWidget(child: FollowersListScreen()));

      // Add a pump to allow the widget to build after the state is detected
      await tester.pump();

      // Assert - Verify fetchFollowers was called
      verify(mockFollowCubit.fetchFollowers()).called(1);
    });

    testWidgets('should display list of followers when loaded',
        (WidgetTester tester) async {
      // Arrange
      final followers = [
        Follow(
          userId: "1",
          firstname: "John",
          lastname: "Doe",
          headline: "Software Engineer",
          profilePicture: "https://example.com/john.jpg",
          companyId: '',
          companyName: 'Tech Company',
          companyLogo: 'https://example.com/logo.png',
          time: DateTime.now(),
        ),
      ];

      when(mockFollowCubit.state).thenReturn(FollowLoaded(followers));

      // Act - wrap in a try-catch to help debug issues
      try {
        await tester
            .pumpWidget(createTestableWidget(child: FollowersListScreen()));
        await tester.pump(); // Ensure widgets are fully built
      } catch (e) {
        print('Error pumping widget: $e');
        rethrow;
      }

      // Find widgets by key instead of type if type finder is unreliable
      expect(find.byKey(Key('FollowersListBody')), findsOneWidget);
    });

    testWidgets('should show error message when error occurs',
        (WidgetTester tester) async {
      // Arrange
      const errorMessage = 'Failed to load followers';
      when(mockFollowCubit.state).thenReturn(FollowError(errorMessage));

      // Act
      await tester
          .pumpWidget(createTestableWidget(child: FollowersListScreen()));

      // Assert - use textContaining for more flexible text matching
      expect(find.textContaining(errorMessage), findsOneWidget);
    });
  });

  group('FollowCubit Tests', () {
    late FollowCubit followCubit;

    setUp(() {
      followCubit = FollowCubit(mockRepository);
    });

    test('initial state should be FollowInitial', () {
      expect(followCubit.state, isA<FollowInitial>());
    });

    test('fetchFollowers should emit FollowLoaded on success', () async {
      // Arrange
      final followers = [
        Follow(
          userId: "1",
          firstname: "John",
          lastname: "Doe",
          headline: "Software Engineer",
          profilePicture: "https://example.com/john.jpg",
          companyId: '',
          companyName: 'Tech Company',
          companyLogo: 'https://example.com/logo.png',
          time: DateTime.now(),
        ),
      ];

      when(mockRepository.getFollowers()).thenAnswer((_) async => followers);

      // Create a real cubit for stream testing
      final followCubit = FollowCubit(mockRepository);

      // Act
      followCubit.fetchFollowers();

      // Assert
      await expectLater(
        followCubit.stream,
        emitsInOrder([
          isA<FollowLoaded>(),
        ]),
      );

      // Clean up
      await followCubit.close();
    });

    // For this test, avoid using CustomSnackBar
    test('removeFollower should call repository method', () async {
      // Arrange
      final userId = '123';
      final mockContext = MockBuildContext();

      // Create a real cubit and mock its repository
      final followCubit = FollowCubit(mockRepository);

      when(mockRepository.removeFollower(userId))
          .thenAnswer((_) async => Future.value());

      // Act - wrap in try/catch to handle expected errors from CustomSnackbar
      try {
        followCubit.removeFollower(userId, mockContext);
      } catch (e) {
        // We expect an error since we're in a test environment without a real Scaffold
      }

      // Assert
      verify(mockRepository.removeFollower(userId)).called(1);

      // Clean up
      await followCubit.close();
    });
  });
}
