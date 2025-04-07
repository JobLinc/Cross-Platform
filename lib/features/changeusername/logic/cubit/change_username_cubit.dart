import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/features/changeusername/data/repos/change_username_repo.dart';

part 'change_username_state.dart';

class ChangeUsernameCubit extends Cubit<ChangeUsernameState> {
  final ChangeUsernameRepo _changeUsernameRepo;

  ChangeUsernameCubit(this._changeUsernameRepo)
      : super(ChangeUsernameInitial());

  Future<void> changeUsername({
    required String newUsername,
  }) async {
    emit(ChangeUsernameLoading());
    try {
      await _changeUsernameRepo.changeUsername(
        newUsername: newUsername,
      );
      emit(ChangeUsernameSuccess());
    } catch (e) {
      // Clean error message
      final errorMessage = e.toString().startsWith('Exception: ')
          ? e.toString().substring('Exception: '.length)
          : e.toString();

      emit(ChangeUsernameFailure(errorMessage));
    }
  }
}
