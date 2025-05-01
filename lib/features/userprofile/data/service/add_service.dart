import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:joblinc/features/userprofile/data/models/certificate_model.dart';
import 'package:joblinc/features/userprofile/data/models/education_model.dart';
import 'package:joblinc/features/userprofile/data/models/experience_model.dart';
import 'package:joblinc/features/userprofile/data/models/skill_model.dart';

class addService {
  final Dio dio;

  addService(this.dio);

  Future<List<Certification>> fetchCertificates() async {
    try {
      final response = await dio.get('/user/certificate');
      List data = response.data;
      return data.map((json) => Certification.fromJson(json)).toList();
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response!.data;
        print(errorData);
        final errorMessage = errorData['message'] ?? 'Something went wrong';
        //print('Error: $errorMessage');
        throw Exception(errorMessage);
      } else {
        throw Exception("Error : ${e.toString()}");
      }
    }
  }

  Future<Response> addCertification(Certification certification) async {
    try {
      Response response = await dio.post(
        '/user/certificate/add',
        data: certification.toJson(),
      );
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response!.data;
        print(errorData);
        final errorMessage = errorData['message'] ?? 'Something went wrong';
        //print('Error: $errorMessage');
        throw Exception(errorMessage);
      } else {
        throw Exception("Error : ${e.toString()}");
      }
    }
  }

  Future<Response> addEducation(Education education) async {
    try {
      Response response = await dio.post(
        '/user/education/add',
        data: education.toJson(),
      );
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response!.data;
        print(errorData);
        final errorMessage = errorData['message'] ?? 'Something went wrong';
        //print('Error: $errorMessage');
        throw Exception(errorMessage);
      } else {
        throw Exception("Error : ${e.toString()}");
      }
    }
  }

  Future<Response> deleteEducation(String educationId) async {
    try {
      Response response = await dio.delete(
        '/user/education/$educationId',
      );

      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response!.data;
        print(errorData);
        final errorMessage = errorData['message'] ?? 'Something went wrong';

        throw Exception(errorMessage);
      } else {
        throw Exception("Error : ${e.toString()}");
      }
    }
  }

  Future<Response> editEducation(Education education) async {
    try {
      Response response = await dio.put(
        '/user/education/${education.educationId}',
        data: education.toJson(),
      );

      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response!.data;
        print(errorData);
        final errorMessage = errorData['message'] ?? 'Something went wrong';
        throw Exception(errorMessage);
      } else {
        throw Exception("Error : ${e.toString()}");
      }
    }
  }

  Future<Response> editCertification(Certification certification) async {
    try {
      Response response = await dio.put(
        '/user/certificate/${certification.certificationId}',
        data: certification.toJson(),
      );

      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response!.data;
        print(errorData);
        final errorMessage = errorData['message'] ?? 'Something went wrong';
        //print('Error: $errorMessage');
        throw Exception(errorMessage);
      } else {
        throw Exception("Error : ${e.toString()}");
      }
    }
  }

  Future<List<dynamic>> getUserEducations() async {
    try {
      final response = await dio.get('/user/education');
      return response.data;
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Failed to fetch education.');
    }
  }

  Future<Response> deleteCertification(String certificationId) async {
    try {
      Response response = await dio.delete(
        '/user/certificate/$certificationId',
      );

      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response!.data;
        print(errorData);
        final errorMessage = errorData['message'] ?? 'Something went wrong';
        //print('Error: $errorMessage');
        throw Exception(errorMessage);
      } else {
        throw Exception("Error : ${e.toString()}");
      }
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
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response!.data;
        print(errorData);
        final errorMessage = errorData['message'] ?? 'Something went wrong';
        //print('Error: $errorMessage');
        throw Exception(errorMessage);
      } else {
        throw Exception("Error : ${e.toString()}");
      }
    }
  }

  Future<List<Certification>> fetchExperiences() async {
    try {
      final response = await dio.get('/user/experience');
      List data = response.data;
      return data.map((json) => Certification.fromJson(json)).toList();
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response!.data;
        print(errorData);
        final errorMessage = errorData['message'] ?? 'Something went wrong';
        //print('Error: $errorMessage');
        throw Exception(errorMessage);
      } else {
        throw Exception("Error : ${e.toString()}");
      }
    }
  }

  Future<Response> addExperience(ExperienceModel experience) async {
    try {
      print(" this is the experience model ${experience.toJson()}");
      Response response = await dio.post(
        '/user/experience/add',
        data: experience.toJson(),
      );
      print(response.data);
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response!.data;
        print(errorData);
        final errorMessage = errorData['message'] ?? 'Something went wrong';
        //print('Error: $errorMessage');
        throw Exception(errorMessage);
      } else {
        throw Exception("Error : ${e.toString()}");
      }
    }
  }
  Future<Response> editExperience(ExperienceModel experience) async {
    try {
      Response response = await dio.put(
        '/user/experience/${experience.experienceId}',
        data: experience.toJson(),
      );

      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response!.data;
        print(errorData);
        final errorMessage = errorData['message'] ?? 'Something went wrong';
        //print('Error: $errorMessage');
        throw Exception(errorMessage);
      } else {
        throw Exception("Error : ${e.toString()}");
      }
    }
  }
  Future<Response> deleteExperience(String experienceId) async {
    try {
      Response response = await dio.delete(
        '/user/experience/$experienceId',
      );

      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response!.data;
        print(errorData);
        final errorMessage = errorData['message'] ?? 'Something went wrong';
        //print('Error: $errorMessage');
        throw Exception(errorMessage);
      } else {
        throw Exception("Error : ${e.toString()}");
      }
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
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response!.data;
        print(errorData);
        final errorMessage = errorData['message'] ?? 'Something went wrong';
        //print('Error: $errorMessage');
        throw Exception(errorMessage);
      } else {
        throw Exception("Error : ${e.toString()}");
      }
    }
  }

  Future<List<Skill>> fetchSkills() async {
    try {
      final response = await dio.get('/user/skill');
      List data = response.data;
      return data.map((json) => Skill.fromJson(json)).toList();
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response!.data;
        print(errorData);
        final errorMessage = errorData['message'] ?? 'Something went wrong';
        //print('Error: $errorMessage');
        throw Exception(errorMessage);
      } else {
        throw Exception("Error : ${e.toString()}");
      }
    }
  }

  Future<Response> addSkill(Skill skill) async {
    try {
      Response response = await dio.post(
        '/user/skills/add',
        data: skill.toJson(),
      );

      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response!.data;
        print(errorData);
        final errorMessage = errorData['message'] ?? 'Something went wrong';
        //print('Error: $errorMessage');
        throw Exception(errorMessage);
      } else {
        throw Exception("Error : ${e.toString()}");
      }
    }
  }

  Future<Response> editSkill(Skill skill) async {
    try {
      Response response = await dio.put(
        '/user/skills/${skill.id}',
        data: skill.toJson(),
      );

      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response!.data;
        print(errorData);
        final errorMessage = errorData['message'] ?? 'Something went wrong';
        //print('Error: $errorMessage');
        throw Exception(errorMessage);
      } else {
        throw Exception("Error : ${e.toString()}");
      }
    }
  }

  Future<Response> deleteSkill(String skillId) async {
    try {
      Response response = await dio.delete(
        '/user/skills/$skillId',
      );

      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response!.data;
        print(errorData);
        final errorMessage = errorData['message'] ?? 'Something went wrong';
        //print('Error: $errorMessage');
        throw Exception(errorMessage);
      } else {
        throw Exception("Error : ${e.toString()}");
      }
    }
  }

  Future<List<dynamic>> getAllSkills() async {
    try {
      final response = await dio.get('/user/skills');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to fetch skills');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response!.data;
        print(errorData);
        final errorMessage = errorData['message'] ?? 'Something went wrong';
        //print('Error: $errorMessage');
        throw Exception(errorMessage);
      } else {
        throw Exception("Error : ${e.toString()}");
      }
    }
  }

  Future<Response> uploadResume(File file) async {
    try {
      final fileName = file.path.split('/').last;
      print(" this is the media type ${getMediaType(file).toString()}");
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: fileName,
          contentType: getMediaType(file),
        ),
      });

      final response = await dio.post('/user/resume/upload', data: formData);
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response!.data;
        print(errorData);
        final errorMessage = errorData['message'] ?? 'Something went wrong';
        //print('Error: $errorMessage');
        throw Exception(errorMessage);
      } else {
        throw Exception("Error : ${e.toString()}");
      }
    }
  }

  Future<List<dynamic>> getUserResumes() async {
    try {
      final response = await dio.get('/user/resume');
      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response!.data;
        print(errorData);
        final errorMessage = errorData['message'] ?? 'Something went wrong';
        //print('Error: $errorMessage');
        throw Exception(errorMessage);
      } else {
        throw Exception("Error : ${e.toString()}");
      }
    }
  }

  Future<Response> deleteUserResume(String resumeid) async {
    try {
      final response = await dio.delete('/user/resume/$resumeid');
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response!.data;
        print(errorData);
        final errorMessage = errorData['message'] ?? 'Something went wrong';
        //print('Error: $errorMessage');
        throw Exception(errorMessage);
      } else {
        throw Exception("Error : ${e.toString()}");
      }
    }
  }
}

MediaType getMediaType(File file) {
  final extension = file.path.split('.').last.toLowerCase();

  switch (extension) {
    case 'pdf':
      return MediaType('application', 'pdf');
    case 'doc':
    case 'docx':
      return MediaType('application', 'msword'); // MIME type for Word documents
    default:
      return MediaType(
          'application', 'octet-stream'); // Fallback for unsupported types
  }
}
