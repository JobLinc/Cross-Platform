import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:joblinc/core/helpers/auth_helpers/auth_service.dart';
import 'package:joblinc/core/helpers/auth_helpers/auth_interceptor.dart'; // Import the interceptor
import 'package:joblinc/features/accountvisibility/data/repos/account_visibility_repo.dart';
import 'package:joblinc/features/accountvisibility/data/services/account_visibility_service.dart';
import 'package:joblinc/features/changeemail/data/repos/change_email_repo.dart';
import 'package:joblinc/features/changeemail/data/services/change_email_api_service.dart';
import 'package:joblinc/features/changeemail/logic/cubit/change_email_cubit.dart';
import 'package:joblinc/features/changepassword/data/repos/change_password_repo.dart';
import 'package:joblinc/features/changepassword/data/services/change_password_api_service.dart';
import 'package:joblinc/features/changepassword/logic/cubit/change_password_cubit.dart';
import 'package:joblinc/features/changeusername/data/repos/change_username_repo.dart';
import 'package:joblinc/features/changeusername/logic/cubit/change_username_cubit.dart';
import 'package:joblinc/features/chat/logic/cubit/chat_cubit.dart';
import 'package:joblinc/features/companypages/data/data/repos/createcompany_repo.dart';
import 'package:joblinc/features/companypages/data/data/services/createcompany_api_service.dart';
import 'package:joblinc/features/companypages/logic/cubit/create_company_cubit.dart';
import 'package:joblinc/features/chat/data/repos/chat_repo.dart';
import 'package:joblinc/features/chat/data/services/chat_api_service.dart';
import 'package:joblinc/features/chat/logic/cubit/chat_list_cubit.dart';
import 'package:joblinc/features/connections/logic/cubit/follow_cubit.dart';
import 'package:joblinc/features/companypages/logic/cubit/edit_company_cubit.dart';
import 'package:joblinc/features/connections/logic/cubit/sent_connections_cubit.dart';
import 'package:joblinc/features/emailconfirmation/data/repos/email_confirmation_repo.dart';
import 'package:joblinc/features/emailconfirmation/data/services/email_confirmation_api_service.dart';
import 'package:joblinc/features/emailconfirmation/logic/cubit/email_confirmation_cubit.dart';
import 'package:joblinc/features/forgetpassword/data/repos/forgetpassword_repo.dart';
import 'package:joblinc/features/forgetpassword/data/services/forgetpassword_api_service.dart';
import 'package:joblinc/features/connections/data/Repo/connections_repo.dart';
import 'package:joblinc/features/connections/data/Web_Services/connection_webService.dart';

import 'package:joblinc/features/connections/logic/cubit/connections_cubit.dart';
import 'package:joblinc/features/connections/logic/cubit/invitations_cubit.dart';

