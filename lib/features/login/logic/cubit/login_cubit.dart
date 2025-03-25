import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/core/helpers/auth_helpers/auth_service.dart';
import 'login_state.dart';
import '../../data/repos/login_repo.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepo _loginRepo;

  LoginCubit(this._loginRepo) : super(LoginInitial());

  Future<void> login(String email, String password) async {
    emit(LoginLoading());

    try {
      final response = await _loginRepo.login(email, password);
      emit(LoginSuccess(
        confirmed: response["confirmed"],
        email: response["email"],
      ));
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
}
