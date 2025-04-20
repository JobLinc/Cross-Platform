import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/theming/colors.dart';

import 'package:joblinc/features/connections/logic/cubit/connections_cubit.dart';
import 'package:joblinc/features/connections/logic/cubit/invitations_cubit.dart';
import 'package:joblinc/features/connections/ui/widgets/InvitationList.dart';

class InvitationPage extends StatelessWidget {
  const InvitationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<InvitationsCubit, InvitationsState>(
        builder: (context, state) {
          if (state is InvitationsInitial) {
            BlocProvider.of<InvitationsCubit>(context)
                .fetchPendingInvitations();
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    ColorsManager.darkBurgundy), // Change color here
              ),
            );
          } else if (state is InvitationsLoaded) {
            return InvitationsList(
                key: Key("the Invitation List and buttons"),
                invitations: state.Connections
                // BlocProvider.of<ConnectionsCubit>(context).pendingconnections,
                );
          } else if (state is InvitationsError) {
            return Center(
              child: Text(state.error),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