import 'package:joblinc/features/forgetpassword/logic/cubit/forget_password_cubit.dart';
import 'package:joblinc/features/notifications/data/repos/notification_repo.dart';
import 'package:joblinc/features/notifications/data/services/notification_api_service.dart';
import 'package:joblinc/features/notifications/data/services/device_token_service.dart';
import 'package:joblinc/features/notifications/data/services/firebase_messaging_service.dart';
import 'package:joblinc/features/notifications/logic/cubit/notification_cubit.dart';
import 'package:joblinc/features/posts/data/repos/comment_repo.dart';
import 'package:joblinc/features/posts/data/repos/post_repo.dart';
import 'package:joblinc/features/posts/data/services/comment_api_service.dart';
import 'package:joblinc/features/posts/data/services/post_api_service.dart';
import 'package:joblinc/features/home/logic/cubit/home_cubit.dart';
import 'package:joblinc/features/jobs/data/repos/job_repo.dart';
import 'package:joblinc/features/jobs/data/services/job_api_service.dart';
import 'package:joblinc/features/jobs/logic/cubit/job_list_cubit.dart';
import 'package:joblinc/features/jobs/logic/cubit/my_jobs_cubit.dart';
import 'package:joblinc/features/login/data/repos/login_repo.dart';
import 'package:joblinc/features/login/data/services/login_api_service.dart';
import 'package:joblinc/features/posts/data/services/tag_suggestion_service.dart';
import 'package:joblinc/features/posts/logic/cubit/add_post_cubit.dart';
import 'package:joblinc/features/posts/logic/cubit/post_cubit.dart';
import 'package:joblinc/features/posts/logic/cubit/post_search_cubit.dart';
import 'package:joblinc/features/posts/logic/cubit/saved_posts_cubit.dart';
import 'package:joblinc/features/posts/logic/cubit/edit_post_cubit.dart';
import 'package:joblinc/features/posts/logic/cubit/focus_post_cubit.dart';
import 'package:joblinc/features/signup/data/repos/register_repo.dart';
import 'package:joblinc/features/signup/data/services/register_api_service.dart';
import 'package:joblinc/features/signup/logic/cubit/signup_cubit.dart';
import 'package:joblinc/features/userprofile/data/service/add_service.dart';
import 'package:joblinc/features/userprofile/data/service/others_api_service.dart';
import 'package:joblinc/features/userprofile/logic/cubit/message_requests_cubit.dart';
import 'package:joblinc/features/userprofile/logic/cubit/profile_cubit.dart';
import 'package:joblinc/features/userprofile/data/repo/user_profile_repository.dart';
import 'package:joblinc/features/userprofile/data/service/my_user_profile_api.dart';
import 'package:joblinc/features/userprofile/data/service/update_user_profile_api.dart';
import 'package:joblinc/features/userprofile/data/service/upload_user_picture.dart';
import 'package:joblinc/features/userprofile/logic/cubit/profile_posts_cubit.dart';
import 'package:joblinc/features/userprofile/logic/cubit/search_cubit.dart';
import '../../features/login/logic/cubit/login_cubit.dart';
import 'package:joblinc/features/companypages/data/data/company.dart';
import 'package:joblinc/features/companypages/data/data/repos/update_company_repo.dart';
import 'package:joblinc/features/companypages/data/data/services/update_company_api_service.dart';
import 'package:joblinc/core/services/navigation_service.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  final FlutterSecureStorage storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  getIt.registerLazySingleton<FlutterSecureStorage>(() => storage);
  final baseUrl = 'https://joblinc.me:3000/api';

  final socketUrl = 'wss://joblinc.me:3000';

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 200),
      receiveTimeout: const Duration(seconds: 200),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  getIt.registerLazySingleton<AuthService>(() => AuthService(storage, dio));

  dio.interceptors.add(AuthInterceptor(getIt<AuthService>(), dio));

  getIt.registerLazySingleton<Dio>(() => dio);

  // Register Navigation Service
  getIt.registerLazySingleton<NavigationService>(() => NavigationService());

  // Register UpdateCompanyApiService
  getIt.registerLazySingleton<UpdateCompanyApiService>(
      () => UpdateCompanyApiService(getIt<Dio>()));

  // Register UpdateCompanyRepo
  getIt.registerLazySingleton<UpdateCompanyRepo>(
      () => UpdateCompanyRepo(getIt<UpdateCompanyApiService>()));

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

  getIt.registerLazySingleton<ForgetPasswordApiService>(
      () => ForgetPasswordApiService(getIt<Dio>()));

  getIt.registerLazySingleton<ForgetPasswordRepo>(
      () => ForgetPasswordRepo(apiService: getIt<ForgetPasswordApiService>()));

  getIt.registerFactory<ForgetPasswordCubit>(
      () => ForgetPasswordCubit(repository: getIt<ForgetPasswordRepo>()));
///////////////////////////////////////////////////////////////////////////
  // Home
  getIt.registerFactory<HomeCubit>(() => HomeCubit(getIt<PostRepo>()));
