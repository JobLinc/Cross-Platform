import 'package:joblinc/features/companyPages/data/data/services/companyjobs_api.dart';
import 'package:joblinc/features/jobs/data/models/job_model.dart';

class GetCompanyJobsRepo {
  final GetCompanyJobsApiService apiService;

  GetCompanyJobsRepo(this.apiService);

  Future<List<Job>> getCompanyJobs() {
    return apiService.getCompanyJobs();
  }
}
