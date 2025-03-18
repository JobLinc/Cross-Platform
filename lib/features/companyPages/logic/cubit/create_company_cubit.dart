import 'package:bloc/bloc.dart';
import 'package:joblinc/features/companyPages/data/data/company.dart';
import 'package:flutter/material.dart';
import '../../data/data/repos/createcompany_repo.dart';

part 'create_company_state.dart';

class CreateCompanyCubit extends Cubit<CreateCompanyState> {
  final CreateCompanyRepo _createCompanyRepo;

  CreateCompanyCubit(this._createCompanyRepo) : super(CreateCompanyInitial());

  Future<void> createCompany(
      {required TextEditingController nameController,
      required TextEditingController jobLincUrlController,
      required Industry selectedIndustry,
      required OrganizationSize orgSize,
      required OrganizationType orgType,
      required TextEditingController websiteController}) async {
    emit(CreateCompanyLoading());

    try {
      Company companyToAdd = Company(
        name: nameController.text,
        profileUrl: jobLincUrlController.text,
        industry: selectedIndustry,
        organizationSize: orgSize,
        organizationType: orgType,
        website: websiteController.text.isEmpty
            ? "https://www.linkedin.com"
            : websiteController.text,
      );

      await _createCompanyRepo.createCompany(
          companyToAdd.name,
          "a123@gmail.com",
          "123456789",
          companyToAdd.industry.displayName,
          "overview");
      mockCompanies.add(companyToAdd);

      emit(CreateCompanySuccess());
      // ignore: unused_catch_clause
    } catch (e) {
      emit(CreateCompanyFailure(e.toString()));
    }
  }
}
