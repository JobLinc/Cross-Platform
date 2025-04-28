import 'dart:io';

import 'package:dio/dio.dart';

import '../models/update_company_model.dart';
import '../services/update_company_api_service.dart';

class UpdateCompanyRepo {
  final UpdateCompanyApiService apiService;

  UpdateCompanyRepo(this.apiService);

  Future<void> updateCompany(UpdateCompanyModel updateModel) {
    return apiService.updateCompany(updateModel);
  }

  Future<Response> uploadCompanyLogo(File imageFile) async {
    try {
      return await apiService.uploadCompanyLogo(imageFile);
    } catch (e) {
      rethrow;
    }
  }
}
