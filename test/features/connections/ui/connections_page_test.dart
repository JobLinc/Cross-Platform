import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:joblinc/features/connections/data/models/connectiondemoModel.dart';
import 'package:joblinc/features/connections/ui/screens/connections.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/features/connections/logic/cubit/connections_cubit.dart';
import 'package:joblinc/features/connections/ui/screens/connectionList.dart';
import 'package:joblinc/features/connections/ui/screens/connectionSearch.dart';

class MockConnectionsCubit extends MockCubit<ConnectionsState>
    implements ConnectionsCubit {
  List<UserConnection> connections = [];
}

class FakeConnectionsState extends Fake implements ConnectionsState {}

void main() {
  late MockConnectionsCubit mockConnectionsCubit;

  setUpAll(() {
    registerFallbackValue(FakeConnectionsState());
  });

  setUp(() {
    mockConnectionsCubit = MockConnectionsCubit();
    when(() => mockConnectionsCubit.fetchConnections())
        .thenAnswer((_) async {});
  });

  Future<void> pumpConnectionPage(WidgetTester tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: Size(375, 812),
        builder: (context, child) => MaterialApp(
          home: BlocProvider<ConnectionsCubit>.value(
            value: mockConnectionsCubit,
            child: ConnectionPage(),
          ),
        ),
      ),
    );
  }

  group('ConnectionPage Widget Tests', () {
    testWidgets('shows loading indicator when state is ConnectionsInitial',
        (WidgetTester tester) async {
      when(() => mockConnectionsCubit.state).thenReturn(ConnectionsInitial());

      await pumpConnectionPage(tester);
      await tester.pump(); // Ensure UI rebuild

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays error message when state is ConnectionsError',
        (WidgetTester tester) async {
      const errorMessage = 'An error occurred';
      when(() => mockConnectionsCubit.state)
          .thenReturn(ConnectionsError(errorMessage));

      await pumpConnectionPage(tester);
      await tester.pump();

      expect(find.textContaining(errorMessage), findsOneWidget);
    });

    testWidgets('displays connection list when state is ConnectionsLoaded',
        (WidgetTester tester) async {
      final List<UserConnection> connections = [];
      when(() => mockConnectionsCubit.state)
          .thenReturn(ConnectionsLoaded(connections));

      await pumpConnectionPage(tester);
      await tester.pump();

      expect(find.byType(ConnectionList), findsOneWidget);
    });

    testWidgets('navigates to search page when state is SearchState',
        (WidgetTester tester) async {
      final mockConnections = [
        UserConnection(
          userId: '1',
          firstname: 'John',
          lastname: 'Doe',
          headline: 'Software Engineer',
          profilePicture: 'https://example.com/profile.jpg',
          connectionStatus: 'Connected',
          mutualConnections: 5,
        ),
      ];

      when(() => mockConnectionsCubit.state)
          .thenReturn(ConnectionsLoaded(mockConnections));

      when(() => mockConnectionsCubit.fetchConnections()).thenAnswer((_) async {
        mockConnectionsCubit.emit(ConnectionsLoaded(mockConnections));
      });

      whenListen(
        mockConnectionsCubit,
        Stream.fromIterable([
          ConnectionsLoaded(mockConnections),
          SearchState(),
        ]),
        initialState: ConnectionsInitial(),
      );

      await pumpConnectionPage(tester);
      await tester.pumpAndSettle();

      expect(find.byType(Connectionsearch), findsOneWidget);
    });
  });
}
