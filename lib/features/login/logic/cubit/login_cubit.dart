import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/features/login/data/repos/login_repo.dart';
import 'package:joblinc/features/login/logic/cubit/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepo _loginRepo;

  LoginCubit(this._loginRepo) : super(LoginInitial());

  Future<void> login(String email, String password) async {
    emit(LoginLoading());

    try {
      final loginResponse = await _loginRepo.login(email, password);

      // Check if the user's email is confirmed
      if (!loginResponse.confirmed) {
        emit(LoginEmailNotConfirmed(email));
        return;
      }

      emit(LoginSuccess());
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }

  Future<void> loginWithGoogle() async {
    emit(LoginLoading());
    try {
      final loginResponse = await _loginRepo.loginWithGoogle();

      if (!loginResponse.confirmed) {
        emit(LoginEmailNotConfirmed(loginResponse.email));
        return;
      }

      emit(LoginSuccess());
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
}
