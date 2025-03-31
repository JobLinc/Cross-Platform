import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/widgets/universal_app_bar_widget.dart';
import 'package:joblinc/core/widgets/universal_bottom_bar.dart';
import 'package:joblinc/features/chat/logic/cubit/chat_list_cubit.dart';
import 'package:joblinc/features/chat/ui/screens/chat_list_screen.dart';
import 'package:joblinc/features/chat/ui/screens/chat_screen.dart';
import 'package:joblinc/features/companyPages/ui/screens/company_home.dart';
import 'package:joblinc/features/forgetpassword/logic/cubit/forget_password_cubit.dart';
import 'package:joblinc/features/home/ui/screens/home_screen.dart';
import 'package:joblinc/features/jobs/logic/cubit/job_list_cubit.dart';
import 'package:joblinc/features/jobs/logic/cubit/my_jobs_cubit.dart';
import 'package:joblinc/features/jobs/ui/screens/job_details_screen.dart';
import 'package:joblinc/features/jobs/ui/screens/job_list_screen.dart';
import 'package:joblinc/features/jobs/ui/screens/my_jobs_screen.dart';
import 'package:joblinc/features/jobs/ui/screens/job_search_screen.dart';
import 'package:joblinc/features/login/logic/cubit/login_cubit.dart';
import 'package:joblinc/features/forgetpassword/ui/screens/forgetpassword_screen.dart';
import 'package:joblinc/features/login/ui/screens/login_screen.dart';
import 'package:joblinc/features/onboarding/ui/screens/onboarding_screen.dart';
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
            child: ForgetpasswordScreen(),
          ),
        );
      case Routes.chatListScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => getIt<ChatListCubit>(),
                  child: ChatListScreen(),
                ));
      case Routes.jobListScreen:
        return MaterialPageRoute(
            builder: (newContext) => BlocProvider(
                  create: (context) => getIt<JobListCubit>(),
                  child: Scaffold(
                    appBar: universalAppBar(
                      context: newContext,
                      selectedIndex: 4,
                      searchBarFunction: () => goToJobSearch(newContext),
                    ),
                    body: JobListScreen(),
                    bottomNavigationBar: UniversalBottomBar(),
                  ),
                ));
      case Routes.jobSearchScreen:
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                create: (context) => getIt<JobListCubit>(),
                child: JobSearchScreen()));
      // case Routes.jobApplicationScreen:
      //   return MaterialPageRoute(
      //       builder: (context) => BlocProvider(
      //           create: (context) => getIt<JobListCubit>(),
      //           child: JobSearchScreen()));
      // case Routes.jobDetailsScreen:
      //   return MaterialPageRoute(
      //       builder: (context) => BlocProvider(
      //           create: (context) => getIt<JobListCubit>(),
      //           child: JobDetailScreen(scrollController: null,)));
      case Routes.myJobsScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => getIt<MyJobsCubit>(),
                  child: MyJobsScreen(),
                ));
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

      default:
        return null;
    }
  }
}
