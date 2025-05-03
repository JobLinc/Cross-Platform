import 'package:flutter/material.dart';
import 'package:joblinc/core/routing/routes.dart';

class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  
  factory NavigationService() {
    return _instance;
  }
  
  NavigationService._internal();
  
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  
  Future<dynamic> navigateToMainContainer(int tabIndex) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
      Routes.homeScreen, 
      (route) => false,
      arguments: tabIndex
    );
  }

  Future<dynamic> navigateToMainContainerSafely(int tabIndex) {
    try {
      if (navigatorKey.currentState == null) {
        // If navigator is not available, schedule for later
        debugPrint('Navigation: Navigator not available, scheduling navigation');
        Future.delayed(const Duration(milliseconds: 500), () {
          navigateToMainContainer(tabIndex);
        });
        return Future.value();
      }
      
      return navigatorKey.currentState!.pushNamedAndRemoveUntil(
       Routes.homeScreen, 
        (route) => false,
        arguments: tabIndex
      );
    } catch (e) {
      debugPrint('Navigation: Error navigating to home: $e');
      return Future.value();
    }
  }
  
}
