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



class Resume {
  final String id;
  final String url;
  final DateTime date;
  final int size;
  final String name;
  final String extension;

  Resume({
    required this.id,
    required this.url,
    required this.date,
    required this.size,
    required this.name,
    required this.extension,
  });

  factory Resume.fromJson(Map<String, dynamic> json) {
    return Resume(
      id: json['id'] as String,
      url: json['url'] as String,
      date: DateTime.parse(json['date'] as String),
      size: json['size'] as int,
      name: json['name'] as String,
      extension: json['extension'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'date': date.toIso8601String(),
      'size': size,
      'name': name,
      'extension': extension,
    };
  }
}


List<Resume> mockResumes = [
  Resume(
    id: 'resume1',
    url: 'https://dl.acm.org/doi/pdf/10.1145/359168.359172',
    date: DateTime.now().subtract(Duration(days: 1)),
    size: 102400, // in bytes (example)
    name: 'My Resume 1',
    extension: '.pdf',
  ),
  Resume(
    id: 'resume2',
    url: 'https://example.com/resume2.docx',
    date: DateTime.now().subtract(Duration(days: 2)),
    size: 204800,
    name: 'My Resume 2',
    extension: '.docx',
  ),
  Resume(
    id: 'resume3',
    url: 'https://example.com/resume3.pdf',
    date: DateTime.now().subtract(Duration(days: 3)),
    size: 51200,
    name: 'My Resume 3',
    extension: '.pdf',
  ),
  Resume(
    id: 'resume4',
    url: 'https://example.com/resume4.doc',
    date: DateTime.now().subtract(Duration(days: 4)),
    size: 307200,
    name: 'My Resume 4',
    extension: '.doc',
  ),
];
