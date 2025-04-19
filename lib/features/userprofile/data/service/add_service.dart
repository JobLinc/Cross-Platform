import 'package:dio/dio.dart';
import 'package:joblinc/features/userprofile/data/models/certificate_model.dart';
import 'package:joblinc/features/userprofile/data/models/experience_model.dart';
class addService {
  final Dio dio;

  addService(this.dio);

  Future<List<Certification>> fetchCertificates() async {
    try {
      final response = await dio.get('/user/certificate');
      List data = response.data;
      return data.map((json) => Certification.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load certifications: $e');
    }
  }

  Future<Response> addCertification(Certification certification) async {
    try {
      Response response = await dio.post(
        '/user/certificate/add',
        data: certification.toJson(),
      );

      return response;
    } catch (e) {
      throw Exception('Failed to add certification: $e');
    }
  }

  Future<Response> deleteCertification(String certificationId) async {
    try {
      Response response = await dio.delete(
        '/user/certificate/$certificationId',
      );

      return response;
    } catch (e) {
      throw Exception('Failed to delete certification: $e');
    }
  }

  Future<List<dynamic>> getAllCertificates() async {
    try {
      final response = await dio.get('/user/certificate');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to fetch certificates');
      }
    } catch (e) {
      throw Exception('API error: $e');
    }
  }

  Future<List<Certification>> fetchExperiences() async {
    try {
      final response = await dio.get('/user/experience');
      List data = response.data;
      return data.map((json) => Certification.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load experiences: $e');
    }
  }

  Future<Response> addExperience(Experience experience) async {
    try {
      Response response = await dio.post(
        '/user/experience/add',
        data: experience.toJson(), 
      );

      return response;
    } catch (e) {
      throw Exception('Failed to add experience: $e');
    }
  }

  Future<Response> deleteExperience(String experienceId) async {
    try {
      Response response = await dio.delete(
        '/user/experience/$experienceId',
      );

      return response;
    } catch (e) {
      throw Exception('Failed to delete experience: $e');
    }
  }

  Future<List<dynamic>> getAllExperiences() async {
    try {
      final response = await dio.get('/user/experience');

      if (response.statusCode == 200) {
        return response.data; 
      } else {
        throw Exception('Failed to fetch experiences');
      }
    } catch (e) {
      throw Exception('API error: $e');
    }
  }
  
}
