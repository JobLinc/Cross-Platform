import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
<<<<<<< HEAD
import 'package:joblinc/features/connections/logic/cubit/connections_cubit.dart';
=======
import 'package:joblinc/features/forgetpassword/logic/cubit/forget_password_cubit.dart';
>>>>>>> a085f74fae63c4c419d7fd500e24eab4839211bc
import 'package:joblinc/features/login/data/repos/login_repo.dart';
import 'package:joblinc/features/login/data/services/login_api_service.dart';
import 'package:joblinc/features/signup/data/repos/register_repo.dart';
import 'package:joblinc/features/signup/data/services/register_api_service.dart';
import 'package:joblinc/features/signup/logic/cubit/signup_cubit.dart';

import '../../features/login/logic/cubit/login_cubit.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  Dio dio = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:3000/api',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  getIt.registerLazySingleton<Dio>(() => dio);

  getIt.registerLazySingleton<LoginApiService>(
      () => LoginApiService(getIt<Dio>()));

  getIt.registerLazySingleton<LoginRepo>(
      () => LoginRepo(getIt<LoginApiService>()));

  getIt.registerFactory<LoginCubit>(() => LoginCubit(getIt<LoginRepo>()));

  getIt.registerLazySingleton<RegisterApiService>(
      () => RegisterApiService(getIt<Dio>()));

  getIt.registerLazySingleton<RegisterRepo>(
      () => RegisterRepo(getIt<RegisterApiService>()));

  getIt.registerFactory<RegisterCubit>(
      () => RegisterCubit(getIt<RegisterRepo>()));
<<<<<<< HEAD
  getIt.registerFactory<ConnectionsCubit>(() => ConnectionsCubit());
=======

  getIt.registerFactory<ForgetPasswordCubit>(() => ForgetPasswordCubit());
>>>>>>> a085f74fae63c4c419d7fd500e24eab4839211bc
}
