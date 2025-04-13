import 'package:joblinc/features/jobs/data/models/job_model.dart';

class JobApplication {
  final Applicant applicant;
  final Job job;
  final Resume resume;
  String status;
  final DateTime createdAt;

  JobApplication({
    required this.applicant,
    required this.job,
    required this.resume,
    this.status="Pending",
    required this.createdAt,
  });

  factory JobApplication.fromJson(Map<String, dynamic> json) {
    return JobApplication(
      applicant: Applicant.fromJson(json['applicant']),
      job: Job.fromJson(json['job']),
      resume: Resume.fromJson(json['resume']),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'applicant': applicant.toJson(),
      'job': job.toJson(),
      'resume': resume.toJson(),
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

List<JobApplication> mockJobApplications = [
  JobApplication(
    applicant: mockMainApplicant,
    job: Job(
      id: '10',
      title: "Marketing Specialist",
      industry: "Marketing",
      company: Company(name: "AdWorks", size: "200 employees"),
      description: "Create and implement marketing campaigns.",
      workplace: "Remote",
      type: "Contract",
      experienceLevel: "Entry-Level",
      salaryRange: SalaryRange(min: 40000, max: 60000),
      location: Location(city: "New York", country: "USA"),
      keywords: ["SEO", "Content Marketing", "Social Media"],
      createdAt: DateTime.now(),
    ),
    resume: Resume(
      id: 'r1',
      url: 'https://example.com/resume1.pdf',
      date: DateTime.now(),
      size: 500,
      name: 'Alice_Resume',
      extension: 'pdf',
    ),
    status: 'Pending',
    createdAt: DateTime.now(),
  ),
];


  List<Job> mockCreatedJobs = [
    Job(
      id: '333',
      title: "Assistant",
      industry: "Marketing",
      company: Company(name: "Abdelrahman", size: "0 employees"),
      description: "Create and implement marketing campaigns.",
      workplace: "Remote",
      type: "Contract",
      experienceLevel: "Entry-Level",
      salaryRange: SalaryRange(min: 40000, max: 60000),
      location: Location(city: "New York", country: "USA"),
      keywords: ["SEO", "Content Marketing", "Social Media"],
      createdAt: DateTime.now(),
    ),
  ];

List<JobApplication> mockJobApplicants = [
  JobApplication(
    applicant: Applicant(
      id: "user_010",
      firstname: "jane",
      lastname: "doe",
      username: "jenny22",
      email: "janeDoe@gmail.com",
      country: "USA",
      city: "New York",
      phoneNumber: "+3214567890",
    ),
    job: Job(
      id: '333',
      title: "Assistant",
      industry: "Marketing",
      company: Company(name: "Abdelrahman", size: "0 employees"),
      description: "Create and implement marketing campaigns.",
      workplace: "Remote",
      type: "Contract",
      experienceLevel: "Entry-Level",
      salaryRange: SalaryRange(min: 40000, max: 60000),
      location: Location(city: "New York", country: "USA"),
      keywords: ["SEO", "Content Marketing", "Social Media"],
      createdAt: DateTime.now(),
    ),
    resume: Resume(
      id: 'r1',
      url: 'https://example.com/resume1.pdf',
      date: DateTime.now(),
      size: 500,
      name: 'jane_Resume',
      extension: 'pdf',
    ),
    status: 'Pending',
    createdAt: DateTime.now(),
  ),
  JobApplication(
    applicant: Applicant(
      id: "user_009",
      firstname: "john",
      lastname: "doe",
      username: "johnny22",
      email: "johnDoe@gmail.com",
      country: "USA",
      city: "New York",
      phoneNumber: "+1234567890",
    ),
    job: Job(
      id: '333',
      title: "Assistant",
      industry: "Marketing",
      company: Company(name: "Abdelrahman", size: "0 employees"),
      description: "Create and implement marketing campaigns.",
      workplace: "Remote",
      type: "Contract",
      experienceLevel: "Entry-Level",
      salaryRange: SalaryRange(min: 40000, max: 60000),
      location: Location(city: "New York", country: "USA"),
      keywords: ["SEO", "Content Marketing", "Social Media"],
      createdAt: DateTime.now(),
    ),
    resume: Resume(
      id: 'r1',
      url: 'https://example.com/resume1.pdf',
      date: DateTime.now(),
      size: 500,
      name: 'john_Resume',
      extension: 'pdf',
    ),
    status: 'Pending',
    createdAt: DateTime.now(),
  ),
];

// JobApplication jobApplication = JobApplication(
//   applicant: Applicant(
//     id: "user_009",
//     firstname: "john",
//     lastname: "doe",
//     username: "johnny22",
//     email: "johnDoe@gmail.com",
//     country: "USA",
//     city: "New York",
//     phoneNumber: "+1234567890",
//   ),
//   job: Job(
//     id: '10',
//     title: "Marketing Specialist",
//     industry: "Marketing",
//     company: Company(name: "AdWorks", size: "200 employees"),
//     description: "Create and implement marketing campaigns.",
//     workplace: "Remote",
//     type: "Contract",
//     experienceLevel: "Entry-Level",
//     salaryRange: SalaryRange(min: 40000, max: 60000),
//     location: Location(city: "New York", country: "USA"),
//     keywords: ["SEO", "Content Marketing", "Social Media"],
//     createdAt: DateTime.now(),
//   ),
//   resume: Resume(
//     id: 'r1',
//     url: 'https://example.com/resume1.pdf',
//     date: DateTime.now(),
//     size: 500,
//     name: 'Alice_Resume',
//     extension: 'pdf',
//   ),
//   status: 'Pending',
//   createdAt: DateTime.now(),
// );

class Applicant {
  String id;
  String firstname;
  String lastname;
  String username;
  String email;
  String country;
  String city;
  String phoneNumber;

  Applicant({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.username,
    required this.email,
    required this.country,
    required this.city,
    required this.phoneNumber,
  });

   Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'username': username,
      'email': email,
      'country': country,
      'city': city,
      'phoneNumber': phoneNumber,
    };
  }

  factory Applicant.fromJson(Map<String, dynamic> json) {
    return Applicant(
      id: json['id'] as String,
      firstname: json['firstname'] as String,
      lastname: json['lastname'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      country: json['country'] as String,
      city: json['city'] as String,
      phoneNumber: json['phoneNumber'] as String,
    );
  }
}

Applicant mockMainApplicant = Applicant(
  id: "user_001",
  firstname: "abdelrahman",
  lastname: "sameh",
  username: "abdelrahman388",
  email: "abdelrahmansameh092@gmail.com",
  country: "USA",
  city: "New York",
  phoneNumber: "+1234567890",
);
