part of 'job_list_cubit.dart';

//@immutable
abstract class JobListState {}

final class JobListInitial extends JobListState {}
final class JobListLoading extends JobListState {}
final class JobListLoaded extends JobListState {
  final List<Job>? jobs;
  JobListLoaded({this.jobs});
}
final class JobListErrorLoading extends JobListState {
  final String errorMessage;
  JobListErrorLoading(this.errorMessage);
}
final class JobListEmpty extends JobListState {}



final class JobResumesLoading extends JobListState {}
final class JobResumesLoaded extends JobListState {
  final List<Resume>? resumes;
  JobResumesLoaded({this.resumes});
}
final class JobResumesErrorLoading extends JobListState {
  final String errorMessage;
  JobResumesErrorLoading(this.errorMessage);
}



final class JobApplicationSending extends JobListState{}
final class JobApplicationSent extends JobListState{}
final class JobApplicationErrorSending extends JobListState{
  final String errorMessage;
  JobApplicationErrorSending(this.errorMessage);
}


final class JobSearchInitial extends JobListState{}
final class JobSearchLoading extends JobListState{}
final class JobSearchLoaded extends JobListState{
    final List<Job>? searchedJobs;
    JobSearchLoaded({this.searchedJobs});
}
final class JobSearchErrorLoading extends JobListState{
  final String errorMessage;
  JobSearchErrorLoading(this.errorMessage);
}
final class JobSearchEmpty extends JobListState{}


final class JobSavedLoading extends JobListState{}
final class JobSavedEmpty extends JobListState{}
final class JobSavedLoaded extends JobListState{
  final List<Job> savedJobs;
  JobSavedLoaded({required this.savedJobs});
}
final class JobSavedErrorLoading extends JobListState{
    final String errorMessage;
  JobSavedErrorLoading(this.errorMessage);
}

final class JobAppliedLoading extends JobListState{}
final class JobAppliedEmpty extends JobListState{}
final class JobAppliedLoaded extends JobListState{
    final List<Job> appliedJobs;
  JobAppliedLoaded({required this.appliedJobs});
}
final class JobAppliedErrorLoading extends JobListState{
      final String errorMessage;
  JobAppliedErrorLoading(this.errorMessage);
}

final class JobDetailsLoading extends JobListState {}
final class JobDetailsLoaded extends JobListState {
  final List<Job> savedJobs;
  final List<Job> appliedJobs;
  JobDetailsLoaded({required this.savedJobs,required this.appliedJobs});
  List<Object> get props => [savedJobs, appliedJobs];
}
final class JobDetailsErrorLoading extends JobListState {
  final String errorMessage;
  JobDetailsErrorLoading(this.errorMessage);
}


final class JobCreating extends JobListState {}
final class JobCreated extends JobListState {}
final class JobCreationError extends JobListState {
    final String errorMessage;
  JobCreationError(this.errorMessage);
}

