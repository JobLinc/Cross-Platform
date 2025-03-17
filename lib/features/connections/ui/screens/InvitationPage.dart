import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/features/connections/logic/cubit/connections_cubit.dart';
import 'package:joblinc/features/connections/ui/widgets/InvitationList.dart';

class InvitationPage extends StatelessWidget {
  const InvitationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Invitations',
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
        leading: IconButton(
          key: Key("Invitations Page back icon"),
          icon: Icon(
            Icons.arrow_back,
            size: 20.sp,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: BlocBuilder<ConnectionsCubit, ConnectionsState>(
        builder: (context, state) {
          return InvitationsList(key: Key("the Invitation List and buttons"),
            invitations:
                BlocProvider.of<ConnectionsCubit>(context).pendingconnections,
          );
        },
      ),
    );
  }
}
