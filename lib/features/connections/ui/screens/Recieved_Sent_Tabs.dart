import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/core/widgets/universal_bottom_bar.dart';
import 'package:joblinc/features/connections/logic/cubit/invitations_cubit.dart';
import 'package:joblinc/features/connections/logic/cubit/sent_connections_cubit.dart';
import 'package:joblinc/features/connections/ui/screens/InvitationPage.dart';
import 'package:joblinc/features/connections/ui/screens/sent_connections.dart';

class InvitationsTabs extends StatelessWidget {
  const InvitationsTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: TabBar(
          labelColor: ColorsManager.darkBurgundy,
          unselectedLabelColor: Colors.black,
          indicatorColor: ColorsManager.darkBurgundy,
          tabs: [
            Tab(text: "Received"),
            Tab(text: "Sent"),
          ],
        ),
        body: TabBarView(
          children: [
            BlocProvider(
              create: (context) => getIt<InvitationsCubit>(),
              child: InvitationPage(
                key: Key("pending_invitations_page"),
              ),
            ),
            // Center(
            //   child: Text("sent Invitations"),
            // ),
            BlocProvider(
                create: (context) => getIt<SentConnectionsCubit>(),
                child: sentConnectionPage(
                  key: Key("sent_connections_page"),
                )),
          ],
        ),
      ),
    );
  }
}
