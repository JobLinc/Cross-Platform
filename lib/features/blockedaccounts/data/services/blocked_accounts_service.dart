import 'package:dio/dio.dart';
import 'package:joblinc/features/blockedaccounts/data/models/blocked_account_model.dart';

class BlockedAccountsService {
  final Dio _dio;

  BlockedAccountsService(this._dio);

  Future<List<BlockedAccountModel>> getBlockedUsers() async {
    try {
      final response = await _dio.get('/connection/blocked');

      List<BlockedAccountModel> blockedAccounts = [];
      for (Map<String, dynamic> blockedUser in response.data) {
        blockedAccounts.add(BlockedAccountModel.fromJson(blockedUser));
      }
      return blockedAccounts;
    } catch (e) {
      throw Exception('Failed to fetch blocked accounts: ${e.toString()}');
    }
  }

  Future<void> changeConnectionStatus(
      String userId, ConnectionStatus newStatus) async {
    try {
      final statusMessage =
          '${newStatus.toString()[0].toUpperCase()}${newStatus.toString().substring(1)}';
      await _dio
          .post('/connection/$userId/change', data: {'status': statusMessage});
    } catch (e) {
      throw Exception('Failed to fetch blocked accounts: ${e.toString()}');
    }
  }
}

enum ConnectionStatus {
  blocked,
  unblocked,
  canceled,
}
