import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/features/companypages/data/data/company.dart';
import 'package:joblinc/features/companypages/data/data/models/update_company_model.dart';
import 'package:joblinc/features/companypages/data/data/repos/update_company_repo.dart';

part 'edit_company_state.dart';

class EditCompanyCubit extends Cubit<EditCompanyState> {
  final UpdateCompanyRepo _companyRepo;
  EditCompanyCubit(this._companyRepo) : super(EditCompanySuccess());

  Future<void> updateCompany(UpdateCompanyModel updateData) async {
    try {
      emit(EditCompanyInitial());
      await _companyRepo.updateCompany(updateData);
      emit(EditCompanySuccess());
      // Reload the profile to get the updated data
    } catch (e) {
      if (!isClosed) {
        emit(EditCompanyFailure(
            'Failed to update company data: ${e.toString()}'));
      }
    }
  }

  Future<Company?> uploadCompanyLogo(File imageFile) async {
    try {
      emit(EditCompanyInitial());
      final companyResponse = await _companyRepo.uploadCompanyLogo(imageFile);
      emit(EditCompanySuccess());
      return Company(
        name: companyResponse.name,
        profileUrl: companyResponse.urlSlug,
        industry: IndustryExtension.fromDisplayName(companyResponse.industry) ??
            Industry.technology,
        organizationSize:
            OrganizationSizeExtension.fromDisplayName(companyResponse.size) ??
                OrganizationSize.elevenToFifty,
        organizationType:
            OrganizationTypeExtension.fromDisplayName(companyResponse.type) ??
                OrganizationType.governmentAgency,
        overview: companyResponse.overview,
        website: companyResponse.website,
        logoUrl: companyResponse.logo,
        id: companyResponse.id,
        followers: companyResponse.followers!,
      );
    } catch (e) {
      emit(EditCompanyFailure('Error: $e'));
    }
  }

  Future<Company?> uploadCompanyCover(File imageFile) async {
    try {
      emit(EditCompanyInitial());
      final companyResponse = await _companyRepo.uploadCompanyCover(imageFile);
      emit(EditCompanySuccess());
      return Company(
        name: companyResponse.name,
        profileUrl: companyResponse.urlSlug,
        industry: IndustryExtension.fromDisplayName(companyResponse.industry) ??
            Industry.technology,
        organizationSize:
            OrganizationSizeExtension.fromDisplayName(companyResponse.size) ??
                OrganizationSize.elevenToFifty,
        organizationType:
            OrganizationTypeExtension.fromDisplayName(companyResponse.type) ??
                OrganizationType.governmentAgency,
        overview: companyResponse.overview,
        website: companyResponse.website,
        logoUrl: companyResponse.logo,
        coverUrl: companyResponse.coverPhoto,
        id: companyResponse.id,
        followers: companyResponse.followers!,
      );
    } catch (e) {
      emit(EditCompanyFailure('Error: $e'));
      return null;
    }
  }

  Future<Company?> removeCompanyLogo() async {
    try {
      emit(EditCompanyInitial());
      final companyResponse = await _companyRepo.removeCompanyLogo();
      emit(EditCompanySuccess());
      return Company(
        name: companyResponse.name,
        profileUrl: companyResponse.urlSlug,
        industry: IndustryExtension.fromDisplayName(companyResponse.industry) ??
            Industry.technology,
        organizationSize:
            OrganizationSizeExtension.fromDisplayName(companyResponse.size) ??
                OrganizationSize.elevenToFifty,
        organizationType:
            OrganizationTypeExtension.fromDisplayName(companyResponse.type) ??
                OrganizationType.governmentAgency,
        overview: companyResponse.overview,
        website: companyResponse.website,
        logoUrl: companyResponse.logo,
        coverUrl: companyResponse.coverPhoto,
        id: companyResponse.id,
        followers: companyResponse.followers ?? 0,
      );
    } catch (e) {
      emit(EditCompanyFailure('Error: $e'));
      return null;
    }
  }

  Future<Company?> removeCompanyCover() async {
    try {
      emit(EditCompanyInitial());
      final companyResponse = await _companyRepo.removeCompanyCover();
      emit(EditCompanySuccess());
      return Company(
        name: companyResponse.name,
        profileUrl: companyResponse.urlSlug,
        industry: IndustryExtension.fromDisplayName(companyResponse.industry) ??
            Industry.technology,
        organizationSize:
            OrganizationSizeExtension.fromDisplayName(companyResponse.size) ??
                OrganizationSize.elevenToFifty,
        organizationType:
            OrganizationTypeExtension.fromDisplayName(companyResponse.type) ??
                OrganizationType.governmentAgency,
        overview: companyResponse.overview,
        website: companyResponse.website,
        logoUrl: companyResponse.logo,
        coverUrl: companyResponse.coverPhoto,
        id: companyResponse.id,
        followers: companyResponse.followers ?? 0,
      );
    } catch (e) {
      emit(EditCompanyFailure('Error: $e'));
      return null;
    }
  }
}
