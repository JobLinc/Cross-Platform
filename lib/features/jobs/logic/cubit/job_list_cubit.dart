import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:joblinc/features/jobs/data/models/job_application_model.dart';
import 'package:joblinc/features/jobs/data/models/job_model.dart';
import 'package:joblinc/features/jobs/data/repos/job_repo.dart';
import 'package:joblinc/features/jobs/ui/screens/job_search_screen.dart';

part 'job_list_state.dart';

class JobListCubit extends Cubit<JobListState> {
  final JobRepo jobRepo;
  List<Job> _jobs = [];
  List<Map<String,dynamic>> companyNames=[];
  JobListCubit(this.jobRepo) : super(JobListInitial());

    Future<void> getCompanyNames() async {
    try {
      companyNames = await jobRepo.getCompanyNames()!;
    } catch (e) {
      emit(JobListErrorLoading(e.toString()));
    }
  }

  Future<void> getAllJobs({bool isSearch= false,Map<String,dynamic>? queryParams}) async {
    isSearch ? emit(JobSearchLoading()): emit(JobListLoading()) ;
    try {
      print("cubit requesting");
      _jobs = await jobRepo.getAllJobs(queryParams: queryParams)!;
      if (_jobs.isEmpty) {
        isSearch ? emit(JobSearchEmpty()): emit(JobListEmpty());
      } else {
        isSearch ? emit(JobSearchLoaded(searchedJobs: _jobs)): emit(JobListLoaded(jobs: _jobs));
      }
    } catch (e) {
      emit(JobListErrorLoading(e.toString()));
    }
  }

  Future<void> getSavedJobs() async{
    emit(JobSavedLoading());
    try {
      _jobs=await jobRepo.getSavedJobs()!;
      if (_jobs.isEmpty){
        emit(JobSavedEmpty());
      } else{
        emit(JobSavedLoaded(savedJobs: _jobs ));
      }
    } catch (e) {
      emit(JobSavedErrorLoading(e.toString()));
    } 
  }


    Future<void> getAppliedJobs() async{
    emit(JobAppliedLoading());
    try {
      _jobs=await jobRepo.getAppliedJobs()!;
      if (_jobs.isEmpty){
        emit(JobAppliedEmpty());
      } else{
        emit(JobAppliedLoaded(appliedJobs: _jobs ));
      }
    } catch (e) {
      emit(JobAppliedErrorLoading(e.toString()));
    } 
  }


  //   Future<void> getSearchedFilteredJobs(String keyword, String? location,Filter? filter) async {
  //   emit(JobSearchLoading());
  //   try {
  //     _jobs = await jobRepo.getSearchedFilteredJobs(keyword,location,filter)!;
  //     if (_jobs.isEmpty) {
  //       emit(JobSearchEmpty());
  //     } else {
  //       emit(JobSearchLoaded(searchedJobs: _jobs));
  //     }
  //   } catch (e) {
  //     emit(JobListErrorLoading(e.toString()));
  //   }
  // }


    Future<void> getJobDetails() async {
    emit(JobDetailsLoading());
    try {
      List<Job> savedJobs = await jobRepo.getSavedJobs()!;
      List<Job> appliedJobs = await jobRepo.getAppliedJobs()!;
      emit(JobDetailsLoaded(savedJobs: savedJobs, appliedJobs: appliedJobs));
    } catch (e) {
      emit(JobDetailsErrorLoading(e.toString()));
    }
  }

  Future<void> getAllResumes() async {
    emit(JobResumesLoading());
    try {
      List<Resume> resumes = await jobRepo.getAllResumes()!;
      emit(JobResumesLoaded(resumes: resumes));
    } catch (e) {
      emit(JobResumesErrorLoading(e.toString()));
    }
  }
  

  uploadResume(File resumeFile) async {
    await jobRepo.uploadResume(resumeFile);
  }

  unsaveJob(String jobId) async {
    await jobRepo.unsaveJob(jobId);
  }

  saveJob(String jobId) async {
    await jobRepo.saveJob(jobId);
  }

  applyJob(String jobId, JobApplication jobApplication) async {
    emit(JobApplicationSending());
    try {
      await jobRepo.applyJob(jobId, jobApplication);
      emit(JobApplicationSent());
    } catch (e) {
      emit(JobApplicationErrorSending(e.toString()));
    }
  }

  createJob({required Map<String,dynamic> jobReq}) async{
        emit(JobCreating());
    try {
      await jobRepo.createJob(jobReq:jobReq);
      emit(JobCreated());
    } catch (e) {
      emit(JobCreationError(e.toString()));
    }
  }

  emitJobSearchInitial(){
    emit(JobSearchInitial());
  }
}




