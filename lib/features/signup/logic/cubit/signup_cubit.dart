import 'package:bloc/bloc.dart';
import 'package:joblinc/features/signup/data/models/register_request_model.dart';
import 'package:meta/meta.dart';
import 'package:joblinc/features/signup/data/repos/register_repo.dart';

part 'signup_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterRepo registerRepo;

  RegisterCubit(this.registerRepo) : super(RegisterInitial());

  Future<void> register(RegisterRequestModel req) async {
    emit(RegisterLoading());

    try {
      await registerRepo.register(req);
      emit(RegisterSuccess());
    } catch (e) {
      emit(RegisterFailure(e.toString()));
    }
  }
}
