import 'package:flutter/material.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/services/navigation_service.dart';
import 'package:joblinc/features/notifications/logic/cubit/notification_cubit.dart';

class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  
  factory DeepLinkService() {
    return _instance;
  }
  
  DeepLinkService._internal();
  
  // This should be called after app initialization is complete
  Future<void> handleInitialRoutes() async {
    try {
      // Only proceed if user is logged in
      final notificationCubit = getIt<NotificationCubit>();
      final messagingService = notificationCubit.getMessagingService();
      
      if (messagingService != null) {
        await messagingService.checkInitialMessage();
      }
    } catch (e) {
      debugPrint('DeepLink: Error handling initial routes: $e');
    }
  }
}
