import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/helpers/auth_helpers/auth_service.dart';
import 'package:joblinc/core/helpers/auth_helpers/constants.dart';
import 'package:joblinc/core/routing/app_router.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/theming/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupGetIt();
  await ScreenUtil.ensureScreenSize();
  await checkIfLoggedInUser();
  await checkIfConfirmedUser();
  // Initialize the app with the appropriate theme and initial route
  // based on the user's login status

  runApp(MainApp(
    appRouter: AppRouter(),
  ));
}

class MainApp extends StatelessWidget {
  final AppRouter appRouter;
  const MainApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(412, 924),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute:
              isLoggedInUser ? Routes.homeScreen : Routes.onBoardingScreen,
          theme: lightTheme,
          onGenerateRoute: appRouter.generateRoute,
        );
      },
    );
  }
}

Future<void> checkIfLoggedInUser() async {
  try {
    AuthService authService = getIt<AuthService>();
    String? userToken = await authService.getAccessToken();
    if (userToken == null || userToken.isEmpty) {
      isLoggedInUser = false;
    } else {
      bool refreshResult = await authService.refreshToken();
      isLoggedInUser = refreshResult;
    }
  } catch (e) {
    print("Error in checkIfLoggedInUser: $e");
    isLoggedInUser = false;
  }
}

// check if confirmed user
Future<void> checkIfConfirmedUser() async {
  try {
    AuthService authService = getIt<AuthService>();
    String? token = await authService.getAccessToken();
    if (token == null || token.isEmpty) {
      isConfirmedUser =  false;
    } else {
       isConfirmedUser = await authService.getConfirmationStatus();
    }
  } catch (e) {
    print("Error in checkIfConfirmedUser: $e");
    isConfirmedUser = false;
  }

  if(!isConfirmedUser) {
    // If the user is not confirmed, clear the user info
    AuthService authService = getIt<AuthService>();
    await authService.clearUserInfo();
    isLoggedInUser = false;
  }
}

