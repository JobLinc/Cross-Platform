import 'dart:io';

import 'package:dio/dio.dart';
import 'package:joblinc/features/companypages/data/data/company.dart';
import 'package:joblinc/features/companypages/data/data/models/getmycompany_response.dart';

import '../models/update_company_model.dart';
import '../services/update_company_api_service.dart';

class UpdateCompanyRepo {
  final UpdateCompanyApiService apiService;

  UpdateCompanyRepo(this.apiService);

  Future<void> updateCompany(UpdateCompanyModel updateModel) {
    return apiService.updateCompany(updateModel);
  }

  Future<CompanyResponse> uploadCompanyLogo(File imageFile) async {
    try {
      final company = await apiService.uploadCompanyLogo(imageFile);
      return CompanyResponse.fromJson(company as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }
   Future<CompanyResponse> uploadCompanyCover(File imageFile) async {
    try {
      final company = await apiService.uploadCompanyCover(imageFile);
      return CompanyResponse.fromJson(company as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }
}
