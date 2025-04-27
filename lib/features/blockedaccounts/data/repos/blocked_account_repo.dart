import 'package:joblinc/features/blockedaccounts/data/models/blocked_account_model.dart';
import 'package:joblinc/features/blockedaccounts/data/services/blocked_accounts_service.dart';

class BlockedAccountRepo {
  final BlockedAccountsService blockedAccountsService;
  BlockedAccountRepo(this.blockedAccountsService);

  Future<List<BlockedAccountModel>> getBlockedUsers() async {
    return await blockedAccountsService.getBlockedUsers();
  }

  Future<void> unBlockUser(String userId) async {
    return await blockedAccountsService.changeConnectionStatus(
        userId, ConnectionStatus.unblocked);
  }
}
