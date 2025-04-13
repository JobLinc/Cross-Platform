part of 'my_jobs_cubit.dart';

@immutable
sealed class MyJobsState {}

final class MyJobsInitial extends MyJobsState {}

final class MyJobsLoading extends MyJobsState {}

final class MySavedJobsLoaded extends MyJobsState {
  final List<Job> savedJobs;
  MySavedJobsLoaded({required this.savedJobs});
}

final class MyAppliedJobsLoaded extends MyJobsState{
    final List<Job> appliedJobs;
  MyAppliedJobsLoaded({required this.appliedJobs});
}

final class MyCreatedJobsLoaded extends MyJobsState{
    final List<Job> createdJobs;
  MyCreatedJobsLoaded({required this.createdJobs});
}

final class MyJobsErrorLoading extends MyJobsState {
      final String errorMessage;
  MyJobsErrorLoading(this.errorMessage);
}



final class MySavedJobsEmpty extends MyJobsState {}

final class MyAppliedJobsEmpty extends MyJobsState {}
final class MyCreatedJobsEmpty extends MyJobsState {}

final class MyJobApplicationsLoaded extends MyJobsState {
  final List<JobApplication> jobApplications;
  MyJobApplicationsLoaded({required this.jobApplications});
}

final class MyJobApplicationsEmpty extends MyJobsState{}

final class MyJobApplicantsLoaded extends MyJobsState{
  final List<JobApplication> jobApplicants;
  MyJobApplicantsLoaded({required this.jobApplicants});
}
final class MyJobApplicantsEmpty extends MyJobsState{}

final class MyJobApplicantLoading extends MyJobsState{}
final class MyJobApplicantLoaded extends MyJobsState{
  final JobApplication jobApplicant;
  MyJobApplicantLoaded({required this.jobApplicant});
}
