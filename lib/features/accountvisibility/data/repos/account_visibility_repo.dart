import 'package:joblinc/features/accountvisibility/data/services/account_visibility_service.dart';
import 'package:joblinc/features/accountvisibility/ui/screens/account_visibility_screen.dart';

class AccountVisibilityRepo {
  AccountVisibilityRepo(this._accountVisibilityService);
  final AccountVisibilityService _accountVisibilityService;

  Future<void> setAccountVisibility(AccountVisibility visibility) async {
    await _accountVisibilityService.changeVisibility(visibility);
  }
}
