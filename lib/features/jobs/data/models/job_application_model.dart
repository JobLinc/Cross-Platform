import 'package:joblinc/features/jobs/data/models/job_applicants.dart';
import 'package:joblinc/features/jobs/data/models/job_model.dart';

class JobApplication {
  //final Applicant applicant;
  final String id;
  final Job job;
  final String phone;
  final Resume resume;
  final String status;
  final DateTime createdAt;

  JobApplication({
    //required this.applicant,
    required this.id,
    required this.job,
    required this.phone,
    required this.resume,
    required this.status,
    required this.createdAt,
  });

  factory JobApplication.fromJson(Map<String, dynamic> json) {
    return JobApplication(
      //applicant: Applicant.fromJson(json['applicant']),
      id:json['id'],
      job: Job.fromJson(json['job']),
      phone:json['phone'],
      resume: Resume.fromJson(json['resume']),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      //'applicant': applicant.toJson(),
      'id':id,
      'job': job.toJson(),
      'phone':phone,
      'resume': resume.toJson(),
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
