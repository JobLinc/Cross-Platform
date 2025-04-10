import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/helpers/auth_helpers/auth_service.dart';
import 'package:joblinc/features/changeemail/data/repos/change_email_repo.dart';
import 'package:joblinc/features/changeemail/logic/cubit/change_email_state.dart';

class ChangeEmailCubit extends Cubit<ChangeEmailState> {
  final ChangeEmailRepo _changeEmailRepo;

  ChangeEmailCubit(this._changeEmailRepo) : super(ChangeEmailInitial());

  Future<void> updateEmail(String newEmail) async {
    emit(ChangeEmailLoading());

    try {
      // Call repository to update email
      final response = await _changeEmailRepo.updateEmail(newEmail);

      // Update the auth info with the new email and set confirmed to false
      final AuthService authService = getIt<AuthService>();
      await authService.updateEmail(newEmail);
      await authService.updateConfirmationStatus(false);
      emit(ChangeEmailSuccess(
          'Email updated successfully. Please login with your new email.'));
    } catch (e) {
      // Clean error message by removing "Exception: " prefix if present
      final errorMessage = e.toString().startsWith('Exception: ')
          ? e.toString().substring('Exception: '.length)
          : e.toString();

      emit(ChangeEmailFailure(errorMessage));
    }
  }
}
