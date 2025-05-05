import 'dart:math';

import 'package:flutter/material.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/helpers/auth_helpers/auth_service.dart';
import 'package:joblinc/core/helpers/user_service.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/widgets/custom_snackbar.dart';
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
              FirebaseMessagingService deviceTokenService =
                  getIt<FirebaseMessagingService>();
              deviceTokenService.unregisterToken();
              Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.loginScreen,
                (route) => false,
              );
            },
          ),
          Expanded(
              child:
                  SizedBox()), // To push the delete account button to the bottom
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Delete Account'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  final TextEditingController passwordController =
                      TextEditingController();
                  return AlertDialog(
                    title: const Text('Delete Account'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Are you sure you want to delete your account? This action cannot be undone.',
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Please enter your password to confirm:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: 'Password',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Validate password is not empty
                          if (passwordController.text.trim().isEmpty) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: const Text(
                                        'Please enter your password.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                });
                            return;
                          }

                          // Show loading indicator
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );

                          // Get the auth service and call deleteAccount
                          final AuthService authService = getIt<AuthService>();
                          authService
                              .deleteAccount(passwordController.text)
                              .then((response) {
                            // Close loading indicator
                            Navigator.of(context).pop();

                            if (response['success']) {
                              // Clear user data
                              UserService.clearUserData();
                              FirebaseMessagingService deviceTokenService =
                                  getIt<FirebaseMessagingService>();
                              deviceTokenService.unregisterToken();

                              // Close the delete confirmation dialog
                              Navigator.of(context).pop();

                              // Show success message and navigate to login
                              CustomSnackBar.show(context: context, message: "Account deleted successfully" , type: SnackBarType.info);

                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                Routes.loginScreen,
                                (route) => false,
                              );
                            } else {
                              // Show error message
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Error'),
                                  content: Text(response['message']),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          }).catchError((error) {
                            // Close loading indicator
                            Navigator.of(context).pop();

                            // Show error message
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Error'),
                                content: Text('Failed to delete account: $error'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          });
                        },
                        child: const Text('Delete'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
