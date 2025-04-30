import 'package:dio/dio.dart';
import 'package:joblinc/features/jobs/data/models/job_model.dart';

class GetCompanyJobsApiService {
  final Dio dio;
  final String companyId;

  GetCompanyJobsApiService(this.companyId, this.dio);

  Future<List<Job>> getCompanyJobs() async {
    try {
      final response = await dio.get(
        '/jobs?company.id=$companyId',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List)
            .map((json) => Job.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load company posts');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }
}
