import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/features/blockedaccounts/data/models/blocked_account_model.dart';
import 'package:joblinc/features/blockedaccounts/data/repos/blocked_account_repo.dart';
import 'package:joblinc/features/blockedaccounts/logic/cubit/blocked_accounts_state.dart';

class BlockedAccountsCubit extends Cubit<BlockedAccountsState> {
  final BlockedAccountRepo blockedAccountRepo;

  BlockedAccountsCubit(this.blockedAccountRepo)
      : super(BlockedAccountsInitial());

  Future<void> getBlockedUsers() async {
    emit(BlockedAccountsLoading());
    try {
      final respone = await blockedAccountRepo.getBlockedUsers();
      emit(BlockedAccountsLoaded(respone));
    } catch (e) {
      emit(BlockedAccountsFailure(e.toString()));
    }
  }
}
