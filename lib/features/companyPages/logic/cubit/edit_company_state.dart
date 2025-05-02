part of 'edit_company_cubit.dart';

abstract class EditCompanyState {}

class EditCompanyInitial extends EditCompanyState {}

class EditCompanyFailed extends EditCompanyState {
  final String error;

  EditCompanyFailed(this.error);
}

class EditCompanySuccess extends EditCompanyState 
{
  final Company? company;

  EditCompanySuccess({ this.company});
}

class EditCompanyFailure extends EditCompanyState {
  final String error;

  EditCompanyFailure(this.error);
}
