import 'dart:io';

import 'package:joblinc/features/jobs/data/models/job_application_model.dart';
import 'package:joblinc/features/jobs/data/models/job_model.dart';
import 'package:joblinc/features/jobs/data/services/job_api_service.dart';
import 'package:joblinc/features/jobs/ui/screens/job_search_screen.dart';

class JobRepo {

  final JobApiService _jobApiService;
  JobRepo(this._jobApiService);

  /// Returns a Future that resolves to a list of all jobs.
  Future<List<Job>> getAllJobs() async {
    final response = await _jobApiService.getAllJobs();
    final List<Job> jobs = (response.data as List)
        .map((jobJson) => Job.fromJson(jobJson as Map<String, dynamic>))
        .toList();
    return jobs;
  }


  /// Returns a Future that resolves to a list of jobs the user has saved.
  Future<List<Job>> getSavedJobs() async {
    final response = await _jobApiService.getSavedJobs();
    final List<Job> jobs = (response.data as List)
        .map((jobJson) => Job.fromJson(jobJson as Map<String, dynamic>))
        .toList();
    return jobs;
  }

  /// Returns a Future that resolves to a list of jobs the user has applied to.
  Future<List<Job>> getAppliedJobs() async {
    final response = await _jobApiService.getAppliedJobs();
    final List<Job> jobs = (response.data as List)
        .map((jobJson) => Job.fromJson(jobJson as Map<String, dynamic>))
        .toList();
    return jobs;
  }

    /// Returns a Future that resolves to a list of jobs the user has applied to.
  Future<List<Job>> getCreatedJobs() async {
    final response = await _jobApiService.getCreatedJobs();
    final List<Job> jobs = (response.data as List)
        .map((jobJson) => Job.fromJson(jobJson as Map<String, dynamic>))
        .toList();
    return jobs;
  }

  Future<List<Job>> getSearchedFilteredJobs(String keyword,String? location,Filter? filter) async{
    final response = await _jobApiService.getSearchedFilteredJobs(keyword,location,filter);
    final List<Job> jobs = (response.data as List)
        .map((jobJson) => Job.fromJson(jobJson as Map<String, dynamic>))
        .toList();
    return jobs;
  }

  Future<List<JobApplication>> getJobApplications() async{
    final response = await _jobApiService.getJobApplications();
    final List<JobApplication> jobApplications= (response.data as List)
        .map((jobAppJson) => JobApplication.fromJson(jobAppJson as Map<String, dynamic>))
        .toList();
    return jobApplications;
  }

    Future<List<JobApplication>> getJobApplicants(String jobId) async{
    final response = await _jobApiService.getJobApplicants(jobId);
    final List<JobApplication> jobApplicants= (response.data as List)
        .map((jobAppJson) => JobApplication.fromJson(jobAppJson as Map<String, dynamic>))
        .toList();
    return jobApplicants;
  }

      Future<JobApplication> getJobApplicantById(String jobId,String applicantId) async{
    final response = await _jobApiService.getJobApplicantById(jobId,applicantId);
    final JobApplication jobApplicant=JobApplication.fromJson( response.data as Map<String, dynamic>);
    return jobApplicant;
  }
  Future<List<Resume>> getAllResumes() async {
    final response = await _jobApiService.getAllResumes();
    final List<Resume> resumes = (response.data as List)
        .map((resumeJson) => Resume.fromJson(resumeJson as Map<String, dynamic>))
        .toList();
    return resumes;
  }

  Future<void> createJob(Job job) async {
    //final response =
     await _jobApiService.createJob(job);
    //return Job.fromJson(response as Map<String, dynamic>);
  }


  Future<void> saveJob(String jobId) async {
    await _jobApiService.saveJob(jobId);
    //return Job.fromJson(response as Map<String, dynamic>);
  }
  Future<void> unsaveJob(String jobId) async {
    await _jobApiService.unsaveJob(jobId);
    //return Job.fromJson(response as Map<String, dynamic>);
  }

  Future<void> applyJob(String jobId, JobApplication jobApplication) async {
    //final response =
    await _jobApiService.applyJob(jobId,jobApplication);
    //return Job.fromJson(response as Map<String, dynamic>);
  }

  Future<void> acceptJobApplication(String jobId, String applicantId) async {
    await _jobApiService.acceptJobApplication(jobId, applicantId);
  }

    Future<void> rejectJobApplication(String jobId, String applicantId) async {
    await _jobApiService.rejectJobApplication(jobId, applicantId);
  }


  Future<void> uploadResume(File resumeFile) async{
    await _jobApiService.uploadResume(resumeFile);
  }



}