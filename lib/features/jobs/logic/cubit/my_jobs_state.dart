part of 'my_jobs_cubit.dart';

@immutable
sealed class MyJobsState {}

final class MyJobsInitial extends MyJobsState {}

final class MyJobsLoading extends MyJobsState {}

final class MySavedJobsLoaded extends MyJobsState {
  final List<Job>? savedJobs;
  MySavedJobsLoaded({this.savedJobs});
}

final class MyAppliedJobsLoaded extends MyJobsState{
    final List<Job>? appliedJobs;
  MyAppliedJobsLoaded({this.appliedJobs});
}

final class MyJobsErrorLoading extends MyJobsState {
      final String errorMessage;
  MyJobsErrorLoading(this.errorMessage);
}

final class MySavedJobsEmpty extends MyJobsState {}

final class MyAppliedJobsEmpty extends MyJobsState {}
