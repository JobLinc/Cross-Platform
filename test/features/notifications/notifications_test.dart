import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:joblinc/core/services/navigation_service.dart';
import 'package:joblinc/features/notifications/data/models/notification_model.dart';
import 'package:joblinc/features/notifications/logic/cubit/notification_cubit.dart';
import 'package:joblinc/features/notifications/logic/cubit/notification_state.dart';
import 'package:joblinc/features/notifications/ui/screens/notifications_screen.dart';

// ------------------
// Mock & Fake Classes
// ------------------

class MockNotificationCubit extends MockCubit<NotificationState>
    implements NotificationCubit {}

class MockNavigationService extends Mock implements NavigationService {
  static final MockNavigationService _instance =
      MockNavigationService._internal();

  factory MockNavigationService() {
    return _instance;
  }

  MockNavigationService._internal();

  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // This allows us to make NavigationService.instance = mockNavigationService work
  static MockNavigationService get instance => _instance;
  static set instance(MockNavigationService value) {}
}

class FakeNotificationState extends Fake implements NotificationState {}

void main() {
  late MockNotificationCubit mockNotificationCubit;
  late MockNavigationService mockNavigationService;

  // Sample notification data for different notification types
  final sampleNotifications = [
    NotificationModel(
      id: '1',
      content: 'User1 sent you a connection request',
      type: 'ConnectionRequest',
      isRead: 'pending',
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      relatedEntityId: 'user1',
      subRelatedEntityId: 'conn1',
    ),
    NotificationModel(
      id: '2',
      content: 'New job matching your profile',
      type: 'PostNewJob',
      isRead: 'read',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      relatedEntityId: 'job1',
    ),
    NotificationModel(
      id: '3',
      content: 'Someone liked your post',
      type: 'Like',
      isRead: 'pending',
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      relatedEntityId: 'post1',
    ),
    NotificationModel(
      id: '4',
      content: 'New message from User2',
      type: 'Message',
      isRead: 'pending',
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      relatedEntityId: 'chat1',
    ),
  ];

  setUpAll(() {
    registerFallbackValue(FakeNotificationState());
    registerFallbackValue(NotificationModel(
      id: '1',
      content: 'Test',
      type: 'test',
      isRead: 'pending',
      createdAt: DateTime.now(),
    ));
  });

  setUp(() {
    mockNotificationCubit = MockNotificationCubit();
    mockNavigationService = MockNavigationService();

    // Default state and behavior for NotificationCubit
    when(() => mockNotificationCubit.state).thenReturn(NotificationInitial());
    when(() => mockNotificationCubit.getNotifications())
        .thenAnswer((_) async {});
    when(() => mockNotificationCubit.initSocket()).thenAnswer((_) {});
    when(() => mockNotificationCubit.markAsRead(any()))
        .thenAnswer((_) async {});
    when(() => mockNotificationCubit.getUnseenCount())
        .thenAnswer((_) async => 2);

    // Mock all navigation methods from NavigationService
    when(() => mockNavigationService.notificationNavigator(any()))
        .thenAnswer((_) {});
    when(() => mockNavigationService.navigateToUserProfileSafely(any()))
        .thenAnswer((_) => Future.value());
    when(() => mockNavigationService.navigateToFocusPostSafely(any()))
        .thenAnswer((_) => Future.value());
    when(() => mockNavigationService.navigateToMainContainer(any()))
        .thenAnswer((_) => Future.value());
    when(() => mockNavigationService.navigateToChatScreenSafely(any()))
        .thenAnswer((_) => Future.value());

    // Set up default stream of states
    whenListen(
      mockNotificationCubit,
      Stream<NotificationState>.fromIterable([NotificationInitial()]),
    );
  });

  Future<void> pumpNotificationsScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(412, 924),
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp(
            home: BlocProvider<NotificationCubit>.value(
              value: mockNotificationCubit,
              child: const NotificationsScreen(),
            ),
          );
        },
      ),
    );
  }

  group('NotificationsScreen Widget Tests', () {
    testWidgets('displays loading indicator when state is NotificationLoading',
        (WidgetTester tester) async {
      // Arrange
      when(() => mockNotificationCubit.state).thenReturn(NotificationLoading());
      whenListen(
        mockNotificationCubit,
        Stream<NotificationState>.fromIterable([NotificationLoading()]),
      );

      // Act
      await pumpNotificationsScreen(tester);

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays error message when state is NotificationError',
        (WidgetTester tester) async {
      // Arrange
      const errorMessage = 'Network error';
      when(() => mockNotificationCubit.state).thenReturn(
        NotificationError(errorMessage),
      );
      whenListen(
        mockNotificationCubit,
        Stream<NotificationState>.fromIterable(
            [NotificationError(errorMessage)]),
      );

      // Act
      await pumpNotificationsScreen(tester);

      // Assert
      expect(find.text('Failed to load notifications'), findsOneWidget);
      expect(find.text(errorMessage), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('displays empty state message when no notifications',
        (WidgetTester tester) async {
      // Arrange
      when(() => mockNotificationCubit.state).thenReturn(
        NotificationLoaded([]),
      );
      whenListen(
        mockNotificationCubit,
        Stream<NotificationState>.fromIterable([NotificationLoaded([])]),
      );

      // Act
      await pumpNotificationsScreen(tester);

      // Assert
      expect(find.text('No notifications yet'), findsOneWidget);
    });

    testWidgets(
        'displays notifications list when state is NotificationLoaded with data',
        (WidgetTester tester) async {
      // Arrange
      when(() => mockNotificationCubit.state).thenReturn(
        NotificationLoaded(sampleNotifications),
      );
      whenListen(
        mockNotificationCubit,
        Stream<NotificationState>.fromIterable(
            [NotificationLoaded(sampleNotifications)]),
      );

      // Act
      await pumpNotificationsScreen(tester);

      // Assert
      expect(find.byType(NotificationTile), findsNWidgets(4));
      expect(find.text('User1 sent you a connection request'), findsOneWidget);
      expect(find.text('New job matching your profile'), findsOneWidget);
      expect(find.text('Someone liked your post'), findsOneWidget);
      expect(find.text('New message from User2'), findsOneWidget);
    });

    testWidgets('retry button calls getNotifications when in error state',
        (WidgetTester tester) async {
      // Arrange
      when(() => mockNotificationCubit.state).thenReturn(
        NotificationError('Error loading data'),
      );
      whenListen(
        mockNotificationCubit,
        Stream<NotificationState>.fromIterable(
            [NotificationError('Error loading data')]),
      );

      // Act
      await pumpNotificationsScreen(tester);
      await tester.tap(find.text('Retry'));
      await tester.pump();

      // Assert
      verify(() => mockNotificationCubit.getNotifications())
          .called(2); // Initial + retry
    });

    testWidgets('initiates socket connection on screen load',
        (WidgetTester tester) async {
      // Arrange
      when(() => mockNotificationCubit.state).thenReturn(NotificationInitial());

      // Act
      await pumpNotificationsScreen(tester);

      // Assert
      verify(() => mockNotificationCubit.initSocket()).called(1);
    });
  });
}
