import 'package:flutter/material.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/helpers/user_service.dart';
import 'package:joblinc/core/theming/font_weight_helper.dart';
import 'package:joblinc/core/widgets/custom_snackbar.dart';
import 'package:joblinc/features/accountvisibility/data/repos/account_visibility_repo.dart';
import 'package:joblinc/features/userprofile/data/repo/user_profile_repository.dart';

Future<dynamic> showAccountVisibilitySettings(BuildContext context) async {
  final AccountVisibility initialVisibility;
  switch (await UserService.getVisibility()) {
    case 'Public':
      initialVisibility = AccountVisibility.public;
      break;
    case 'Connections':
      initialVisibility = AccountVisibility.connectionsOnly;
      break;
    default:
      initialVisibility = AccountVisibility.public;
      break;
  }
  AccountVisibility selectedVisibility = initialVisibility;
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
    try {
      UserProfileRepository repo = getIt<UserProfileRepository>();
      repo.getUserProfile();
    } on Exception catch (e) {
      if (context.mounted) {
        CustomSnackBar.show(
            context: context,
            message: 'Failed to update Account info',
            type: SnackBarType.error);
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
  late AccountVisibility visibility;
  late int selectedIndex;
  void selectOption(int? index) {
    setState(() {
      selectedIndex = index!;
    });
    switch (index) {
      case 0:
        visibility = AccountVisibility.public;
      case 1:
        visibility = AccountVisibility.connectionsOnly;
      default:
        visibility = AccountVisibility.public;
    }
    widget.switchVisibility(visibility);
  }

  @override
  void initState() {
    visibility = widget.initialVisibility;
    switch (visibility) {
      case AccountVisibility.public:
        setState(() {
          selectedIndex = 0;
        });
      case AccountVisibility.connectionsOnly:
        setState(() {
          selectedIndex = 1;
        });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Radio(
                value: 0, groupValue: selectedIndex, onChanged: selectOption),
            title: Text(
              'Public',
              style: TextStyle(fontWeight: FontWeightHelper.semiBold),
            ),
            subtitle: Text(
              'anyone can see profile and send connection requests',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            onTap: () => selectOption(0),
          ),
          ListTile(
            leading: Radio(
                value: 1, groupValue: selectedIndex, onChanged: selectOption),
            title: Text(
              'ConnectionsOnly',
              style: TextStyle(fontWeight: FontWeightHelper.semiBold),
            ),
            subtitle: Text(
              'only connections can see profile and no one can send connections requests',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            onTap: () => selectOption(1),
          ),
        ],
      ),
    );
  }
}

enum AccountVisibility {
  public,
  connectionsOnly,
}
