import 'dart:io';
import 'package:joblinc/features/jobs/data/models/job_applicants.dart';
import 'package:joblinc/features/jobs/data/models/job_application_model.dart';
import 'package:joblinc/features/jobs/data/models/job_model.dart';
import 'package:joblinc/features/jobs/data/services/job_api_service.dart';

class JobRepo {
  final JobApiService _jobApiService;
  JobRepo(this._jobApiService);

  Future<List<Map<String, dynamic>>>? getCompanyNames() async {
    final response = await _jobApiService.getCompanyNames();
    final raw = response.data as List; // cast top‐level
    return raw.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  /// Returns a Future that resolves to a list of all jobs.
  Future<List<Job>>? getAllJobs({Map<String, dynamic>? queryParams}) async {
    print("repo requesting");
    final response = await _jobApiService.getAllJobs(queryParams: queryParams);
    // final List<Job> jobs = (response.data as List)
    //     .map((jobJson) => Job.fromJson(jobJson as Map<String, dynamic>))
    //     .toList();
    // return jobs;

    final raw = response.data;
    late final List<dynamic> items;
    if (raw is List) {
      items = raw;
    } else if (raw is Map<String, dynamic> && raw['data'] is List) {
      items = raw['data'] as List;
    } else {
      throw FormatException('Unexpected jobs payload: ${raw.runtimeType}');
    }

    return items.map((j) => Job.fromJson(j as Map<String, dynamic>)).toList();
  }

  /// Returns a Future that resolves to a list of jobs the user has saved.
  Future<List<Job>>? getSavedJobs() async {
    final response = await _jobApiService.getSavedJobs();
    final List<Job> jobs = (response.data as List)
        .map((jobJson) => Job.fromJson(jobJson as Map<String, dynamic>))
        .toList();
    return jobs;
  }

  /// Returns a Future that resolves to a list of jobs the user has applied to.
  Future<List<Job>>? getAppliedJobs() async {
    final response = await _jobApiService.getAppliedJobs();
    final List<JobApplication> jobApplications = (response.data as List)
        .map((jobJson) =>
            JobApplication.fromJson(jobJson as Map<String, dynamic>))
        .toList();

    //List<Job> jobs = jobApplications.map((app) => app.job).toList();
    final jobs = jobApplications.map((app) => app.job).toList();
    return jobs;
  }

  /// Returns a Future that resolves to a list of jobs the user has applied to.
  // Future<List<Job>>? getCreatedJobs() async {
  //   final response = await _jobApiService.getCreatedJobs();
  //   final List<Job> jobs = (response.data as List)
  //       .map((jobJson) => Job.fromJson(jobJson as Map<String, dynamic>))
  //       .toList();
  //   return jobs;
  // }

  //Future<List<Job>>? getSearchedFilteredJobs(Map<String,dynamic> queryParams) async {
  //   final response =
  //       await _jobApiService.getSearchedFilteredJobs(q);
  //   final List<Job> jobs = (response.data as List)
  //       .map((jobJson) => Job.fromJson(jobJson as Map<String, dynamic>))
  //       .toList();
  //   return jobs;
  // }

  Future<List<JobApplication>>? getJobApplications() async {
    final response = await _jobApiService.getJobApplications();
    final List<JobApplication> jobApplications = (response.data as List)
        .map((jobAppJson) =>
            JobApplication.fromJson(jobAppJson as Map<String, dynamic>))
        .toList();
    return jobApplications;
  }

  Future<List<JobApplicant>>? getJobApplicants(String jobId) async {
    final response = await _jobApiService.getJobApplicants(jobId);
    final List<JobApplicant> jobApplicants = (response.data as List)
        .map((jobAppJson) =>
            JobApplicant.fromJson(jobAppJson as Map<String, dynamic>))
        .toList();
        //print(jobApplicants[0].toJson);
    return jobApplicants;

  }

  Future<JobApplicant>? getJobApplicantById(
      String jobId, String applicantId) async {
    final response =
        await _jobApiService.getJobApplicantById(jobId, applicantId);
    final JobApplicant jobApplicant =
        JobApplicant.fromJson(response.data as Map<String, dynamic>);
    return jobApplicant;
  }

  Future<List<Resume>>? getAllResumes() async {
    final response = await _jobApiService.getAllResumes();
    final List<Resume> resumes = (response.data as List)
        .map(
            (resumeJson) => Resume.fromJson(resumeJson as Map<String, dynamic>))
        .toList();
    return resumes;
  }

  Future<void>? createJob({required Map<String, dynamic> jobReq}) async {
    //final response =
    await _jobApiService.createJob(jobReq: jobReq);
    //return Job.fromJson(response as Map<String, dynamic>);
  }

  Future<void>? saveJob(String jobId) async {
    await _jobApiService.saveJob(jobId);
    //return Job.fromJson(response as Map<String, dynamic>);
  }

  Future<void>? unsaveJob(String jobId) async {
    await _jobApiService.unsaveJob(jobId);
    //return Job.fromJson(response as Map<String, dynamic>);
  }

  Future<JobApplicant>? changeJobApplicationStatus(
      String jobId, String applicantId, Map<String, dynamic> status) async {
    final response = await _jobApiService.changeJobApplicationStatus(
        jobId, applicantId, status);
    final JobApplicant jobApplicant =
        JobApplicant.fromJson(response.data as Map<String, dynamic>);
    return jobApplicant;
  }

  Future<void>? applyJob(
      String jobId, Map<String, dynamic> jobApplication) async {
    try {
      final response = await _jobApiService.applyJob(jobId, jobApplication);
      if (response.statusCode == 201) {
        return;
        // } else {
        //   // Handle error response
        //   throw Exception('Failed to apply for job: ${response.data['message']}');
      }
    } catch(e) {
      //throw Exception( e.toString().split(':').last);
      rethrow;
    }
  }

  Future<void>? acceptJobApplication(String jobId, String applicantId) async {
    await _jobApiService.acceptJobApplication(jobId, applicantId);
  }

  Future<void>? rejectJobApplication(String jobId, String applicantId) async {
    await _jobApiService.rejectJobApplication(jobId, applicantId);
  }

  Future<void>? uploadResume(File resumeFile) async {
    await _jobApiService.uploadResume(resumeFile);
  }
}
