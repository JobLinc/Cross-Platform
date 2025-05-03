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
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:joblinc/features/notifications/logic/cubit/notification_cubit.dart';
import 'package:joblinc/core/services/navigation_service.dart';
import 'firebase_options.dart';

// Handle background messages
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Set up background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Set up dependencies
  await setupGetIt();

  await ScreenUtil.ensureScreenSize();
  await checkIfLoggedInUser();
  await checkIfConfirmedUser();

  // Initialize notification services if user is logged in
  if (isLoggedInUser) {
    try {
      final notificationCubit = getIt<NotificationCubit>();
      await notificationCubit.initServices();

      // Add a delayed check for initial message (after app is rendered)
      Future.delayed(const Duration(milliseconds: 1000), () {
        final messagingService = notificationCubit.getMessagingService();
        if (messagingService != null) {
          messagingService.checkInitialMessage();
        }
      });
    } catch (e) {
      print("Error initializing notification services: $e");
    }
  }

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
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          navigatorKey: getIt<NavigationService>().navigatorKey,
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
