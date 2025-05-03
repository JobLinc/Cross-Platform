import 'package:flutter/material.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/features/notifications/data/models/notification_model.dart';
import 'package:joblinc/features/posts/ui/screens/focus_post_screen.dart';

class NavigationService {
  static final NavigationService _instance = NavigationService._internal();

  factory NavigationService() {
    return _instance;
  }

  NavigationService._internal();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateToMainContainer(int tabIndex) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
        Routes.homeScreen, (route) => false,
        arguments: tabIndex);
  }

  Future<dynamic> navigateToMainContainerSafely(int tabIndex) {
    try {
      if (navigatorKey.currentState == null) {
        // If navigator is not available, schedule for later
        debugPrint(
            'Navigation: Navigator not available, scheduling navigation');
        Future.delayed(const Duration(milliseconds: 500), () {
          navigateToMainContainer(tabIndex);
        });
        return Future.value();
      }

      return navigatorKey.currentState!.pushNamedAndRemoveUntil(
          Routes.homeScreen, (route) => false,
          arguments: tabIndex);
    } catch (e) {
      debugPrint('Navigation: Error navigating to home: $e');
      return Future.value();
    }
  }

  Future<dynamic> navigateToChatScreenSafely(String chatId) {
    try {
      if (navigatorKey.currentState == null) {
        // If navigator is not available, schedule for later
        debugPrint(
            'Navigation: Navigator not available, scheduling chat navigation');

        return Future.value();
      }

      return navigatorKey.currentState!
          .pushNamed(Routes.chatScreen, arguments: chatId);
    } catch (e) {
      debugPrint('Navigation: Error navigating to chat screen: $e');
      return Future.value();
    }
  }

  Future<dynamic> navigateToUserProfileSafely(String userId) {
    try {
      if (navigatorKey.currentState == null) {
        // If navigator is not available, schedule for later
        debugPrint(
            'Navigation: Navigator not available, scheduling profile navigation');

        return Future.value();
      }
      return navigatorKey.currentState!
          .pushNamed(Routes.otherProfileScreen, arguments: userId);
    } catch (e) {
      debugPrint('Navigation: Error navigating to user profile: $e');
      return Future.value();
    }
  }

  Future<dynamic> navigateToFocusPostSafely(String postId) {
    try {
      if (navigatorKey.currentState == null) {
        // If navigator is not available, schedule for later
        debugPrint(
            'Navigation: Navigator not available, scheduling focus post navigation');

        return Future.value();
      }
      return navigatorKey.currentState!.push(MaterialPageRoute(
        builder: (context) => FocusPostScreen(postId: postId),
      ));
    } catch (e) {
      debugPrint('Navigation: Error navigating to focus post: $e');
      return Future.value();
    }
  }

  void notificationNavigator(NotificationModel notification) {
    try {
      if (notification.relatedEntityId == null) {
        debugPrint('Navigation: No related entity ID found in notification');
        navigateToMainContainer(3);

        return;
      }

      switch (notification.type) {
        case 'ConnectionRequest':
          navigateToUserProfileSafely(notification.relatedEntityId!);
          break;
        case 'ConnectionAccepted':
          navigateToUserProfileSafely(notification.relatedEntityId!);
          break;
        case 'Follow':
          navigateToUserProfileSafely(notification.relatedEntityId!);
          break;
        case 'Like':
          // Navigate to the post that was liked
          navigateToFocusPostSafely(notification.relatedEntityId!);
          break;
        case 'Comment':
          // Navigate to the post that was commented on
          navigateToFocusPostSafely(notification.relatedEntityId!);
          break;
        case 'PostCreated':
          // Navigate to the newly created post
          navigateToFocusPostSafely(notification.relatedEntityId!);
          break;
        case 'Tag':
          // Navigate to post where user was tagged
          navigateToFocusPostSafely(notification.relatedEntityId!);
          break;
        case 'CommentTag':
          // Navigate to comment where user was tagged
          navigateToFocusPostSafely(notification.relatedEntityId!);
          break;
        case 'CommentReply':
          // Navigate to the comment thread
          navigateToFocusPostSafely(notification.relatedEntityId!);
          break;
        case 'CommentLike':
          // Navigate to the liked comment
          navigateToFocusPostSafely(notification.relatedEntityId!);
          break;
        case 'PostRepost':
          // Navigate to the reposted post
          navigateToFocusPostSafely(notification.relatedEntityId!);
          break;
        case 'AppliedForJob':
          // Navigate to job applications screen
          navigateToMainContainer(4); // Jobs tab
          break;
        case 'PostNewJob':
          // Navigate to new job posting
          navigateToMainContainer(4); // Jobs tab
          break;
        case 'JobApplicationUpdate':
          navigateToMainContainer(4);
          break;
        case 'Message':
          navigateToChatScreenSafely(notification.relatedEntityId!);
          break;
        default:
          navigateToMainContainer(3);
      }
    } catch (e) {
      debugPrint('Navigation: Error navigating to notification screen: $e');
    }
  }
}
