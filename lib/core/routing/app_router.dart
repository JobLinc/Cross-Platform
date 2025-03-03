import 'package:flutter/material.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/features/chat/ui/screens/chat_screen.dart';
import 'package:joblinc/features/home/ui/screens/home_screen.dart';
import 'package:joblinc/features/login/ui/screens/login_screen.dart';
import 'package:joblinc/features/onboarding/ui/screens/onboarding_screen.dart';
import 'package:joblinc/features/signup/ui/screens/signup_screen.dart';
import 'package:joblinc/features/userprofile/ui/screens/profile_screen.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    //this arguments to be passed in any screen like this ( arguments as ClassName )
    final arguments = settings.arguments;

    switch (settings.name) {
      case Routes.onBoardingScreen:
        return MaterialPageRoute(builder: (context) => OnboardingScreen());
      case Routes.loginScreen:
        return MaterialPageRoute(builder: (context) => LoginScreen());
      case Routes.signUpScreen:
        return MaterialPageRoute(builder: (context) => SignupScreen());
      case Routes.homeScreen:
        return MaterialPageRoute(builder: (context) => HomeScreen());
      case Routes.profileScreen:
        return MaterialPageRoute(builder: (context) => ProfileScreen());
      case Routes.chatScreen:
        return MaterialPageRoute(builder: (context) => ChatScreen());
      default:
        return null;
    }
  }
}
