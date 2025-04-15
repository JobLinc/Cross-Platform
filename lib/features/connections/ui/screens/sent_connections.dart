import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/features/connections/logic/cubit/sent_connections_cubit.dart';
import 'package:joblinc/features/connections/ui/widgets/sent_connections_list.dart';

class sentConnectionPage extends StatelessWidget {
  const sentConnectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SentConnectionsCubit, SentConnectionsState>(
      builder: (context, state) {
        if (state is SentConnectionsInitial) {
          BlocProvider.of<SentConnectionsCubit>(context).fetchSentInvitations();
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  ColorsManager.darkBurgundy), // Change color here
            ),
          );
        } else if (state is SentConnectionsLoaded) {
          return SentConnectionsList(sentInvitations: state.Connections);
        } else if (state is SentConnectionsError) {
          return Center(
            child: Text(state.error),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
