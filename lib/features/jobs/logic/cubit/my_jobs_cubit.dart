import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/features/jobs/data/models/job_applicants.dart';
import 'package:joblinc/features/jobs/data/models/job_application_model.dart';
import 'package:joblinc/features/jobs/data/models/job_model.dart';
import 'package:joblinc/features/jobs/data/repos/job_repo.dart';

part 'my_jobs_state.dart';

class MyJobsCubit extends Cubit<MyJobsState> {
  final JobRepo jobRepo;

  List<Job> _jobs = [];
  List<JobApplication> _jobApplications = [];
  List<JobApplicant> _jobApplicants = [];
  JobApplicant? _jobApplicant;

  MyJobsCubit(this.jobRepo) : super(MyJobsInitial());

  Future<void> getSavedJobs() async {
    emit(MyJobsLoading());
    try {
      _jobs = await jobRepo.getSavedJobs()!;
      if (_jobs.isEmpty) {
        emit(MySavedJobsEmpty());
      } else {
        emit(MySavedJobsLoaded(savedJobs: _jobs));
      }
    } catch (e) {
      emit(MyJobsErrorLoading(e.toString()));
    }
  }

  Future<void> getAppliedJobs() async {
    emit(MyJobsLoading());
    try {
      _jobs = await jobRepo.getAppliedJobs()!;
      if (_jobs.isEmpty) {
        emit(MyAppliedJobsEmpty());
      } else {
        emit(MyAppliedJobsLoaded(appliedJobs: _jobs));
      }
    } catch (e) {
      emit(MyJobsErrorLoading(e.toString()));
    }
  }

  Future<void> getCreatedJobs(String userId) async {
    emit(MyJobsLoading());
    try {
      _jobs = await jobRepo.getAllJobs(queryParams: {"employer.id": userId})!;
      if (_jobs.isEmpty) {
        emit(MyCreatedJobsEmpty());
      } else {
        emit(MyCreatedJobsLoaded(createdJobs: _jobs));
      }
    } catch (e) {
      emit(MyJobsErrorLoading(e.toString()));
    }
  }

  Future<void> getJobApplications() async {
    emit(MyJobsLoading());
    try {
      _jobApplications = await jobRepo.getJobApplications()!;
      if (_jobApplications.isEmpty) {
        emit(MyJobApplicationsEmpty());
      } else {
        emit(MyJobApplicationsLoaded(jobApplications: _jobApplications));
      }
    } catch (e) {
      emit(MyJobsErrorLoading(e.toString()));
    }
  }

  Future<void> getJobApplicants(String jobId) async {
    emit(MyJobsLoading());
    try {
      _jobApplicants = await jobRepo.getJobApplicants(jobId)!;
      if (_jobApplicants.isEmpty) {
        emit(MyJobApplicantsEmpty());
      } else {
        emit(MyJobApplicantsLoaded(jobApplicants: _jobApplicants));
      }
    } catch (e) {
      emit(MyJobsErrorLoading(e.toString()));
    }
  }

  // Future<void> getJobApplicantById(String jobId, String applicantId) async {
  //   emit(MyJobApplicantLoading());
  //   try {
  //     _jobApplicant = await jobRepo.getJobApplicantById(jobId, applicantId)!;
  //     if (_jobApplicant == null) {
  //       emit(MyJobApplicantsEmpty());
  //     } else {
  //       emit(MyJobApplicantLoaded(jobApplicant: _jobApplicant!));
  //     }
  //   } catch (e) {
  //     emit(MyJobsErrorLoading(e.toString()));
  //   }
  // }

  Future<void> changeJobApplicationStatus(String jobId, String jobApplicationId,
      Map<String, dynamic> status) async {
    emit(MyJobApplicantLoading());
    try {
      _jobApplicant = await jobRepo.changeJobApplicationStatus(jobId, jobApplicationId, status);
            if (_jobApplicant == null) {
        emit(MyJobApplicantsEmpty());
      } else {
        emit(MyJobApplicantLoaded(jobApplicant: _jobApplicant!));
      }
    } on Exception catch (e) {
      emit(MyJobsErrorLoading(e.toString()));
    }
  }

  // acceptJobApplication(String jobId, String applicantId) async {
  //   await jobRepo.acceptJobApplication(jobId, applicantId);
  //   await getJobApplicantById(jobId, applicantId);
  // }

  // rejectJobApplication(String jobId, String applicantId) async {
  //   await jobRepo.rejectJobApplication(jobId, applicantId);
  //   await getJobApplicantById(jobId, applicantId);
  // }

  emitMyJobApplicantLoaded(JobApplicant jobApplicant) {
    changeJobApplicationStatus(jobApplicant.job, jobApplicant.id, {"status": "Viewed"});
    //emit(MyJobApplicantLoaded(jobApplicant: jobApplicant));
  }
}
