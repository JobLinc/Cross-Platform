import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/features/signup/data/models/register_request_model.dart';
import 'package:joblinc/features/signup/data/repos/register_repo.dart';

part 'signup_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterRepo registerRepo;

  RegisterCubit(this.registerRepo) : super(RegisterInitial());

  Future<void> register(RegisterRequestModel req) async {
    emit(RegisterLoading());

    try {
      final response = await registerRepo.register(req);
      emit(RegisterSuccess(
        confirmed: false,
        email: req.email,
      ));
    } catch (e) {
      emit(RegisterFailure(e.toString()));
    }
  }
}
