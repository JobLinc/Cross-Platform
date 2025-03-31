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

  /// Returns a Future that resolves to a list of jobs the user has applied to.
  Future<List<Job>> getAppliedJobs() async {
    final response = await _jobApiService.getAppliedJobs();
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

  Future<List<Job>> getSearchedJobs(String keyword,String? location,Filter? filter) async{
    final response = await _jobApiService.getSearchedJobs(keyword,location,filter);
    final List<Job> jobs = (response.data as List)
        .map((jobJson) => Job.fromJson(jobJson as Map<String, dynamic>))
        .toList();
    return jobs;
  }

  Future<List<Resume>> getAllResumes() async {
    final response = await _jobApiService.getAllResumes();
    final List<Resume> resumes = (response.data as List)
        .map((resumeJson) => Resume.fromJson(resumeJson as Map<String, dynamic>))
        .toList();
    return resumes;
  }

  Future<Job> createJob(Job job) async {
    final response = await _jobApiService.createJob(job);
    return Job.fromJson(response as Map<String, dynamic>);
  }


  Future<void> saveJob(int jobId) async {
    await _jobApiService.saveJob(jobId);
    //return Job.fromJson(response as Map<String, dynamic>);
  }
  Future<void> unsaveJob(int jobId) async {
    await _jobApiService.unsaveJob(jobId);
    //return Job.fromJson(response as Map<String, dynamic>);
  }

  Future<void> applyJob(int jobId, JobApplication jobApplication) async {
    //final response =
    await _jobApiService.applyJob(jobId,jobApplication);
    //return Job.fromJson(response as Map<String, dynamic>);
  }


  Future<void> uploadResume(File resumeFile) async{
    await _jobApiService.uploadResume(resumeFile);
  }



}