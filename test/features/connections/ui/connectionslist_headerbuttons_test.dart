import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/features/connections/data/Web_Services/MockConnectionApiService.dart';
import 'package:joblinc/features/connections/data/models/connectiondemoModel.dart';
import 'package:joblinc/features/connections/logic/cubit/connections_cubit.dart';
import 'package:joblinc/features/connections/ui/widgets/connectionHeaderButtons.dart';

void main() {
  testWidgets('connection_Buttons widget renders correctly',
      (WidgetTester tester) async {
    // Create a mock list of connections

    // Build widget with BlocProvider
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: Size(412, 924), // Set the expected design size
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp(
            home: BlocProvider(
              create: (context) => ConnectionsCubit(MockConnectionApiService()),
              child: Scaffold(
                body: connection_Buttons(connections: mockConnections),
              ),
            ),
          );
        },
      ),
    );

    await tester.pumpAndSettle();
    // Check if the connection count is displayed correctly
    expect(find.text("${mockConnections.length} Connection"), findsOneWidget);

    // Check if the search button is present
    expect(find.byKey(Key("connection_search_button")), findsOneWidget);
  });
}
