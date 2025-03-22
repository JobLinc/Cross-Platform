part of 'create_company_cubit.dart';

abstract class CreateCompanyState {}

class CreateCompanyInitial extends CreateCompanyState {}

class CreateCompanyLoading extends CreateCompanyState {}

class CreateCompanySuccess extends CreateCompanyState {}

class CreateCompanyFailure extends CreateCompanyState {
  final String error;

  CreateCompanyFailure(this.error);
}