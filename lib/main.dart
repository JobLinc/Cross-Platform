import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/helpers/auth_helpers/auth_service.dart';
import 'package:joblinc/core/helpers/auth_helpers/constants.dart';
import 'package:joblinc/core/routing/app_router.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/core/theming/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupGetIt();
  await ScreenUtil.ensureScreenSize();
  await checkIfLoggedInUser();
  await checkIfConfirmedUser();
  // Initialize the app with the appropriate theme and initial route
  // based on the user's login status

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return ScreenUtilInit(
      designSize: const Size(390, 844), // iPhone 13 Pro size as a reference
      builder: (context, child) {
        return MaterialApp(
          title: 'JobLinc',
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.themeMode,
          theme: lightTheme,
          darkTheme: darkTheme,
          initialRoute:
              isLoggedInUser ? Routes.homeScreen : Routes.onBoardingScreen,
          onGenerateRoute: AppRouter().generateRoute,
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
      isConfirmedUser = false;
    } else {
      isConfirmedUser = await authService.getConfirmationStatus();
    }
  } catch (e) {
    print("Error in checkIfConfirmedUser: $e");
    isConfirmedUser = false;
  }

  if (!isConfirmedUser) {
    // If the user is not confirmed, clear the user info
    AuthService authService = getIt<AuthService>();
    await authService.clearUserInfo();
    isLoggedInUser = false;
  }
}
