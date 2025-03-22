import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'job_state.dart';

class JobCubit extends Cubit<JobState> {
  JobCubit() : super(JobInitial());
}
