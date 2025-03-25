import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:joblinc/features/connections/logic/cubit/connections_cubit.dart';
import 'package:joblinc/features/connections/data/models/connectiondemoModel.dart';
import 'package:joblinc/features/connections/data/Web_Services/MockConnectionApiService.dart';

class MockApiService extends Mock implements MockConnectionApiService {}

class FakeUserConnection extends Fake implements UserConnection {}

void main() {
  late ConnectionsCubit connectionsCubit;
  late MockApiService mockApiService;
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() {
    registerFallbackValue(FakeUserConnection());
  });

  setUp(() {
    mockApiService = MockApiService();
    connectionsCubit = ConnectionsCubit(mockApiService);
  });

  tearDown(() {
    connectionsCubit.close();
  });

  group('ConnectionsCubit Tests', () {
    test('initial state is ConnectionsInitial', () {
      expect(connectionsCubit.state, isA<ConnectionsInitial>());
    });

    blocTest<ConnectionsCubit, ConnectionsState>(
      'emits [ConnectionsInitial, ConnectionsLoaded] when fetchConnections succeeds',
      build: () {
        when(() => mockApiService.getConnections()).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/connections'),
            statusCode: 200,
            data: [
              {
                "userId": "1",
                "firstname": "John",
                "lastname": "Doe",
                "headline": "Software Engineer",
                "profilePicture": "profile.jpg",
                "connectionStatus": "connected",
                "mutualConnections": 5,
              }
            ],
          ),
        );
        return connectionsCubit;
      },
      act: (cubit) => cubit.fetchConnections(),
      expect: () => [
        isA<ConnectionsInitial>(),
        isA<ConnectionsLoaded>(),
      ],
      verify: (_) {
        verify(() => mockApiService.getConnections()).called(1);
      },
    );

    blocTest<ConnectionsCubit, ConnectionsState>(
      'emits [ConnectionsInitial, ConnectionsError] when fetchConnections fails',
      build: () {
        when(() => mockApiService.getConnections()).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/connections'),
            statusCode: 500,
            data: {"error": "Server error"},
          ),
        );
        return connectionsCubit;
      },
      act: (cubit) => cubit.fetchConnections(),
      expect: () => [
        isA<ConnectionsInitial>(),
        isA<ConnectionsError>(),
      ],
      verify: (_) {
        verify(() => mockApiService.getConnections()).called(1);
      },
    );

    blocTest<ConnectionsCubit, ConnectionsState>(
      'removes a connection and refetches connections',
      build: () {
        when(() => mockApiService.removeConnection(any<String>())).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/connections/remove'),
            statusCode: 200,
            data: {"status": "success", "message": "Connection removed"},
          ),
        );

        when(() => mockApiService.getConnections()).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/connections'),
            statusCode: 200,
            data: [],
          ),
        );

        return connectionsCubit;
      },
      act: (cubit) => cubit.removeConnection(
        UserConnection(
          userId: "1",
          firstname: "John",
          lastname: "Doe",
          headline: "Software Engineer",
          profilePicture: "profile.jpg",
          connectionStatus: "connected",
          mutualConnections: 5,
        ),
      ),
      expect: () => [
        isA<ConnectionsInitial>(), // fetchConnections emits initial first
        isA<ConnectionsLoaded>(), // After fetching, it should be empty
      ],
      verify: (_) {
        verify(() => mockApiService.removeConnection(any<String>())).called(1);
        verify(() => mockApiService.getConnections()).called(1);
      },
    );
  });
}
