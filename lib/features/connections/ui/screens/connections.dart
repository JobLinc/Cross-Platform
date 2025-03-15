import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/features/connections/logic/cubit/connections_cubit.dart';
import 'package:joblinc/features/connections/ui/screens/connectionList.dart';
import 'package:joblinc/features/connections/ui/screens/connectionSearch.dart';

class ConnectionPage extends StatelessWidget {
  const ConnectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ConnectionsCubit, ConnectionsState, bool>(
      selector: (state) {
        return state is SearchState; // Only cares about this condition
      },
      builder: (context, isSearch) {
        return isSearch ? Connectionsearch() : ConnectionList();
      },
    );
  }
}
