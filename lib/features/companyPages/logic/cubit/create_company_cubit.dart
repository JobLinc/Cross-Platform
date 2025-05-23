import 'package:bloc/bloc.dart';
import 'package:joblinc/features/companypages/data/data/company.dart';
import 'package:flutter/material.dart';
import 'package:joblinc/features/companypages/data/data/models/createcompany_response.dart';
import 'package:joblinc/features/companypages/data/data/repos/createcompany_repo.dart';

part 'create_company_state.dart';

class CreateCompanyCubit extends Cubit<CreateCompanyState> {
  final CreateCompanyRepo _createCompanyRepo;
  final void Function(Company) onCompanyCreated; // Callback for navigation

  CreateCompanyCubit(this._createCompanyRepo, {required this.onCompanyCreated})
      : super(CreateCompanyInitial());

  Future<void> createCompany({
    required TextEditingController nameController,
    required TextEditingController jobLincUrlController,
    required Industry selectedIndustry,
    required OrganizationSize orgSize,
    required OrganizationType orgType,
    required TextEditingController websiteController,
    required TextEditingController overviewController,
  }) async {
    emit(CreateCompanyLoading());

    try {
      Company companyToAdd = Company(
        name: nameController.text,
        profileUrl: jobLincUrlController.text,
        industry: selectedIndustry.displayName,
        organizationSize: orgSize.displayName,
        organizationType: orgType.displayName,
        website: websiteController.text.isEmpty
            ? "https://www.linkedin.com"
            : websiteController.text,
        overview: overviewController.text,
        isFollowing: false
      );

      final CreateCompanyResponse response =
          await _createCompanyRepo.createCompany(
              name: companyToAdd.name,
              urlSlug: companyToAdd.profileUrl,
              industry: companyToAdd.industry,
              size: companyToAdd.organizationSize,
              type: companyToAdd.organizationType,
              overview: companyToAdd.overview!,
              website: companyToAdd.website!);

      companyToAdd.id = response.id;

      emit(CreateCompanySuccess());
      onCompanyCreated(companyToAdd);
    } catch (e) {
      if (!isClosed) {
        final errorMsg = e is Exception
            ? e.toString().replaceFirst('Exception:', '').trim()
            : 'Unknown error';
        print('CreateCompanyFailure: $errorMsg');
        emit(CreateCompanyFailure(errorMsg));
      }
    }
  }
}
