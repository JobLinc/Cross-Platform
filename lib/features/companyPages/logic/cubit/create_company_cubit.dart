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
      websiteController}) async {
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
          companyToAdd.website!,
          companyToAdd.profileUrl!,
          companyToAdd.industry.toString(),
          "overview");
      mockCompanies.add(companyToAdd);

      emit(CreateCompanySuccess());
      // ignore: unused_catch_clause
    } on Exception catch (e) {
      print(e);
      emit(CreateCompanyFailure());
    }
  }
}
