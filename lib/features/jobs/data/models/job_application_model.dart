import 'package:joblinc/features/jobs/data/models/job_model.dart';
import 'package:joblinc/features/premium/data/models/user_model.dart';

class JobApplication {
  final User applicant; 
  final Job job; 
  final String resume;
  final String status;
  final DateTime createdAt;

  JobApplication({
    required this.applicant,
    required this.job,
    required this.resume,
    required this.status,
    required this.createdAt,
  });


  factory JobApplication.fromJson(Map<String, dynamic> json) {
    return JobApplication(
      applicant: User.fromJson(json['applicant']),
      job: Job.fromJson(json['job']),
      resume: json['resume'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'applicant': applicant.toJson(),
      'job': job.toJson(),
      'resume': resume,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
