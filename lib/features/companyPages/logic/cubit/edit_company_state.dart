part of 'edit_company_cubit.dart';

abstract class EditCompanyState {}

class EditCompanyInitial extends EditCompanyState {}

class EditCompanyLoading extends EditCompanyState {}

class EditCompanySuccess extends EditCompanyState {
  
}

class EditCompanyFailure extends EditCompanyState {
  final String error;

  EditCompanyFailure(this.error);
}