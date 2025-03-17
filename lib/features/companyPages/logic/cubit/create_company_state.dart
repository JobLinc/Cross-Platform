part of 'create_company_cubit.dart';

abstract class CreateCompanyState {}

final class CreateCompanyInitial extends CreateCompanyState {}

final class CreateCompanyLoading extends CreateCompanyState {}

final class CreateCompanySuccess extends CreateCompanyState {}

final class CreateCompanyFailure extends CreateCompanyState {}
