import 'package:bloc/bloc.dart';
import 'package:joblinc/features/jobs/data/models/job_application_model.dart';
import 'package:joblinc/features/jobs/data/models/job_model.dart';
import 'package:joblinc/features/jobs/data/repos/job_repo.dart';
import 'package:joblinc/features/jobs/data/services/job_api_service.dart';
import 'package:meta/meta.dart';

part 'my_jobs_state.dart';

class MyJobsCubit extends Cubit<MyJobsState> {
  final JobRepo jobRepo;

  List<Job> _jobs =[];
  List<JobApplication> _jobsApplications=[];

  MyJobsCubit(this.jobRepo) : super(MyJobsInitial());

  Future<void> getSavedJobs() async{
    emit(MyJobsLoading());
    try {
      _jobs=await jobRepo.getSavedJobs();
      if (_jobs.isEmpty){
        emit(MySavedJobsEmpty());
      } else{
        emit(MySavedJobsLoaded(savedJobs: _jobs ));
      }
    } catch (e) {
      emit(MyJobsErrorLoading(e.toString()));
    } 
  }


    Future<void> getAppliedJobs() async{
    emit(MyJobsLoading());
    try {
      _jobs=await jobRepo.getAppliedJobs();
      if (_jobs.isEmpty){
        emit(MyAppliedJobsEmpty());
      } else{
        emit(MyAppliedJobsLoaded(appliedJobs: _jobs ));
      }
    } catch (e) {
      emit(MyJobsErrorLoading(e.toString()));
    } 
  }


  Future<void> getJobApplications() async {
        emit(MyJobsLoading());
    try {
      _jobsApplications=await jobRepo.getJobApplications();
      if (_jobs.isEmpty){
        emit(MyJobApplicationsEmpty());
      } else{
        emit(MyJobApplicationsLoaded(jobApplications: _jobsApplications ));
      }
    } catch (e) {
      emit(MyJobsErrorLoading(e.toString()));
    } 
  }
}
