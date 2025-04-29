import 'package:dio/dio.dart';
import 'package:joblinc/features/accountvisibility/ui/screens/account_visibility_screen.dart';

class AccountVisibilityService {
  AccountVisibilityService(this._dio);
  final Dio _dio;

  Future<void> changeVisibility(AccountVisibility visibility) async {
    final String visibilityText;
    switch (visibility) {
      case AccountVisibility.public:
        visibilityText = 'Public';
        break;
      case AccountVisibility.connectionsOnly:
        visibilityText = 'Connections';
        break;
    }

    try {
      final respone = await _dio.put('/user/edit/personal-info',
          data: {'visibility': visibilityText});
    } catch (e) {
      throw Exception('Error changing visibility: ${e.toString()}');
    }
  }
}