///////////////////////////////////////////////////////////////////////////
  // Posts
  getIt.registerLazySingleton<PostApiService>(
      () => PostApiService(getIt<Dio>()));

  getIt.registerLazySingleton<CommentApiService>(
      () => CommentApiService(getIt<Dio>()));

  getIt.registerLazySingleton<PostRepo>(
      () => PostRepo(getIt<PostApiService>(), getIt<UserProfileApiService>()));

  getIt.registerLazySingleton<CommentRepo>(
      () => CommentRepo(getIt<CommentApiService>()));

  getIt.registerFactory<PostCubit>(() => PostCubit(getIt<PostRepo>(),
      getIt<CommentRepo>(), getIt<UserConnectionsRepository>()));

  getIt.registerFactory<AddPostCubit>(
    () => AddPostCubit(getIt<PostRepo>(), getIt<TagSuggestionService>()),
  );

  getIt.registerFactory<SavedPostsCubit>(
      () => SavedPostsCubit(getIt<PostRepo>()));

  getIt.registerFactory<EditPostCubit>(() => EditPostCubit(getIt<PostRepo>()));

  getIt.registerFactory<PostSearchCubit>(() => PostSearchCubit(getIt()));

  getIt
      .registerFactory<FocusPostCubit>(() => FocusPostCubit(getIt<PostRepo>()));

///////////////////////////////////////////////////////////////////////////
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
  getIt.registerFactory<EditCompanyCubit>(
    () => EditCompanyCubit(getIt<UpdateCompanyRepo>()),
  );
  getIt.registerLazySingleton<ChatApiService>(
    () => ChatApiService(getIt<Dio>()),
  );

  getIt
      .registerLazySingleton<ChatRepo>(() => ChatRepo(getIt<ChatApiService>()));

  getIt.registerFactory<ChatListCubit>(
    () => ChatListCubit(getIt<ChatRepo>()),
  );

  getIt.registerFactory<ChatCubit>(
    () => ChatCubit(getIt<ChatRepo>()),
  );

  getIt.registerLazySingleton<JobApiService>(
    () => JobApiService(getIt<Dio>()),
  );

  getIt.registerLazySingleton<JobRepo>(() => JobRepo(getIt<JobApiService>()));

  getIt.registerFactory<MyJobsCubit>(
    () => MyJobsCubit(getIt<JobRepo>()),
  );

  getIt.registerFactory<JobListCubit>(
    () => JobListCubit(getIt<JobRepo>()),
  );

