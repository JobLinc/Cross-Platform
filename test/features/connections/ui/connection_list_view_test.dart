import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/features/connections/data/Web_Services/MockConnectionApiService.dart';
import 'package:joblinc/features/connections/data/models/connectiondemoModel.dart';
import 'package:joblinc/features/connections/logic/cubit/connections_cubit.dart';
import 'package:joblinc/features/connections/ui/widgets/connectionsListWidget.dart';

void main() {
  testWidgets(
      'connections_List_View renders correctly without throwing an exception',
      (WidgetTester tester) async {
    final List<UserConnection> mockConnections = [
      UserConnection(
        userId: "1",
        firstname: "John",
        lastname: "Doe",
        headline: "Software Engineer",
        profilePicture: "https://www.example.com",
        connectionStatus: "Connected",
        mutualConnections: 5,
      ),
      UserConnection(
        userId: "2",
        firstname: "Jane",
        lastname: "Smith",
        headline: "Product Manager",
        profilePicture: "https://www.example.com",
        connectionStatus: "Connected",
        mutualConnections: 2,
      ),
    ];

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: Size(412, 924), // Set your design size
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp(
            home: BlocProvider(
              create: (context) => ConnectionsCubit(MockConnectionApiService()),
              child: Scaffold(
                body: ConnectionsListView(connections: mockConnections),
              ),
            ),
          );
        },
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text("John Doe"), findsOneWidget);
    expect(find.text("Jane Smith"), findsOneWidget);

    expect(find.text("Software Engineer"), findsOneWidget);
    expect(find.text("Product Manager"), findsOneWidget);

    // Verify that chat and more buttons exist
    expect(find.byKey(Key("connection_chat_button")), findsNWidgets(2));
    expect(find.byKey(Key("connection_more_button")), findsNWidgets(2));
  });
}
