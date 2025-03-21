import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:joblinc/features/companyPages/data/data/repos/createcompany_repo.dart';
import 'package:joblinc/features/companyPages/data/data/services/createcompany_api_service.dart';
import 'package:joblinc/features/companyPages/logic/cubit/create_company_cubit.dart';
import 'package:joblinc/features/forgetpassword/logic/cubit/forget_password_cubit.dart';
import 'package:joblinc/features/login/data/repos/login_repo.dart';
import 'package:joblinc/features/login/data/services/login_api_service.dart';
import 'package:joblinc/features/signup/data/repos/register_repo.dart';
import 'package:joblinc/features/signup/data/services/register_api_service.dart';
import 'package:joblinc/features/signup/logic/cubit/signup_cubit.dart';
import '../../features/login/logic/cubit/login_cubit.dart';
import 'package:joblinc/features/companyPages/data/data/company.dart';

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

  getIt.registerLazySingleton<CreateCompanyApiService>(
      () => CreateCompanyApiService(getIt<Dio>()));

  getIt.registerLazySingleton<CreateCompanyRepo>(
      () => CreateCompanyRepo(getIt<CreateCompanyApiService>()));

  getIt.registerFactoryParam<CreateCompanyCubit, void Function(Company), void>(
  (param1, _) => CreateCompanyCubit(
    getIt<CreateCompanyRepo>(),
    onCompanyCreated: param1, // Pass the callback dynamically
  ),
);
}
