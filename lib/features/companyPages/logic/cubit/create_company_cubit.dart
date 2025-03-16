import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'create_company_state.dart';

class CreateCompanyCubit extends Cubit<CreateCompanyState> {
  CreateCompanyCubit() : super(CreateCompanyInitial());
}
