import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:joblinc/features/connections/data/models/connectiondemoModel.dart';
import 'package:joblinc/features/connections/logic/cubit/invitations_cubit.dart';
import 'package:joblinc/features/connections/ui/widgets/InvitationList.dart';


class MockInvitationsCubit extends MockCubit<InvitationsState> implements InvitationsCubit {}


class FakeUserConnection extends Fake implements UserConnection {}

void main() {
  late MockInvitationsCubit mockInvitationsCubit;
  late List<UserConnection> mockInvitations;

  setUpAll(() {
    registerFallbackValue(FakeUserConnection());
  });

  setUp(() {
    mockInvitationsCubit = MockInvitationsCubit();

    // Stub the stream to prevent null stream issues
    when(() => mockInvitationsCubit.stream)
        .thenAnswer((_) => Stream.value(InvitationsInitial()));

    mockInvitations = [
      UserConnection(
        userId: "1",
        firstname: "John",
        lastname: "Doe",
        headline: "Software Engineer",
        profilePicture: "",
        connectionStatus: "Pending",
        mutualConnections: 3,
      ),
      UserConnection(
        userId: "2",
        firstname: "Jane",
        lastname: "Smith",
        headline: "Product Manager",
        profilePicture: "",
        connectionStatus: "Pending",
        mutualConnections: 5,
      ),
    ];
  });

  testWidgets('InvitationsList widget renders correctly and buttons work',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: Size(412, 924),
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp(
            home: BlocProvider<InvitationsCubit>.value(
              value: mockInvitationsCubit,
              child: Scaffold(
                body: InvitationsList(invitations: mockInvitations),
              ),
            ),
          );
        },
      ),
    );

    await tester.pumpAndSettle();

    // Check if names are displayed
    expect(find.text("John"), findsOneWidget);
    expect(find.text("Jane"), findsOneWidget);

    // Check if accept and deny buttons are present
    expect(find.byKey(Key("invitationslist_accept_button")), findsNWidgets(2));
    expect(find.byKey(Key("invitationslist_delete_button")), findsNWidgets(2));

    // Stub the handleInvitation function
    when(() => mockInvitationsCubit.handleInvitation(any(), any()))
        .thenReturn(null);

    // Tap the accept button of the first invitation
    await tester.tap(find.byKey(Key("invitationslist_accept_button")).first);
    await tester.pump();

    // Verify the call
    verify(() => mockInvitationsCubit.handleInvitation(any<UserConnection>(), "Accepted")).called(1);

    // Tap the deny button of the second invitation
    await tester.tap(find.byKey(Key("invitationslist_delete_button")).last);
    await tester.pump();

    // Verify the call
    verify(() => mockInvitationsCubit.handleInvitation(any<UserConnection>(), "Denied")).called(1);
  });
}
