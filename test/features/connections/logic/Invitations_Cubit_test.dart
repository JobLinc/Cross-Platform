import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:joblinc/features/connections/logic/cubit/invitations_cubit.dart';
import 'package:joblinc/features/connections/data/Web_Services/MockConnectionApiService.dart';
import 'package:joblinc/features/connections/data/models/connectiondemoModel.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';

class MockApiService extends Mock implements MockConnectionApiService {}

class FakeUserConnection extends Fake implements UserConnection {}

void main() {
  late InvitationsCubit invitationsCubit;
  late MockApiService mockApiService;
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() {
    registerFallbackValue(FakeUserConnection());
  });
  setUp(() {
    mockApiService = MockApiService();
    invitationsCubit = InvitationsCubit(mockApiService);
  });

  tearDown(() {
    invitationsCubit.close();
  });

  group('InvitationsCubit Tests', () {
    test('Initial state is InvitationsInitial', () {
      expect(invitationsCubit.state, isA<InvitationsInitial>());
    });

    blocTest<InvitationsCubit, InvitationsState>(
      'emits [InvitationsInitial, InvitationsLoaded] when fetchPendingInvitations succeeds',
      build: () {
        when(() => mockApiService.getPendingInvitations()).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/pending-invitations'),
            statusCode: 200,
            data: [
              {
                "userId": "1",
                "firstname": "John",
                "lastname": "Doe",
                "headline": "Software Engineer",
                "profilePicture": "profile.jpg",
                "connectionStatus": "pending",
                "mutualConnections": 5
              }
            ],
          ),
        );
        return invitationsCubit;
      },
      act: (cubit) => cubit.fetchPendingInvitations(),
      expect: () => [
        isA<InvitationsInitial>(),
        isA<InvitationsLoaded>(),
      ],
      verify: (_) {
        verify(() => mockApiService.getPendingInvitations()).called(1);
      },
    );

    blocTest<InvitationsCubit, InvitationsState>(
      'emits [InvitationsInitial, InvitationsError] when fetchPendingInvitations fails',
      build: () {
        when(() => mockApiService.getPendingInvitations()).thenThrow(
            DioException(
                requestOptions: RequestOptions(path: '/pending-invitations'),
                error: "Failed to fetch pending invitations"));
        return invitationsCubit;
      },
      act: (cubit) => cubit.fetchPendingInvitations(),
      expect: () => [
        isA<InvitationsInitial>(),
        isA<InvitationsError>(),
      ],
      verify: (_) {
        verify(() => mockApiService.getPendingInvitations()).called(1);
      },
    );

    blocTest<InvitationsCubit, InvitationsState>(
    'emits InvitationsInitial after successfully handling an accepted invitation',
    build: () {
      final connection = UserConnection(
        userId: "1",
        firstname: "John",
        lastname: "Doe",
        headline: "Software Engineer",
        profilePicture: "profile.jpg",
        connectionStatus: "pending",
        mutualConnections: 5,
      );

      when(() => mockApiService.addConnection(any<UserConnection>())).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/connections/add'),
          statusCode: 201,
          data: {"status": "success", "message": "Connection added"},
        ),
      );

      when(() => mockApiService.removePendingInvitation(any<String>())).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/pending-invitations/remove'),
          statusCode: 200,
          data: {
            "status": "success",
            "message": "Pending invitation removed"
          },
        ),
      );

      return invitationsCubit;
    },
    act: (cubit) => cubit.handleInvitation(
        UserConnection(
            userId: "1",
            firstname: 'ahmed',
            lastname: "ahmed",
            mutualConnections: 3,
            connectionStatus: "connected",
            headline: "headline",
            profilePicture: ""),
        "Accepted"),
    expect: () => [
      isA<InvitationsInitial>(),
    ],
    verify: (_) {
      verify(() => mockApiService.addConnection(any<UserConnection>())).called(1);
      verify(() => mockApiService.removePendingInvitation(any<String>())).called(1);
    },
  );
    blocTest<InvitationsCubit, InvitationsState>(
      'emits InvitationsError when removing a pending invitation fails',
      build: () {
        final connection = UserConnection(
          userId: "1",
          firstname: "John",
          lastname: "Doe",
          headline: "Software Engineer",
          profilePicture: "profile.jpg",
          connectionStatus: "pending",
          mutualConnections: 5,
        );

        when(() => mockApiService.addConnection(any())).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/connections/add'),
            statusCode: 201,
            data: {"status": "success", "message": "Connection added"},
          ),
        );

        when(() => mockApiService.removePendingInvitation(any())).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/pending-invitations/remove'),
            statusCode: 500,
            data: {"status": "error", "message": "Failed to remove invitation"},
          ),
        );

        return invitationsCubit;
      },
      act: (cubit) => cubit.handleInvitation(
          UserConnection(
              userId: "1",
              firstname: 'ahmed',
              lastname: "ahmed",
              mutualConnections: 3,
              connectionStatus: "connected",
              headline: "headline",
              profilePicture: ""),
          "Accepted"),
      expect: () => [
        isA<InvitationsError>(),
      ],
      verify: (_) {
        verify(() => mockApiService.addConnection(any())).called(1);
        verify(() => mockApiService.removePendingInvitation(any())).called(1);
      },
    );
  });
}
