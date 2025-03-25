import 'package:bloc/bloc.dart';
import 'package:joblinc/features/companyPages/data/data/company.dart';
import 'package:flutter/material.dart';
import '../../data/data/repos/createcompany_repo.dart';

part 'create_company_state.dart';

class CreateCompanyCubit extends Cubit<CreateCompanyState> {
  final CreateCompanyRepo _createCompanyRepo;
   final void Function(Company) onCompanyCreated; // Callback for navigation

  CreateCompanyCubit(this._createCompanyRepo, {required this.onCompanyCreated})
      : super(CreateCompanyInitial());


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
          "ohhhoohpo@gmail.com",
          "12347859788212734567876547",
          companyToAdd.industry.displayName,
          "overview");
      mockCompanies.add(companyToAdd);

      onCompanyCreated(companyToAdd);
      emit(CreateCompanySuccess());
      // ignore: unused_catch_clause
    } catch (e) {
      emit(CreateCompanyFailure(e.toString()));
    }
  }
}
