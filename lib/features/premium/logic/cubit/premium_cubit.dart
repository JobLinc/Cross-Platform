import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'premium_state.dart';

class PremiumCubit extends Cubit<PremiumState> {
  PremiumCubit() : super(PremiumInitial());
}
