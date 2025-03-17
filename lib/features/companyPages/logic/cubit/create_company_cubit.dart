import 'package:bloc/bloc.dart';
import 'package:joblinc/features/companyPages/data/company.dart';
import 'package:flutter/material.dart';

part 'create_company_state.dart';

class CreateCompanyCubit extends Cubit<CreateCompanyState> {
  CreateCompanyCubit() : super(CreateCompanyInitial());

  CreateCompany(
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
      mockCompanies.add(companyToAdd);
      print(mockCompanies);

      emit(CreateCompanySuccess());
    // ignore: unused_catch_clause
    } on Exception catch (e) {
      emit(CreateCompanyFailure());
    }
  }
}
