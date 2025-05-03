import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/screens/main_container_screen.dart';
import 'package:joblinc/core/widgets/universal_app_bar_widget.dart';
import 'package:joblinc/core/widgets/universal_bottom_bar.dart';
import 'package:joblinc/features/blockedaccounts/logic/cubit/blocked_accounts_cubit.dart';
import 'package:joblinc/features/blockedaccounts/ui/screens/blocked_accounts_screen.dart';
import 'package:joblinc/features/changeemail/logic/cubit/change_email_cubit.dart';
import 'package:joblinc/features/changeemail/ui/screens/change_email_screen.dart';
import 'package:joblinc/features/changepassword/logic/cubit/change_password_cubit.dart';
import 'package:joblinc/features/changepassword/ui/screens/changepassword_screen.dart';
import 'package:joblinc/features/changeusername/logic/cubit/change_username_cubit.dart';
import 'package:joblinc/features/changeusername/ui/screens/changeusername_screen.dart';
import 'package:joblinc/features/chat/data/models/chat_model.dart';
import 'package:joblinc/features/chat/logic/cubit/chat_list_cubit.dart';
import 'package:joblinc/features/chat/ui/screens/chat_list_screen.dart';
import 'package:joblinc/features/chat/ui/screens/chat_screen.dart';
import 'package:joblinc/features/chat/ui/screens/chat_screen.dart';
import 'package:joblinc/features/chat/ui/screens/create_chat_screen.dart';
import 'package:joblinc/features/chat/ui/screens/create_group_screen.dart';
import 'package:joblinc/features/companypages/data/data/repos/getmycompany_repo.dart';
import 'package:joblinc/features/companypages/data/data/services/getmycompany.dart';
import 'package:joblinc/features/companypages/logic/cubit/edit_company_cubit.dart';
import 'package:joblinc/features/companypages/ui/screens/dashboard/company_analytics.dart'
    show CompanyAnalytics;
