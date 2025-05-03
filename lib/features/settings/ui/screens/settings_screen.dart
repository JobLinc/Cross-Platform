import 'package:flutter/material.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/helpers/auth_helpers/auth_service.dart';
import 'package:joblinc/core/helpers/user_service.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/features/accountvisibility/ui/screens/account_visibility_screen.dart';
import 'package:joblinc/features/notifications/data/services/device_token_service.dart';
import 'package:joblinc/features/notifications/data/services/firebase_messaging_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign in & security'),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Text(
              'Privacy',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          ListTile(
            title: const Text('Account Visibility'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              showAccountVisibilitySettings(context);
            },
          ),
          ListTile(
            title: const Text('Blocked Accounts'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.pushNamed(context, Routes.blockedConnectionsList);
            },
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Text(
              'Account access',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          ListTile(
            title: const Text('Change Email addresses'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.pushNamed(context, Routes.changeEmailScreen);
            },
          ),
          ListTile(
            title: const Text('Change Password'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.pushNamed(context, Routes.changePasswordScreen);
            },
          ),
          ListTile(
            title: const Text('Change Username'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.pushNamed(context, Routes.changeUsernameScreen);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              AuthService authService = getIt<AuthService>();
              authService.clearUserInfo();
              UserService.clearUserData();  
              FirebaseMessagingService deviceTokenService = getIt<FirebaseMessagingService>();
              deviceTokenService.unregisterToken();
              Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.loginScreen,
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
