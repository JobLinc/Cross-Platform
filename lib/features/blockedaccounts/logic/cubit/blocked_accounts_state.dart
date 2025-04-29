import 'package:joblinc/features/blockedaccounts/data/models/blocked_account_model.dart';

abstract class BlockedAccountsState {}

class BlockedAccountsInitial extends BlockedAccountsState {}

class BlockedAccountsLoading extends BlockedAccountsState {}

class BlockedAccountsLoaded extends BlockedAccountsState {
  List<BlockedAccountModel> blockedAccounts;
  BlockedAccountsLoaded(this.blockedAccounts);
}

class BlockedAccountsFailure extends BlockedAccountsState {
  BlockedAccountsFailure(this.error);
  final String error;
}
