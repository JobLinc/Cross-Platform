import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repos/email_confirmation_repo.dart';
import 'email_confirmation_state.dart';

class EmailConfirmationCubit extends Cubit<EmailConfirmationState> {
  final EmailConfirmationRepo _repo;
  String _email = '';
  String _token = '';

  EmailConfirmationCubit(this._repo) : super(EmailConfirmationInitial());

  void setEmail(String email) {
    _email = email;
  }

  Future<void> sendConfirmationEmail() async {
    emit(SendingConfirmationEmail());

    try {
      final response = await _repo.sendConfirmationEmail(_email);
      _token = response.token;
      emit(ConfirmationEmailSent(_token));
    } catch (e) {
      emit(SendConfirmationEmailFailure(e.toString()));
    }
  }

  Future<void> confirmEmail(String otp) async {
    emit(ConfirmingEmail());

    try {
      final response = await _repo.confirmEmail(_email, _token, otp);
      emit(EmailConfirmed(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
        userId: response.userId,
        role: response.role,
      ));
    } catch (e) {
      emit(ConfirmEmailFailure(e.toString()));
    }
  }
}