import 'package:joblinc/features/companypages/ui/screens/dashboard/company_dashboard.dart';
import 'package:joblinc/features/companypages/ui/screens/company_home.dart';
import 'package:joblinc/features/companypages/ui/screens/dashboard/company_edit.dart';
import 'package:joblinc/features/companypages/ui/screens/dashboard/company_page_posts.dart';
import 'package:joblinc/features/companypages/ui/widgets/company_add_location.dart';
import 'package:joblinc/features/companypages/ui/widgets/image_preview_edit.dart';
import 'package:joblinc/features/connections/logic/cubit/connections_cubit.dart';
import 'package:joblinc/features/connections/logic/cubit/follow_cubit.dart';
import 'package:joblinc/features/connections/ui/screens/Recieved_Sent_Tabs.dart';
import 'package:joblinc/features/connections/ui/screens/block_list_screen.dart';
import 'package:joblinc/features/connections/ui/screens/connections.dart';
import 'package:joblinc/features/connections/ui/screens/followers_list_screen.dart';
import 'package:joblinc/features/connections/ui/screens/following_list_screen.dart';
import 'package:joblinc/features/connections/ui/screens/others_connection_list.dart';
import 'package:joblinc/features/forgetpassword/logic/cubit/forget_password_cubit.dart';
import 'package:joblinc/features/home/logic/cubit/home_cubit.dart';
import 'package:joblinc/features/jobs/logic/cubit/job_list_cubit.dart';
import 'package:joblinc/features/jobs/logic/cubit/my_jobs_cubit.dart';
import 'package:joblinc/features/jobs/ui/screens/job_list_screen.dart';
import 'package:joblinc/features/jobs/ui/screens/my_jobs_screen.dart';
import 'package:joblinc/features/jobs/ui/screens/job_search_screen.dart';
import 'package:joblinc/features/login/logic/cubit/login_cubit.dart';
import 'package:joblinc/features/forgetpassword/ui/screens/forgetpassword_screen.dart';
import 'package:joblinc/features/login/ui/screens/login_screen.dart';
import 'package:joblinc/features/onboarding/ui/screens/onboarding_screen.dart';
import 'package:joblinc/features/posts/data/models/post_model.dart';
import 'package:joblinc/features/posts/logic/cubit/add_post_cubit.dart';
import 'package:joblinc/features/posts/logic/cubit/saved_posts_cubit.dart';
import 'package:joblinc/features/posts/ui/screens/add_post.dart';
import 'package:joblinc/features/posts/ui/screens/saved_posts.dart';
import 'package:joblinc/features/settings/ui/screens/settings_screen.dart';
import 'package:joblinc/features/signup/logic/cubit/signup_cubit.dart';
import 'package:joblinc/features/signup/ui/screens/signup_screen.dart';
import 'package:joblinc/features/companypages/ui/screens/company_card.dart';
import 'package:joblinc/features/userprofile/data/models/certificate_model.dart';
import 'package:joblinc/features/userprofile/data/models/experience_model.dart';
import 'package:joblinc/features/userprofile/data/models/education_model.dart';
import 'package:joblinc/features/userprofile/data/models/skill_model.dart';
import 'package:joblinc/features/userprofile/logic/cubit/message_requests_cubit.dart';
import 'package:joblinc/features/userprofile/logic/cubit/profile_cubit.dart';
import 'package:joblinc/features/userprofile/logic/cubit/search_cubit.dart';
import 'package:joblinc/features/userprofile/ui/screens/add_certificate_screen.dart';
import 'package:joblinc/features/userprofile/ui/screens/add_education_screen.dart';
import 'package:joblinc/features/userprofile/ui/screens/add_experience_screen.dart';
import 'package:joblinc/features/userprofile/ui/screens/add_resume_screen.dart';
import 'package:joblinc/features/userprofile/ui/screens/add_skill_screen.dart';
import 'package:joblinc/features/userprofile/ui/screens/edit_user_profile_screen.dart';
import 'package:joblinc/features/userprofile/ui/screens/message_requests.dart';
import 'package:joblinc/features/userprofile/ui/screens/others_profile_screen.dart';
import 'package:joblinc/features/userprofile/ui/screens/profile_screen.dart';
import 'package:joblinc/features/premium/ui/screens/premium_screen.dart';
import 'package:joblinc/features/companypages/data/data/company.dart';
import 'package:joblinc/features/userprofile/ui/screens/others_image_preview.dart';
import 'package:joblinc/features/emailconfirmation/ui/screens/email_confirmation_screen.dart';
import 'package:joblinc/features/emailconfirmation/logic/cubit/email_confirmation_cubit.dart';
import 'package:joblinc/features/userprofile/ui/screens/user_search_screen.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;

    switch (settings.name) {
      case Routes.onBoardingScreen:
        return MaterialPageRoute(builder: (context) => OnboardingScreen());
      case Routes.loginScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<LoginCubit>(),
            child: LoginScreen(),
          ),
        );
      case Routes.signUpScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => getIt<RegisterCubit>(),
                  child: SignupScreen(),
                ));
      case Routes.homeScreen:
        // Main container handles all the main navigation now
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => getIt<HomeCubit>()..getFeed(),
            child: MainContainerScreen(),
          ),
        );
      case Routes.profileScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => getIt<ProfileCubit>()..getUserProfile(),
            child: UserProfileScreen(),
          ),
        );

      case Routes.editProfileScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => getIt<ProfileCubit>()..getUserProfile(),
            child: EditUserProfileScreen(),
          ),
        );
      case Routes.profilePictureUpdate:
        if (arguments is String) {
          return MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => getIt<ProfileCubit>(),
              child: FullScreenImagePage(imagePath: arguments),
            ),
          );
        }
      case Routes.otherImagesPreview:
        if (arguments is String) {
          return MaterialPageRoute(
            builder: (context) => FullScreenImagePage(imagePath: arguments),
          );
        }
      case Routes.otherProfileScreen:
        if (arguments is String) {
          return MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => getIt<ProfileCubit>(),
              child: OthersProfileScreen(userId: arguments),
            ),
          );
        } else {
          return MaterialPageRoute(
            builder: (context) => const Scaffold(
              body: Center(child: Text("2ntr")),
            ),
          );
        }

      case Routes.chatScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                create: (context) => getIt<ChatListCubit>(),
                child: ChatScreen(
                  chatId: arguments as String,
                )));
      case Routes.forgotPasswordScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<ForgetPasswordCubit>(),
            child: ForgotPasswordSteps(),
          ),
        );
      case Routes.chatListScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => getIt<ChatListCubit>(),
                  child: ChatListScreen(),
                ));
      case Routes.jobListScreen:
        // This can be used for direct access, but main navigation is through MainContainerScreen
        return MaterialPageRoute(
            builder: (newContext) => BlocProvider(
                  create: (context) => getIt<JobListCubit>(),
                  child: SafeArea(
                    child: Scaffold(
                      appBar: universalAppBar(
                        context: newContext,
                        selectedIndex: 4,
                        searchBarFunction: () => goToJobSearch(newContext),
                      ),
                      body: JobListScreen(),
                      bottomNavigationBar: UniversalBottomBar(
                        currentIndex: 4,
                        onTap: (index) {
                          if (index == 4) {
                            Navigator.pushNamed(
                                newContext, Routes.jobListScreen);
                          } else {
                            Navigator.pushNamed(newContext, Routes.homeScreen);
                          }
                        },
                      ),
                    ),
                  ),
                ));
      case Routes.jobSearchScreen:
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                create: (context) => getIt<JobListCubit>(),
                child: JobSearchScreen()));
      // case Routes.jobApplicationScreen:
      //   return MaterialPageRoute(
      //       builder: (context) => BlocProvider(
      //           create: (context) => getIt<JobListCubit>(),
      //           child: JobSearchScreen()));
      // case Routes.jobDetailsScreen:
      //   return MaterialPageRoute(
      //       builder: (context) => BlocProvider(
      //           create: (context) => getIt<JobListCubit>(),
      //           child: JobDetailScreen(scrollController: null,)));
      case Routes.myJobsScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => getIt<MyJobsCubit>(),
                  child: MyJobsScreen(),
                ));
      case Routes.premiumScreen:
        return MaterialPageRoute(builder: (context) => PremiumScreen());
      case Routes.companyListScreen:
        return MaterialPageRoute(builder: (context) => CompanyList());
      case Routes.invitationsTabs:
        return MaterialPageRoute(builder: (context) => InvitationsTabs());
      case Routes.companyPageHome:
        if (arguments is Company) {
          return MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => getIt<EditCompanyCubit>(),
              child: CompanyPageHome(company: arguments),
            ),
          );
        } else if (arguments is Map && arguments['company'] is Company) {
          return MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => getIt<EditCompanyCubit>(),
              child: CompanyPageHome(
                company: arguments['company'],
                isAdmin: arguments['isAdmin'] ?? false,
              ),
            ),
          );
        } else if (arguments is String) {
          return MaterialPageRoute(
            builder: (context) {
              try {
                final repo = CompanyRepositoryImpl(
                  CompanyApiService(getIt<Dio>()),
                );
                return FutureBuilder(
                  future: repo.getCompanyById(arguments),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Scaffold(
                        body: Center(child: CircularProgressIndicator()),
                      );
                    } else if (snapshot.hasError) {
                      return Scaffold(
                        body: Center(
                            child: Text(
                                'Error 404: Requested company is not found')),
                      );
                    } else if (snapshot.hasData) {
                      print(snapshot.data);
                      return CompanyPageHome(company: snapshot.data as Company);
                    } else {
                      return Scaffold(
                        body: Center(
                            child:
                                Text('Invalid arguments for CompanyPageHome')),
                      );
                    }
                  },
                );
              } catch (e) {
                return Scaffold(
                  body: Center(
                      child: Text('Error 404: Requested company is not found')),
                );
              }
            },
          );
        } else {
          return MaterialPageRoute(
            builder: (context) => Scaffold(
              body: Center(
                child: Text("Invalid arguments for CompanyPageHome"),
              ),
            ),
          );
        }

      case Routes.addPostScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => getIt<AddPostCubit>(),
            child: AddPostScreen(
              repost: arguments is PostModel? ? arguments : null,
            ),
          ),
        );

      case Routes.connectionListScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<ConnectionsCubit>(),
            child: ConnectionPage(),
          ),
        );
      case Routes.followersListScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<FollowCubit>(),
            child: FollowersListScreen(),
          ),
        );
      case Routes.followingListScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<FollowCubit>(),
            child: FollowingListScreen(),
          ),
        );
      case Routes.othersConnectionScreen:
        if (arguments is String) {
          return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (context) =>
                  getIt<ConnectionsCubit>()..fetchUserConnections(arguments),
              child: OthersConnectionList(),
            ),
          );
        } else {}

      case Routes.blockedConnectionsList:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<ConnectionsCubit>(),
            child: BlockedList(),
          ),
        );
      case Routes.settingsScreen:
        return MaterialPageRoute(builder: (context) => SettingsScreen());

      case Routes.changePasswordScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                create: (context) => getIt<ChangePasswordCubit>(),
                child: ChangePasswordScreen()));

      case Routes.companyDashboard:
        if (arguments is Company) {
          return MaterialPageRoute(
            builder: (context) => CompanyDashboard(company: arguments),
          );
        } else if (arguments is Map && arguments['company'] is Company) {
          return MaterialPageRoute(
            builder: (context) =>
                CompanyDashboard(company: arguments['company']),
          );
        } else {
          return MaterialPageRoute(
            builder: (context) => Scaffold(
              body: Center(
                child: Text("Invalid arguments for CompanyDashboard"),
              ),
            ),
          );
        }

      case Routes.companyPagePosts:
        if (arguments is Company) {
          return MaterialPageRoute(
            builder: (context) => CompanyPagePosts(company: arguments),
          );
        } else {
          return MaterialPageRoute(
            builder: (context) => Scaffold(
              body: Center(
                child: Text("Invalid arguments for CompanyDashboard"),
              ),
            ),
          );
        }

      case Routes.companyAnalytics:
        if (arguments is Company) {
          return MaterialPageRoute(
            builder: (context) => CompanyAnalytics(company: arguments),
          );
        } else if (arguments is Map && arguments['company'] is Company) {
          return MaterialPageRoute(
            builder: (context) =>
                CompanyAnalytics(company: arguments['company']),
          );
        } else {
          return MaterialPageRoute(
            builder: (context) => Scaffold(
              body: Center(
                child: Text("Invalid arguments for CompanyDashboard"),
              ),
            ),
          );
        }

      case Routes.companyEdit:
        if (arguments is Company) {
          return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (context) => getIt<EditCompanyCubit>(),
              child: CompanyPageEditScreen(company: arguments),
            ),
          );
        } else if (arguments is Map && arguments['company'] is Company) {
          return MaterialPageRoute(
            builder: (context) => CompanyPageEditScreen(
              company: arguments['company'],

              // You can also pass isAdmin if needed: isAdmin: arguments['isAdmin'] ?? false,
            ),
          );
        } else {
          return MaterialPageRoute(
            builder: (context) => Scaffold(
              body: Center(
                child: Text("Invalid arguments for CompanyEdit"),
              ),
            ),
          );
        }
      case Routes.changeEmailScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => getIt<ChangeEmailCubit>(),
                  child: ChangeEmailScreen(),
                ));

      case Routes.changeUsernameScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => getIt<ChangeUsernameCubit>(),
                  child: ChangeUsernameScreen(),
                ));

      case Routes.emailConfirmationScreen:
        if (arguments is String) {
          return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (context) => getIt<EmailConfirmationCubit>()
                ..resendConfirmationEmail(arguments),
              child: EmailConfirmationScreen(email: arguments),
            ),
          );
        } else {
          return MaterialPageRoute(
            builder: (context) => Scaffold(
              body: Center(
                child: Text(
                    "Invalid arguments for EmailConfirmationScreen. Email is required."),
              ),
            ),
          );
        }

      case Routes.addCertificationScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => getIt<ProfileCubit>(),
            child: UserAddCertificateScreen(
              certificate: (arguments as Certification?),
            ),
          ),
        );
      case Routes.addEducationScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => getIt<ProfileCubit>(),
            child: AddEducationScreen(education: arguments as Education?),
          ),
        );
      case Routes.addExperienceScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => getIt<ProfileCubit>(),
            child: UserAddExperienceScreen(
              experience: (arguments as ExperienceResponse?),
            ),
          ),
        );

      case Routes.addSkillScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => getIt<ProfileCubit>(),
            child: UserAddSkillScreen(
              skill: (arguments as Skill?),
            ),
          ),
        );

      case Routes.blockedAccountsScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) =>
                getIt.get<BlockedAccountsCubit>()..getBlockedUsers(),
            child: BlockedAccountsScreen(),
          ),
        );
      case Routes.addResumeScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => getIt<ProfileCubit>(),
            child: UserAddResumeScreen(),
          ),
        );

      case Routes.createChat:
        return MaterialPageRoute(
          builder: (context) => CreateChatScreen(),
        );

      case Routes.createGroupChatScreen:
        return MaterialPageRoute(
          builder: (context) => CreateGroupScreen(),
        );
      case Routes.userSearchScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<SearchCubit>(),
            child: UserSearchScreen(),
          ),
        );
      case Routes.companyPicturesManage:
        if (arguments is Map<String, dynamic>) {
          return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (context) => getIt<EditCompanyCubit>(),
              child: CompanyImages(
                company: arguments['image'],
                iscover: arguments['iscover'],
                isadmin: arguments['isadmin'],
              ),
            ),
          );
        }
      case Routes.companyLocations:
        if (arguments is Company) {
          return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (context) => getIt<EditCompanyCubit>(),
              child: CompanyAddLocation(
                company: arguments
              ),
            ),
          );
        } else if (arguments is Map && arguments['company'] is Company) {
          return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (context) => getIt<EditCompanyCubit>(),
              child: CompanyAddLocation(
                company: arguments['company'].locations ?? [],
              ),
            ),
          );
        } else {
          return MaterialPageRoute(
            builder: (context) => Scaffold(
              body: Center(
                child: Text("Invalid arguments for CompanyLocations"),
              ),
            ),
          );
        }

      case Routes.savedPostsScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => getIt.get<SavedPostsCubit>()..getSavedPosts(),
            child: SavedPostsScreen(),
          ),
        );
      case Routes.messageRequestsScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => getIt<MessageRequestsCubit>(),
            child: MessageRequestsScreen(),
          ),
        );
      case Routes.adminPanel:
        return MaterialPageRoute(
          builder: (context) => (Placeholder()),
        );
      default:
        return null;
    }
  }
}
