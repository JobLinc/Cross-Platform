import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/features/signup/data/models/register_request_model.dart';
import 'package:joblinc/features/signup/data/repos/register_repo.dart';

import 'package:joblinc/features/signup/logic/cubit/signup_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterRepo registerRepo;

  RegisterCubit(this.registerRepo) : super(RegisterInitial());

  Future<void> register(RegisterRequestModel req) async {
    emit(RegisterLoading());

    try {
      await registerRepo.register(req);
      emit(RegisterSuccess());
    } catch (e) {
      // Clean up error message by removing "Exception: " prefix if present
      final errorMessage = e.toString().startsWith('Exception: ')
          ? e.toString().substring('Exception: '.length)
          : e.toString();

      emit(RegisterFailure(errorMessage));
    }
  }
}
