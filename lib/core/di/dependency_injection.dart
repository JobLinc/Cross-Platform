import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:joblinc/core/helpers/auth_helpers/auth_service.dart';
import 'package:joblinc/core/helpers/auth_helpers/auth_interceptor.dart'; // Import the interceptor
import 'package:joblinc/features/changepassword/data/repos/change_password_repo.dart';
import 'package:joblinc/features/changepassword/data/services/change_password_api_service.dart';
import 'package:joblinc/features/changepassword/logic/cubit/change_password_cubit.dart';
import 'package:joblinc/features/companyPages/data/data/repos/createcompany_repo.dart';
import 'package:joblinc/features/companyPages/data/data/services/createcompany_api_service.dart';
import 'package:joblinc/features/companyPages/logic/cubit/create_company_cubit.dart';
import 'package:joblinc/features/chat/data/repos/chat_repo.dart';
import 'package:joblinc/features/chat/data/services/chat_api_service.dart';
import 'package:joblinc/features/chat/logic/cubit/chat_list_cubit.dart';
import 'package:joblinc/features/forgetpassword/data/repos/forgetpassword_repo.dart';
import 'package:joblinc/features/forgetpassword/data/services/forgetpassword_api_service.dart';
import 'package:joblinc/features/connections/data/Repo/UserConnections.dart';
import 'package:joblinc/features/connections/data/Web_Services/MockConnectionApiService.dart';
import 'package:joblinc/features/connections/data/Web_Services/connection_webService.dart';

import 'package:joblinc/features/connections/logic/cubit/connections_cubit.dart';
import 'package:joblinc/features/connections/logic/cubit/invitations_cubit.dart';

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
import 'package:joblinc/features/companyPages/data/data/company.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  final FlutterSecureStorage storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  getIt.registerLazySingleton<FlutterSecureStorage>(() => storage);

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:3000/api',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  getIt.registerLazySingleton<AuthService>(() => AuthService(storage, dio));

  dio.interceptors.add(AuthInterceptor(getIt<AuthService>(), dio));

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

  getIt.registerLazySingleton<ChangePasswordApiService>(
      () => ChangePasswordApiService(getIt<Dio>()));

  getIt.registerLazySingleton<ChangePasswordRepo>(
      () => ChangePasswordRepo(getIt<ChangePasswordApiService>()));

  getIt.registerFactory<ChangePasswordCubit>(
      () => ChangePasswordCubit(getIt<ChangePasswordRepo>()));

  getIt.registerLazySingleton<ForgetPasswordApiService>(
      () => ForgetPasswordApiService(getIt<Dio>()));

  getIt.registerLazySingleton<ForgetPasswordRepo>(
      () => ForgetPasswordRepo(apiService: getIt<ForgetPasswordApiService>()));

  getIt.registerFactory<ForgetPasswordCubit>(
      () => ForgetPasswordCubit(repository: getIt<ForgetPasswordRepo>()));

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

  getIt.registerFactoryParam<CreateCompanyCubit, void Function(Company), void>(
  (param1, _) => CreateCompanyCubit(
    getIt<CreateCompanyRepo>(),
    onCompanyCreated: param1,
  ),
);

  getIt.registerLazySingleton<ChatApiService>(
    () => ChatApiService(getIt<Dio>()),
  );

  getIt
      .registerLazySingleton<ChatRepo>(() => ChatRepo(getIt<ChatApiService>()));

  getIt.registerFactory<ChatListCubit>(
    () => ChatListCubit(getIt<ChatRepo>()),
  );
///////////////////////////////////////////////////////////////////////////

  getIt.registerLazySingleton<UserConnectionsApiService>(
      () => UserConnectionsApiService(getIt<Dio>()));

  getIt.registerLazySingleton<UserConnectionsRepository>(
      () => UserConnectionsRepository(getIt<UserConnectionsApiService>()));

  getIt.registerFactory<ConnectionsCubit>(() => ConnectionsCubit(
      MockConnectionApiService() /*getIt<UserConnectionsRepository>()*/));

  getIt.registerFactory<InvitationsCubit>(
      () => InvitationsCubit(MockConnectionApiService()));
}
