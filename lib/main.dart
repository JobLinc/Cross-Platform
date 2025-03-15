import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/routing/app_router.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/features/connections/logic/cubit/connections_cubit.dart';

void main() async{
    WidgetsFlutterBinding.ensureInitialized();
  await setupGetIt();
    await ScreenUtil.ensureScreenSize();


  runApp(BlocProvider<ConnectionsCubit>(
      create: (context) => ConnectionsCubit(), // ✅ Created ONCE at app start
      child: MainApp(
    appRouter: AppRouter(),
  ),
    ),);
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
          initialRoute: Routes.onBoardingScreen,
          theme: lightTheme,
          onGenerateRoute: appRouter.generateRoute,
        );
      },
    );
  }
}
