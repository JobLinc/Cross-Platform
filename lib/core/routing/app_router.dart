import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/features/chat/ui/screens/chat_list_screen.dart';
import 'package:joblinc/features/chat/ui/screens/chat_screen.dart';
import 'package:joblinc/features/connections/logic/cubit/connections_cubit.dart';
import 'package:joblinc/features/connections/ui/screens/connections.dart';
import 'package:joblinc/features/home/ui/screens/home_screen.dart';
import 'package:joblinc/features/login/logic/cubit/login_cubit.dart';
import 'package:joblinc/features/login/ui/screens/forgetpassword_screen.dart';
import 'package:joblinc/features/login/ui/screens/login_screen.dart';
import 'package:joblinc/features/onboarding/ui/screens/onboarding_screen.dart';
import 'package:joblinc/features/signup/logic/cubit/signup_cubit.dart';
import 'package:joblinc/features/signup/ui/screens/signup_screen.dart';
import 'package:joblinc/features/userprofile/ui/screens/profile_screen.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    //this arguments to be passed in any screen like this ( arguments as ClassName )
    // final arguments = settings.arguments;

    switch (settings.name) {
      case Routes.onBoardingScreen:
        return MaterialPageRoute(builder: (context) => OnboardingScreen());
      case Routes.loginScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<LoginCubit>(),
            child: LoginScreen(),
          ),
        );
      case Routes.signUpScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => getIt<RegisterCubit>(),
                  child: SignupScreen(),
                ));
      case Routes.homeScreen:
        return MaterialPageRoute(builder: (context) => HomeScreen());
      case Routes.profileScreen:
        return MaterialPageRoute(builder: (context) => ProfileScreen());
      case Routes.chatScreen:
        return MaterialPageRoute(builder: (context) => ChatScreen());
      case Routes.forgotPasswordScreen:
        return MaterialPageRoute(builder: (context) => ForgetpasswordScreen());
      case Routes.chatListScreen:
        // return MaterialPageRoute(
        //     builder: (context) => BlocProvider(
        //           create: (context) => getIt<ConnectionsCubit>(),
        //           child: ConnectionPage(
        //             key: Key("connections home screen"),
        //           ),
        //         ));
        return MaterialPageRoute(builder: (context) => ChatListScreen());
      default:
        return null;
    }
  }
}
