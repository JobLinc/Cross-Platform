// // features/company/logic/cubit/company_cubit.dart
// import 'package:bloc/bloc.dart';
// import 'package:joblinc/features/companyPages/data/data/repos/getmycompany_repo.dart';
// import '../../data/data/models/getmycompany_response.dart';

// part 'company_state.dart';

// class CompanyCubit extends Cubit<CompanyState> {
//   final CompanyRepository _repository;

//   CompanyCubit(this._repository) : super(CompanyInitial());

//   Future<void> loadCurrentCompany() async {
//     emit(CompanyLoading());
//     try {
//       final company = await _repository.getCurrentCompany();
//       emit(CompanyLoaded(company));
//     } catch (e) {
//       emit(CompanyError(e.toString()));
//     }
//   }
// }
