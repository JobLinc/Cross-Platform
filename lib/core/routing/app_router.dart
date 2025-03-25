import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/features/changepassword/logic/cubit/change_password_cubit.dart';
import 'package:joblinc/features/changepassword/ui/screens/changepassword_screen.dart';
import 'package:joblinc/features/chat/logic/cubit/chat_list_cubit.dart';
import 'package:joblinc/features/chat/ui/screens/chat_list_screen.dart';
import 'package:joblinc/features/chat/ui/screens/chat_screen.dart';
import 'package:joblinc/features/companyPages/ui/screens/company_home.dart';
import 'package:joblinc/features/connections/logic/cubit/connections_cubit.dart';
import 'package:joblinc/features/connections/ui/screens/connectionList.dart';
import 'package:joblinc/features/connections/ui/screens/connections.dart';
import 'package:joblinc/features/forgetpassword/logic/cubit/forget_password_cubit.dart';

import 'package:joblinc/features/home/ui/screens/home_screen.dart';
import 'package:joblinc/features/jobs/ui/screens/job_list_screen.dart';
import 'package:joblinc/features/jobs/ui/screens/job_search_screen.dart';
import 'package:joblinc/features/login/logic/cubit/login_cubit.dart';
import 'package:joblinc/features/forgetpassword/ui/screens/forgetpassword_screen.dart';
import 'package:joblinc/features/login/ui/screens/login_screen.dart';
import 'package:joblinc/features/onboarding/ui/screens/onboarding_screen.dart';
import 'package:joblinc/features/posts/logic/cubit/add_post_cubit.dart';
import 'package:joblinc/features/posts/ui/screens/add_post.dart';
import 'package:joblinc/features/settings/ui/screens/settings_screen.dart';
import 'package:joblinc/features/signup/logic/cubit/signup_cubit.dart';
import 'package:joblinc/features/signup/ui/screens/signup_screen.dart';
import 'package:joblinc/features/companyPages/ui/screens/company_card.dart';
import 'package:joblinc/features/userprofile/ui/screens/profile_screen.dart';
import 'package:joblinc/features/premium/ui/screens/premium_screen.dart';
import 'package:joblinc/features/companyPages/data/data/company.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;

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
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<ForgetPasswordCubit>(),
            child: ForgotPasswordSteps(),
          ),
        );
      case Routes.chatListScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<ChatListCubit>(),
            child: ChatListScreen(),
          ),
        );

      case Routes.jobListScreen:
        return MaterialPageRoute(builder: (context) => JobListScreen());
      case Routes.jobSearchScreen:
        return MaterialPageRoute(builder: (context) => JobSearchScreen());
      case Routes.premiumScreen:
        return MaterialPageRoute(builder: (context) => PremiumScreen());
      case Routes.companyListScreen:
        return MaterialPageRoute(builder: (context) => CompanyList());

      case Routes.companyPageHome:
        if (arguments is Company) {
          return MaterialPageRoute(
            builder: (context) => CompanyPageHome(company: arguments),
          );
        } else {
          return MaterialPageRoute(
            builder: (context) => Scaffold(
              body: Center(
                child: Text("Invalid arguments for CompanyPageHome"),
              ),
            ),
          );
        }

      case Routes.addPostScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => getIt<AddPostCubit>(),
            child: AddPostScreen(),
          ),
        );

      case Routes.connectionListScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<ConnectionsCubit>(),
            child: ConnectionPage(),
          ),
        );
      case Routes.settingsScreen:
        return MaterialPageRoute(builder: (context) => SettingsScreen());

      case Routes.changePasswordScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                create: (context) => getIt<ChangePasswordCubit>(),
                child: ChangePasswordScreen()));

      default:
        return null;
    }
  }
}
