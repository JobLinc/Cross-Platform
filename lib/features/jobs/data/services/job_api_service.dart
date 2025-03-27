import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:joblinc/features/jobs/data/models/job_application_model.dart';
import 'package:joblinc/features/jobs/data/models/job_model.dart';

class JobApiService {
  final Dio _dio;

  JobApiService(this._dio);

  /// Retrieves certain jobs.
  Future<Response> getJob(int jobId) async {
    try {
      final response = await _dio.get('/job/$jobId');
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Retrieves all available jobs.
  Future<Response> getAllJobs() async {
    if (0 == 1) {
      try {
        final response = await _dio.get('/job/applied');
        return response;
      } catch (e) {
        rethrow;
      }
    } else {
      await Future.delayed(Duration(seconds: 2));
      final response = Response<dynamic>(
        requestOptions: RequestOptions(path: ''),
        data: mockJobs.map((job) => job.toJson()).toList(),
        statusCode: 200,
        statusMessage: 'OK',
      );
      return response;
    }
  }

  /// Retrieves the jobs the user has applied to.
  Future<Response> getAppliedJobs() async {
    if (0 == 1) {
      try {
        final response = await _dio.get('/job/applied');
        return response;
      } catch (e) {
        rethrow;
      }
    } else {
      await Future.delayed(Duration(seconds: 2));
      final response = Response<dynamic>(
        requestOptions: RequestOptions(path: ''),
        data: mockAppliedJobs.map((job) => job.toJson()).toList(),
        statusCode: 200,
        statusMessage: 'OK',
      );
      return response;
    }
  }

  /// Retrieves the jobs the user has saved.
  Future<Response> getSavedJobs() async {
    if (0 == 1) {
      try {
        final response = await _dio.get('/job/saved');
        return response;
      } catch (e) {
        rethrow;
      }
    } else {
      await Future.delayed(Duration(seconds: 2));
      final response = Response<dynamic>(
        requestOptions: RequestOptions(path: ''),
        data: mockSavedJobs.map((job) => job.toJson()).toList(),
        statusCode: 200,
        statusMessage: 'OK',
      );
      return response;
    }
  }

  Future<Response> createJob(Job job) async {
    try {
      Map<String, dynamic> jobData = job.toJson();
      final response = await _dio.post('/job/create', data: jobData);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> saveJob(String jobId) async {
    try {
      final response = await _dio.post('/jobs/$jobId/save');
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> applyJob(String jobId, JobApplication jobApplication) async {
    try {
      Map<String, dynamic> applicationData = jobApplication.toJson();
      final response =
          await _dio.post('/jobs/$jobId/apply', data: applicationData);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
