import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/features/companypages/data/data/company.dart';
import 'package:joblinc/features/companypages/data/data/models/update_company_model.dart';
import 'package:joblinc/features/companypages/data/data/repos/getmycompany_repo.dart';
import 'package:joblinc/features/companypages/data/data/repos/update_company_repo.dart';

part 'edit_company_state.dart';

class EditCompanyCubit extends Cubit<EditCompanyState> {
  final UpdateCompanyRepo _companyRepo;
  EditCompanyCubit(this._companyRepo) : super(EditCompanyInitial());
  

  Future<void> updateCompany(UpdateCompanyModel updateData) async {
    try {
      emit(EditCompanyInitial());
      await _companyRepo.updateCompany(updateData);
      emit(EditCompanySuccess());
      // Reload the profile to get the updated data
    } catch (e) {
      if (!isClosed) {
        emit(EditCompanyFailure('Failed to update company data: ${e.toString()}'));
      }
    }
  }

  Future<void> uploadCompanyLogo(File imageFile) async {
    // UserProfileUpdateModel updateData =
    //     UserProfileUpdateModel(profilePicture: imageFile.path);
    try {
      // Call the repository to upload the image
      emit(EditCompanyLoading());
      Response response =
          await _companyRepo.uploadCompanyLogo(imageFile);

      if (response.statusCode == 200) {
        UpdateCompanyModel picModel =
            UpdateCompanyModel(logo: response.data["logo"]);
        updateCompany(picModel);
        // getUserProfile();
      } else {
        emit(EditCompanyFailure('Failed to upload company logo: ${response.statusMessage}'));
      }
    } catch (e) {
      emit(EditCompanyFailure('Error: $e'));
    }
  }
}
