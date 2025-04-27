import 'package:flutter/material.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/widgets/custom_snackbar.dart';
import 'package:joblinc/features/accountvisibility/data/repos/account_visibility_repo.dart';

Future<dynamic> showAccountVisibilitySettings(BuildContext context) {
  final AccountVisibility initialVisibility = AccountVisibility.public;
  AccountVisibility selectedVisibility = AccountVisibility.connectionsOnly;
  return showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) => AccountVisibilityScreen(
            initialVisibility: initialVisibility,
            switchVisibility: (visibility) => selectedVisibility = visibility,
          )).whenComplete(() {
    if (selectedVisibility != initialVisibility) {
      try {
        getIt
            .get<AccountVisibilityRepo>()
            .setAccountVisibility(selectedVisibility);
        if (context.mounted) {
          CustomSnackBar.show(
              context: context,
              message: 'Visibility changed successfully',
              type: SnackBarType.success);
        }
      } on Exception catch (e) {
        if (context.mounted) {
          CustomSnackBar.show(
              context: context,
              message: 'Failed to change Visibility',
              type: SnackBarType.error);
        }
      }
    }
  });
}

class AccountVisibilityScreen extends StatefulWidget {
  const AccountVisibilityScreen(
      {super.key,
      required this.switchVisibility,
      required this.initialVisibility});
  final void Function(AccountVisibility) switchVisibility;
  final AccountVisibility initialVisibility;

  @override
  State<AccountVisibilityScreen> createState() =>
      _AccountVisibilityScreenState();
}

class _AccountVisibilityScreenState extends State<AccountVisibilityScreen> {
  late final AccountVisibility visibility;

  @override
  void initState() {
    visibility = widget.initialVisibility;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(),
        ListTile(),
      ],
    );
  }
}

enum AccountVisibility {
  public,
  connectionsOnly,
}
