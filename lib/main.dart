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
