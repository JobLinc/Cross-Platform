import 'package:flutter/material.dart';
import 'package:joblinc/core/routing/routes.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
            child: Column(
          children: [
            const Text('Onboarding Screen'),

            // Navigations for testing screens while working on the app (will be removed later)
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.loginScreen);
                },
                child: const Text('Login')),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.signUpScreen);
                },
                child: const Text('Signup')),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.homeScreen);
                },
                child: const Text('Home')),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.profileScreen);
                },
                child: const Text('Profile')),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.chatScreen);
                },
                child: const Text('Chat')),
          ],
        )),
      ),
    );
  }
}
