import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:joblinc/features/companyPages/data/data/repos/createcompany_repo.dart';
import 'package:joblinc/features/companyPages/data/data/services/createcompany_api_service.dart';
import 'package:joblinc/features/companyPages/logic/cubit/create_company_cubit.dart';
import 'package:joblinc/features/chat/data/repos/chat_repo.dart';
import 'package:joblinc/features/chat/data/services/chat_api_service.dart';
import 'package:joblinc/features/chat/logic/cubit/chat_list_cubit.dart';
import 'package:joblinc/features/forgetpassword/logic/cubit/forget_password_cubit.dart';
import 'package:joblinc/features/home/data/repos/post_repo.dart';
import 'package:joblinc/features/home/data/services/post_api_service.dart';
import 'package:joblinc/features/home/logic/cubit/home_cubit.dart';
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

  getIt.registerFactory<ForgetPasswordCubit>(() => ForgetPasswordCubit());

  // Posts
  getIt.registerLazySingleton<PostApiService>(
      () => PostApiService(getIt<Dio>()));

  getIt
      .registerLazySingleton<PostRepo>(() => PostRepo(getIt<PostApiService>()));

  getIt.registerFactory<HomeCubit>(() => HomeCubit(getIt<PostRepo>()));

  getIt.registerLazySingleton<CreateCompanyApiService>(
      () => CreateCompanyApiService(getIt<Dio>()));

  getIt.registerLazySingleton<CreateCompanyRepo>(
      () => CreateCompanyRepo(getIt<CreateCompanyApiService>()));

  getIt.registerFactory<CreateCompanyCubit>(
      () => CreateCompanyCubit(getIt<CreateCompanyRepo>()));

  getIt.registerLazySingleton<ChatApiService>(
    () =>ChatApiService(getIt<Dio>()) ,);
  
  getIt.registerLazySingleton<ChatRepo>(
    () => ChatRepo(getIt<ChatApiService>()));
  
  getIt.registerFactory<ChatListCubit>(
    () =>ChatListCubit( getIt<ChatRepo>()) ,);
}