///////////////////////////////////////////////////////////////////////////

  getIt.registerLazySingleton<UserConnectionsApiService>(
      () => UserConnectionsApiService(getIt<Dio>()));

  getIt.registerLazySingleton<UserConnectionsRepository>(
      () => UserConnectionsRepository(getIt<UserConnectionsApiService>()));

  getIt.registerFactory<ConnectionsCubit>(
      () => ConnectionsCubit(getIt<UserConnectionsRepository>()));
  getIt.registerFactory<SentConnectionsCubit>(
      () => SentConnectionsCubit(getIt<UserConnectionsRepository>()));
  getIt.registerFactory<FollowCubit>(
      () => FollowCubit(getIt<UserConnectionsRepository>()));
  //User profile
  getIt.registerFactory<InvitationsCubit>(
      () => InvitationsCubit(getIt<UserConnectionsRepository>()));

  getIt.registerLazySingleton<UserProfileApiService>(
      () => UserProfileApiService(getIt<Dio>()));
  getIt.registerLazySingleton<OthersApiService>(
      () => OthersApiService(getIt<Dio>()));

  getIt.registerLazySingleton<UpdateUserProfileApiService>(
      () => UpdateUserProfileApiService(getIt<Dio>()));
  getIt.registerLazySingleton<UploadApiService>(
      () => UploadApiService(getIt<Dio>()));
  getIt.registerLazySingleton<addService>(() => addService(getIt<Dio>()));

  getIt
      .registerLazySingleton<UserProfileRepository>(() => UserProfileRepository(
            getIt<UserProfileApiService>(),
            getIt<UpdateUserProfileApiService>(),
            getIt<UploadApiService>(),
            getIt<addService>(),
            getIt<OthersApiService>(),
          ));
  getIt.registerFactory<MessageRequestsCubit>(
      () => MessageRequestsCubit(getIt<UserProfileRepository>()));

  getIt.registerFactory<ProfileCubit>(() => ProfileCubit(
      getIt<UserProfileRepository>(), getIt<UserConnectionsRepository>()));

  getIt.registerFactory<SearchCubit>(
      () => SearchCubit(getIt<UserConnectionsRepository>()));
  // Profile
  getIt.registerFactory<ProfilePostsCubit>(
      () => ProfilePostsCubit(getIt<PostRepo>()));
  // Email confirmation dependencies
  getIt.registerLazySingleton<EmailConfirmationApiService>(
      () => EmailConfirmationApiService(getIt<Dio>()));

  getIt.registerLazySingleton<EmailConfirmationRepo>(
      () => EmailConfirmationRepo(getIt<EmailConfirmationApiService>()));

  getIt.registerFactory<EmailConfirmationCubit>(
      () => EmailConfirmationCubit(getIt<EmailConfirmationRepo>()));

  getIt.registerFactory<ChangeEmailApiService>(
    () => ChangeEmailApiService(getIt<Dio>()),
  );
  getIt.registerFactory<ChangeEmailRepo>(
    () => ChangeEmailRepo(getIt<ChangeEmailApiService>()),
  );

  getIt.registerFactory<ChangeEmailCubit>(
      () => ChangeEmailCubit(getIt<ChangeEmailRepo>()));

  getIt.registerLazySingleton<ChangePasswordApiService>(
      () => ChangePasswordApiService(getIt<Dio>()));

  getIt.registerLazySingleton<ChangePasswordRepo>(
      () => ChangePasswordRepo(getIt<ChangePasswordApiService>()));

  getIt.registerFactory<ChangePasswordCubit>(
      () => ChangePasswordCubit(getIt<ChangePasswordRepo>()));

  getIt.registerFactory<ChangeUsernameRepo>(
    () => ChangeUsernameRepo(getIt<UpdateUserProfileApiService>()),
  );

  getIt.registerFactory<ChangeUsernameCubit>(
    () => ChangeUsernameCubit(getIt<ChangeUsernameRepo>()),
  );
  //User profile

  // Notifications
  getIt.registerFactory<NotificationApiService>(
      () => NotificationApiService(getIt<Dio>()));

  getIt.registerFactory<NotificationRepo>(
    () => NotificationRepo(getIt<NotificationApiService>()),
  );

  // Register Device Token Service
  getIt.registerLazySingleton<DeviceTokenService>(
    () => DeviceTokenService(getIt<Dio>()),
  );

  // Register Notification Cubit with dependencies
  getIt.registerFactory<NotificationCubit>(() => NotificationCubit(
        getIt<NotificationRepo>(),
        socketUrl,
        getIt<DeviceTokenService>(),
      ));

  // Account Visibility
  getIt.registerLazySingleton<AccountVisibilityService>(
      () => AccountVisibilityService(getIt.get<Dio>()));

  getIt.registerLazySingleton<AccountVisibilityRepo>(
      () => AccountVisibilityRepo(getIt.get<AccountVisibilityService>()));

  // Tag suggestion service
  getIt.registerFactory<TagSuggestionService>(
      () => TagSuggestionService(getIt<Dio>()));

  getIt.registerFactory<FirebaseMessagingService>(
    () => FirebaseMessagingService(
      getIt<DeviceTokenService>(),
      (model) {},
      getIt<NotificationApiService>(),
      getIt<NotificationCubit>(),
    ),
  );
}
