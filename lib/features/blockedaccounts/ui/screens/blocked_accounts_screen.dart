import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/core/widgets/loading_overlay.dart';
import 'package:joblinc/features/blockedaccounts/data/models/blocked_account_model.dart';
import 'package:joblinc/features/blockedaccounts/logic/cubit/blocked_accounts_cubit.dart';
import 'package:joblinc/features/blockedaccounts/logic/cubit/blocked_accounts_state.dart';

class BlockedAccountsScreen extends StatelessWidget {
  const BlockedAccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BlockedAccountsCubit, BlockedAccountsState>(
        builder: (context, state) {
      if (state is BlockedAccountsLoading) {
        return Scaffold(
            body: Container(
                color: ColorsManager.getBackgroundColor(context),
                child: Center(
                    child: CircularProgressIndicator(
                  color: ColorsManager.getPrimaryColor(context),
                ))));
      } else if (state is BlockedAccountsFailure) {
        return Center(
          child: Text(
            state.error,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        );
      } else if (state is BlockedAccountsLoaded) {
        return Scaffold(
            appBar: AppBar(
              title: Text('Blocked Accounts'),
            ),
            body: (state.blockedAccounts.length > 0)
                ? ListView.builder(
                    itemCount: state.blockedAccounts.length,
                    itemBuilder: (context, index) {
                      final BlockedAccountModel blockedAccount =
                          state.blockedAccounts[index];
                      ListTile(
                        title: Text(
                            '${blockedAccount.firstName} ${blockedAccount.lastName}'),
                        subtitle: Text(
                            '${blockedAccount.mutualConnections} mutual connections'),
                        trailing: TextButton(
                            onPressed: () {}, child: Text('Unblock')),
                      );
                    })
                : Center(
                    child: Text('No Blocked Accounts.'),
                  ));
      } else {
        return Center(
          child: Text(
            "error occured",
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        );
      }
    });
  }
}
