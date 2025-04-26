import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:joblinc/features/jobs/data/models/job_application_model.dart';
import 'package:joblinc/features/jobs/data/models/job_model.dart';
import 'package:joblinc/features/jobs/ui/screens/job_search_screen.dart';

class JobApiService {
  final Dio _dio;

  JobApiService(this._dio);
  final bool apiEndPointWorking = true;

  /// Retrieves certain jobs.
  Future<Response> getCompanyNames() async {
    try {
      final response = await _dio.get('/companies', queryParameters: {
        'fields': ['name']
      });
      print(response);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getJob(int jobId) async {
    try {
      final response = await _dio.get('/job/$jobId');
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Retrieves all available jobs.

  Future<Response> getAllJobs({Map<String, dynamic>? queryParams}) async {
    if (apiEndPointWorking) {
      print("api requesting");
      final response = await _dio.get(
        '/jobs',
        queryParameters: queryParams,
      );
      print(queryParams);
      print(response);
      return response;
    } else {
      // Mock fallback
      await Future.delayed(const Duration(seconds: 1));
      return Response<dynamic>(
        requestOptions: RequestOptions(path: '/jobs'),
        data: jobs.map((j) => j.toJson()).toList(),
        statusCode: 200,
        statusMessage: 'OK',
      );
    }
  }

  /// Retrieves the jobs the user has applied to.
  Future<Response> getAppliedJobs() async {
    if (apiEndPointWorking) {
      try {
        print("api requesting ya abdelrahman ya sameh");
        final response = await _dio.get('/jobs/my-job-applications');
        print(response.data);
        return response;
      } catch (e) {
        rethrow;
      }
    } else {
      await Future.delayed(Duration(milliseconds: 200));
      final response = Response<dynamic>(
        requestOptions: RequestOptions(path: ''),
        data: appliedJobs
            .map((job) => job.toJson())
            .toList(), //mockAppliedJobs.map((job) => job.toJson()).toList(),
        statusCode: 200,
        statusMessage: 'OK',
      );
      return response;
    }
  }

  /// Retrieves the jobs the user has saved.
  Future<Response> getSavedJobs() async {
    if (apiEndPointWorking) {
      try {
        final response = await _dio.get('/job/saved');
        return response;
      } catch (e) {
        rethrow;
      }
    } else {
      await Future.delayed(Duration(milliseconds: 200));
      await Future.delayed(Duration(milliseconds: 200));
      final response = Response<dynamic>(
        requestOptions: RequestOptions(path: ''),
        data: savedJobs.map((job) => job.toJson()).toList(),
        statusCode: 200,
        statusMessage: 'OK',
      );
      return response;
    }
  }

  // Future<Response> getCreatedJobs() async {
  //   if (apiEndPointWorking) {
  //     try {
  //       final response = await _dio.get('/job/created');
  //       return response;
  //     } catch (e) {
  //       rethrow;
  //     }
  //   } else {
  //     final response = Response<dynamic>(
  //       requestOptions: RequestOptions(path: ''),
  //       data: createdJobs.map((job) => job.toJson()).toList(),
  //       statusCode: 200,
  //       statusMessage: 'OK',
  //     );
  //     return response;
  //   }
  // }

  Future<Response> getJobApplicants(String jobId) async {
    if (apiEndPointWorking) {
      try {
        final response = await _dio.get('/jobs/$jobId/job-applications');
        return response;
      } catch (e) {
        rethrow;
      }
    } else {
      await Future.delayed(Duration(milliseconds: 300));
      final response = Response<dynamic>(
        requestOptions: RequestOptions(path: ''),
        data: [], //jobApplicants.map((job) => job.toJson()).toList(),
        statusCode: 200,
        statusMessage: 'OK',
      );
      return response;
    }
  }

  Future<Response> getJobApplicantById(String jobId, String applicantId) async {
    if (apiEndPointWorking) {
      try {
        final response = await _dio.get('/job/$jobId/applicants/$applicantId');
        return response;
      } catch (e) {
        rethrow;
      }
    } else {
      await Future.delayed(Duration(milliseconds: 300));
      // JobApplication jobApplicant = jobApplicants.firstWhere((jobApp) =>
      //     (jobApp.job.id == jobId && jobApp.applicant.id == applicantId));
      final response = Response<dynamic>(
        requestOptions: RequestOptions(path: ''),
        data: [], //jobApplicant.toJson(),
        statusCode: 200,
        statusMessage: 'OK',
      );
      return response;
    }
  }

  Future<Response> getJobApplications() async {
    if (apiEndPointWorking) {
      try {
        final response = await _dio.get('/jobs/my-job-applications');
        return response;
      } catch (e) {
        rethrow;
      }
    } else {
      await Future.delayed(Duration(milliseconds: 300));
      final response = Response<dynamic>(
        requestOptions: RequestOptions(path: ''),
        data: [], //jobApplications
        //.map((job) => job.toJson())
        //.toList(), //mockJobApplications.map((job) => job.toJson()).toList(),
        statusCode: 200,
        statusMessage: 'OK',
      );
      return response;
    }
  }

  /// Retrieves all uploaded resume files from the server.
  Future<Response> getAllResumes() async {
    if (apiEndPointWorking) {
      try {
        final response = await _dio.get('/user/resume');
        return response;
      } catch (e) {
        rethrow;
      }
    } else {
      await Future.delayed(Duration(milliseconds: 300));
      final response = Response<dynamic>(
        requestOptions: RequestOptions(path: ''),
        data: [], //mockResumes.map((job) => job.toJson()).toList(),
        statusCode: 200,
        statusMessage: 'OK',
      );
      return response;
    }
  }

  Future<Response> createJob({required Map<String, dynamic> jobReq}) async {
    if (apiEndPointWorking) {
      try {
        //Map<String, dynamic> jobData = job.toJson();
        print("creating job");
        final response = await _dio.post('/jobs', data: jobReq);
        print(response);
        return response;
      } catch (e) {
        rethrow;
      }
    } else {
      await Future.delayed(Duration(milliseconds: 300));
      //mockCreatedJobs.add(job);
      final response = Response<dynamic>(
        requestOptions: RequestOptions(path: ''),
        data: {'message', 'job created succesfully'},
        statusCode: 200,
        statusMessage: 'OK',
      );
      return response;
    }
  }

  Future<void> saveJob(String jobId) async {
    if (apiEndPointWorking) {
      try {
        await _dio.post('/job/$jobId/save');
      } catch (e) {
        rethrow;
      }
    } else {
      await Future.delayed(Duration(milliseconds: 300));
      savedJobs.add(jobs.firstWhere((job) => job.id == jobId));
    }
  }

  Future<void> unsaveJob(String jobId) async {
    if (apiEndPointWorking) {
      try {
        await _dio.post('/job/$jobId/unsave');
      } catch (e) {
        rethrow;
      }
    } else {
      await Future.delayed(Duration(milliseconds: 500));
      savedJobs.removeWhere((job) => job.id == jobId);
    }
  }

  Future<void> applyJob(
      String jobId, Map<String, dynamic> jobApplication) async {
    if (apiEndPointWorking) {
      try {
        //Map<String, dynamic> applicationData = jobApplication.toJson();
        print("api applying");
        // final response =
            await _dio.post('/jobs/$jobId/apply', data: jobApplication);
        // return response;
      } catch (e) {
        rethrow;
      }
    } else {
      // await Future.delayed(Duration(milliseconds: 500));
      // //appliedJobs.add(jobApplication.job);
      // //jobApplications.add(jobApplication);
      // final response = Response(
      //   requestOptions: RequestOptions(path: ''),
      //   statusCode: 200,
      //   data: {
      //     'message': 'applied to saved locally',
      //   },
      // );
      // print(response);
      // return response;
    }
  }

  Future<void> acceptJobApplication(String jobId, String applicantId) async {
    if (apiEndPointWorking) {
      try {
        await _dio.post('/job/$jobId/applicants/$applicantId/accept');
      } catch (e) {
        rethrow;
      }
    } else {
      // jobApplicants
      //     .firstWhere((jobApp) => jobApp.applicant.id == applicantId)
      //     .status = "Accepted";
      // print(jobApplicants
      //     .firstWhere((jobApp) => jobApp.applicant.id == applicantId)
      //     .status);
    }
  }

  Future<void> rejectJobApplication(String jobId, String applicantId) async {
    if (apiEndPointWorking) {
      try {
        await _dio.post('/job/$jobId/applicants/$applicantId/reject');
      } catch (e) {
        rethrow;
      }
    } else {
      // jobApplicants
      //     .firstWhere((jobApp) => jobApp.applicant.id == applicantId)
      //     .status = "Rejected";
      // print(jobApplicants
      //     .firstWhere((jobApp) => jobApp.applicant.id == applicantId)
      //     .status);
    }
  }

  MediaType getMediaType(File file) {
    final extension = file.path.split('.').last.toLowerCase();

    switch (extension) {
      case 'pdf':
        return MediaType('application', 'pdf');
       case 'doc':
    case 'docx':
      return MediaType('application', 'msword');  // MIME type for Word documents
    default:
      return MediaType('application', 'octet-stream'); // Fallback for unsupported types
    }
  }

  Future<void> uploadResume(File resumeFile) async {
    if (apiEndPointWorking) {
      // final String fileName =
      //     resumeFile.path.split(Platform.pathSeparator).last;
      // FormData formData = FormData.fromMap({
      //   'file':
      //       await MultipartFile.fromFile(resumeFile.path, filename: fileName),
      // });
      // return await _dio.post('/user/resume/upload', data: formData);

      try {
        final fileName = resumeFile.path.split('/').last;
        print(" this is the media type ${getMediaType(resumeFile).toString()}");
        final formData = FormData.fromMap({
          'file': await MultipartFile.fromFile(
            resumeFile.path,
            filename: fileName,
            contentType: getMediaType(resumeFile),
          ),
        });

        await _dio.post('/user/resume/upload', data: formData);
        // return response;
      } catch (e) {
        print('Error uploading resume: $e');
        rethrow;
      }
    } else {
      // final String fileName =
      //     resumeFile.path.split(Platform.pathSeparator).last;
      // // final String fileExtension = fileName.split('.').last;
      // final int fileSize = await resumeFile.length(); // Get file size in bytes
      // final String resumeId =
      //     DateTime.now().millisecondsSinceEpoch.toString(); // Unique ID
      // final DateTime currentDate = DateTime.now();

      // mockResumes.add(Resume(
      //   id: resumeId,
      //   name: fileName,
      //   extension: fileExtension,
      //   url: resumeFile.path, // Storing local file path as 'url'
      //   size: fileSize,
      //   date: currentDate,
      // ));

      // final response = Response(
      //   requestOptions: RequestOptions(path: ''),
      //   statusCode: 200,
      //   data: {
      //     'message': 'Resume saved locally',
          // 'resumeId': resumeId,
          // 'fileName': fileName,
          // 'fileExtension': fileExtension,
          // 'fileSize': fileSize,
          // 'date': currentDate.toIso8601String(),
      //   },
      // );

      // print(response);
      // return response;
    }
  }
}

// List<JobApplication> jobApplications = [
//   JobApplication(
//     applicant: mockMainApplicant,
//     job: Job(
//       id: '1',
//       title: "Senior Software Engineer",
//       industry: "Technology",
//       company: Company(
//         id: 'c1',
//         name: "Innovatech Solutions",
//         tagline: "Innovate the future",
//         industry: "Technology",
//         overview: "A leading provider of innovative tech solutions.",
//         urlSlug: "innovatech-solutions",
//         size: "500+ employees",
//         logo:
//             "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQD3jclFVhqRJqcwDXAx4YTy156le-necmYFA&s",
//         followers: 1200,
//       ),
//       description: "Lead development of scalable software solutions.",
//       workplace: "Hybrid",
//       type: "Full-time",
//       experienceLevel: "Senior-Level",
//       salaryRange: SalaryRange(
//         id: 'sr1',
//         min: 110000,
//         max: 150000,
//         currency: "USD",
//       ),
//       location: Location(
//         id: 'l1',
//         address: "123 Market St",
//         city: "San Francisco",
//         country: "USA",
//       ),
//       keywords: ["Java", "Kotlin", "Cloud"],
//       skills: ["Java", "Kotlin", "Cloud"],
//       accepting: true,
//       createdAt: DateTime(2025, 03, 01),
//     ),
//     resume: Resume(
//       id: 'r1',
//       url: 'https://example.com/resume1.pdf',
//       date: DateTime.now(),
//       size: 500,
//       name: 'jane_Resume',
//       extension: 'pdf',
//     ),
//     status: 'Pending',
//     createdAt: DateTime.now(),
//   ),
// ];

// ////////////////////////////////////////////////////////////////////////////////////////////

// List<JobApplication> jobApplicants = [
//   JobApplication(
//     applicant: Applicant(
//       id: "user_010",
//       firstname: "jane",
//       lastname: "doe",
//       username: "jenny22",
//       email: "janeDoe@gmail.com",
//       country: "USA",
//       city: "New York",
//       phoneNumber: "+3214567890",
//     ),
//     job: Job(
//       id: '2',
//       title: "Digital Marketing Specialist",
//       industry: "Marketing",
//       company: Company(
//         id: 'c2',
//         name: "CreativeAds",
//         tagline: "Creativity Meets Strategy",
//         industry: "Marketing",
//         overview: "Experts in creative digital marketing.",
//         urlSlug: "creativeads",
//         size: "150 employees",
//         logo:
//             "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQD3jclFVhqRJqcwDXAx4YTy156le-necmYFA&s",
//         followers: 800,
//       ),
//       description: "Develop and manage digital marketing campaigns.",
//       workplace: "Remote",
//       type: "Contract",
//       experienceLevel: "Mid-Level",
//       salaryRange: SalaryRange(
//         id: 'sr2',
//         min: 55000,
//         max: 75000,
//         currency: "USD",
//       ),
//       location: Location(
//         id: 'l2',
//         address: "456 Madison Ave",
//         city: "New York",
//         country: "USA",
//       ),
//       keywords: ["SEO", "Social Media", "Analytics"],
//       skills: ["SEO", "Social Media", "Analytics"],
//       accepting: true,
//       createdAt: DateTime(2025, 02, 15),
//     ),
//     resume: Resume(
//       id: 'r1',
//       url: 'https://example.com/resume1.pdf',
//       date: DateTime.now(),
//       size: 500,
//       name: 'jane_Resume',
//       extension: 'pdf',
//     ),
//     status: 'Pending',
//     createdAt: DateTime.now(),
//   ),
//   JobApplication(
//     applicant: Applicant(
//       id: "user_009",
//       firstname: "john",
//       lastname: "doe",
//       username: "johnny22",
//       email: "johnDoe@gmail.com",
//       country: "USA",
//       city: "New York",
//       phoneNumber: "+1234567890",
//     ),
//     job: Job(
//       id: '2',
//       title: "Digital Marketing Specialist",
//       industry: "Marketing",
//       company: Company(
//         id: 'c2',
//         name: "CreativeAds",
//         tagline: "Creativity Meets Strategy",
//         industry: "Marketing",
//         overview: "Experts in creative digital marketing.",
//         urlSlug: "creativeads",
//         size: "150 employees",
//         logo:
//             "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQD3jclFVhqRJqcwDXAx4YTy156le-necmYFA&s",
//         followers: 800,
//       ),
//       description: "Develop and manage digital marketing campaigns.",
//       workplace: "Remote",
//       type: "Contract",
//       experienceLevel: "Mid-Level",
//       salaryRange: SalaryRange(
//         id: 'sr2',
//         min: 55000,
//         max: 75000,
//         currency: "USD",
//       ),
//       location: Location(
//         id: 'l2',
//         address: "456 Madison Ave",
//         city: "New York",
//         country: "USA",
//       ),
//       keywords: ["SEO", "Social Media", "Analytics"],
//       skills: ["SEO", "Social Media", "Analytics"],
//       accepting: true,
//       createdAt: DateTime(2025, 02, 15),
//     ),
//     resume: Resume(
//       id: 'r1',
//       url: 'https://example.com/resume1.pdf',
//       date: DateTime.now(),
//       size: 500,
//       name: 'john_Resume',
//       extension: 'pdf',
//     ),
//     status: 'Pending',
//     createdAt: DateTime.now(),
//   ),
// ];
/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////
final createdJobs = [
  Job(
    id: '2',
    title: "Digital Marketing Specialist",
    industry: "Marketing",
    company: Company(
      id: 'c2',
      name: "CreativeAds",
      tagline: "Creativity Meets Strategy",
      industry: "Marketing",
      overview: "Experts in creative digital marketing.",
      urlSlug: "creativeads",
      size: "150 employees",
      logo:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQD3jclFVhqRJqcwDXAx4YTy156le-necmYFA&s",
      followers: 800,
    ),
    description: "Develop and manage digital marketing campaigns.",
    workplace: "Remote",
    type: "Contract",
    experienceLevel: "Mid-Level",
    salaryRange: SalaryRange(
      id: 'sr2',
      min: 55000,
      max: 75000,
      currency: "USD",
    ),
    location: Location(
      id: 'l2',
      address: "456 Madison Ave",
      city: "New York",
      country: "USA",
    ),
    keywords: ["SEO", "Social Media", "Analytics"],
    skills: ["SEO", "Social Media", "Analytics"],
    accepting: true,
    createdAt: DateTime(2025, 02, 15),
  ),
];

///////////////////////////////////////////////////////////////////////////////////////////

final appliedJobs = [
  Job(
    id: '1',
    title: "Senior Software Engineer",
    industry: "Technology",
    company: Company(
      id: 'c1',
      name: "Innovatech Solutions",
      tagline: "Innovate the future",
      industry: "Technology",
      overview: "A leading provider of innovative tech solutions.",
      urlSlug: "innovatech-solutions",
      size: "500+ employees",
      logo:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQD3jclFVhqRJqcwDXAx4YTy156le-necmYFA&s",
      followers: 1200,
    ),
    description: "Lead development of scalable software solutions.",
    workplace: "Hybrid",
    type: "Full-time",
    experienceLevel: "Senior-Level",
    salaryRange: SalaryRange(
      id: 'sr1',
      min: 110000,
      max: 150000,
      currency: "USD",
    ),
    location: Location(
      id: 'l1',
      address: "123 Market St",
      city: "San Francisco",
      country: "USA",
    ),
    keywords: ["Java", "Kotlin", "Cloud"],
    skills: ["Java", "Kotlin", "Cloud"],
    accepting: true,
    createdAt: DateTime(2025, 03, 01),
  ),
];

////////////////////////////////////////////////////////////////////////////////////////

final savedJobs = [
  Job(
    id: '1',
    title: "Senior Software Engineer",
    industry: "Technology",
    company: Company(
      id: 'c1',
      name: "Innovatech Solutions",
      tagline: "Innovate the future",
      industry: "Technology",
      overview: "A leading provider of innovative tech solutions.",
      urlSlug: "innovatech-solutions",
      size: "500+ employees",
      logo:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQD3jclFVhqRJqcwDXAx4YTy156le-necmYFA&s",
      followers: 1200,
    ),
    description: "Lead development of scalable software solutions.",
    workplace: "Hybrid",
    type: "Full-time",
    experienceLevel: "Senior-Level",
    salaryRange: SalaryRange(
      id: 'sr1',
      min: 110000,
      max: 150000,
      currency: "USD",
    ),
    location: Location(
      id: 'l1',
      address: "123 Market St",
      city: "San Francisco",
      country: "USA",
    ),
    keywords: ["Java", "Kotlin", "Cloud"],
    skills: ["Java", "Kotlin", "Cloud"],
    accepting: true,
    createdAt: DateTime(2025, 03, 01),
  ),
];

final jobs = [
  Job(
    id: '1',
    title: "Senior Software Engineer",
    industry: "Technology",
    company: Company(
      id: 'c1',
      name: "Innovatech Solutions",
      tagline: "Innovate the future",
      industry: "Technology",
      overview: "A leading provider of innovative tech solutions.",
      urlSlug: "innovatech-solutions",
      size: "500+ employees",
      logo:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQD3jclFVhqRJqcwDXAx4YTy156le-necmYFA&s",
      followers: 1200,
    ),
    description: "Lead development of scalable software solutions.",
    workplace: "Hybrid",
    type: "Full-time",
    experienceLevel: "Senior-Level",
    salaryRange: SalaryRange(
      id: 'sr1',
      min: 110000,
      max: 150000,
      currency: "USD",
    ),
    location: Location(
      id: 'l1',
      address: "123 Market St",
      city: "San Francisco",
      country: "USA",
    ),
    keywords: ["Java", "Kotlin", "Cloud"],
    skills: ["Java", "Kotlin", "Cloud"],
    accepting: true,
    createdAt: DateTime(2025, 03, 01),
  ),
  Job(
    id: '2',
    title: "Digital Marketing Specialist",
    industry: "Marketing",
    company: Company(
      id: 'c2',
      name: "CreativeAds",
      tagline: "Creativity Meets Strategy",
      industry: "Marketing",
      overview: "Experts in creative digital marketing.",
      urlSlug: "creativeads",
      size: "150 employees",
      logo:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQD3jclFVhqRJqcwDXAx4YTy156le-necmYFA&s",
      followers: 800,
    ),
    description: "Develop and manage digital marketing campaigns.",
    workplace: "Remote",
    type: "Contract",
    experienceLevel: "Mid-Level",
    salaryRange: SalaryRange(
      id: 'sr2',
      min: 55000,
      max: 75000,
      currency: "USD",
    ),
    location: Location(
      id: 'l2',
      address: "456 Madison Ave",
      city: "New York",
      country: "USA",
    ),
    keywords: ["SEO", "Social Media", "Analytics"],
    skills: ["SEO", "Social Media", "Analytics"],
    accepting: true,
    createdAt: DateTime(2025, 02, 15),
  ),
  Job(
    id: '3',
    title: "Product Manager",
    industry: "Management",
    company: Company(
      id: 'c3',
      name: "Global Ventures",
      tagline: "Going Global",
      industry: "Management",
      overview: "Managing global ventures and business strategies.",
      urlSlug: "global-ventures",
      size: "1000+ employees",
      logo:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQD3jclFVhqRJqcwDXAx4YTy156le-necmYFA&s",
      followers: 3000,
    ),
    description: "Oversee product lifecycle and strategy.",
    workplace: "On-site",
    type: "Full-time",
    experienceLevel: "Director-Level",
    salaryRange: SalaryRange(
      id: 'sr3',
      min: 130000,
      max: 190000,
      currency: "USD",
    ),
    location: Location(
      id: 'l3',
      address: "789 Lakeside Dr",
      city: "Chicago",
      country: "USA",
    ),
    keywords: ["Strategy", "Leadership", "Operations"],
    skills: ["Strategy", "Leadership", "Operations"],
    accepting: true,
    createdAt: DateTime(2025, 03, 05),
  ),
  Job(
    id: '4',
    title: "Junior Frontend Developer",
    industry: "Technology",
    company: Company(
      id: 'c4',
      name: "WebWorks",
      tagline: "We build the web",
      industry: "Technology",
      overview: "Web development agency specializing in frontend work.",
      urlSlug: "webworks",
      size: "50 employees",
      logo:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQD3jclFVhqRJqcwDXAx4YTy156le-necmYFA&s",
      followers: 400,
    ),
    description: "Build responsive web interfaces with React.",
    workplace: "On-site",
    type: "Full-time",
    experienceLevel: "Entry-Level",
    salaryRange: SalaryRange(
      id: 'sr4',
      min: 45000,
      max: 60000,
      currency: "USD",
    ),
    location: Location(
      id: 'l4',
      address: "321 Tech Blvd",
      city: "Austin",
      country: "USA",
    ),
    keywords: ["JavaScript", "React", "CSS"],
    skills: ["JavaScript", "React", "CSS"],
    accepting: true,
    createdAt: DateTime(2025, 03, 10),
  ),
  Job(
    id: '5',
    title: "Data Analyst",
    industry: "Analytics",
    company: Company(
      id: 'c5',
      name: "DataCorp",
      tagline: "Data drives decisions",
      industry: "Analytics",
      overview: "Data analytics firm helping businesses thrive.",
      urlSlug: "datacorp",
      size: "300 employees",
      logo:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQD3jclFVhqRJqcwDXAx4YTy156le-necmYFA&s",
      followers: 950,
    ),
    description: "Analyze datasets and produce actionable insights.",
    workplace: "Remote",
    type: "Full-time",
    experienceLevel: "Mid-Level",
    salaryRange: SalaryRange(
      id: 'sr5',
      min: 60000,
      max: 80000,
      currency: "USD",
    ),
    location: Location(
      id: 'l5',
      address: "654 Beacon St",
      city: "Boston",
      country: "USA",
    ),
    keywords: ["SQL", "Python", "Tableau"],
    skills: ["SQL", "Python", "Tableau"],
    accepting: true,
    createdAt: DateTime(2025, 02, 28),
  ),
];
 // Future<Response> getAllJobs() async {
  //   if (apiEndPointWorking) {
  //     try {
  //       final response = await _dio.get('/job/all');
  //       return response;
  //     } catch (e) {
  //       rethrow;
  //     }
  //   } else {
  //     await Future.delayed(Duration(seconds: 1));
  //     final response = Response<dynamic>(
  //       requestOptions: RequestOptions(path: ''),
  //       data:[] ,//mockJobs.map((job) => job.toJson()).toList(),
  //       statusCode: 200,
  //       statusMessage: 'OK',
  //     );
  //     return response;
  //   }
  // }
// Future<Response> getSearchedFilteredJobs(
  //     String keyword, String? location, Filter? filter) async {
  //   if (apiEndPointWorking) {
  //     try {
  //       final response = await _dio.get('/job/search', data: {
  //         'keyword': keyword,
  //         'location': location,
  //         'filter': filter!.toJson()
  //       });
  //       return response;
  //     } catch (e) {
  //       rethrow;
  //     }
  //  } else {
  //   await Future.delayed(Duration(milliseconds: 300));

  //   if (keyword.isEmpty || keyword == "") {
  //     List<Job> emptyJobs = [];
  //     final response = Response<dynamic>(
  //       requestOptions: RequestOptions(path: ''),
  //       data: emptyJobs.map((job) => job.toJson()).toList(),
  //       statusCode: 200,
  //       statusMessage: 'OK',
  //     );
  //     return response;
  //   }

  //   // Convert keyword to lowercase for case-insensitive matching.
  //   final lowerKeyword = keyword.toLowerCase();
  //   // Only convert location to lowercase if it's not null.
  //   final lowerLocation = (location ?? "").toLowerCase();

  //   final searchedJobs = mockDBJobs.where((job) {
  //     bool keywordMatches = false;
  //     bool locationMatches = false;

  //     // Check if any of the text fields contain the keyword.
  //     if (job.title != null &&
  //         job.title!.toLowerCase().contains(lowerKeyword)) {
  //       keywordMatches = true;
  //     } else if (job.industry != null &&
  //         job.industry!.toLowerCase().contains(lowerKeyword)) {
  //       keywordMatches = true;
  //     } else if (job.company != null &&
  //         job.company!.name != null &&
  //         job.company!.name!.toLowerCase().contains(lowerKeyword)) {
  //       keywordMatches = true;
  //     } else if (job.keywords != null &&
  //         job.keywords!
  //             .any((kw) => kw.toLowerCase().contains(lowerKeyword))) {
  //       keywordMatches = true;
  //     }

  //     // If location is null or empty, consider it as a match.
  //     if (location == null || location.isEmpty) {
  //       locationMatches = true;
  //     } else if (job.location != null) {
  //       if (job.location!.city != null &&
  //           job.location!.city!.toLowerCase().contains(lowerLocation)) {
  //         locationMatches = true;
  //       } else if (job.location!.country != null &&
  //           job.location!.country!.toLowerCase().contains(lowerLocation)) {
  //         locationMatches = true;
  //       }
  //     }

  //     // If keyword is empty, we match all jobs for that filter.
  //     bool keywordCondition = keyword.isEmpty ? true : keywordMatches;
  //     // Use the computed locationMatches value.
  //     bool locationCondition = locationMatches;

  //     return keywordCondition && locationCondition;
  //   }).toList();

  //   List<Job> filteredJobs = searchedJobs;

  //   if (filter != null) {
  //     // Experience filter: if filter.experienceFilter is non-empty,
  //     // only keep jobs whose experienceLevel matches one of the filters.
  //     if (filter.experienceFilter != null &&
  //         filter.experienceFilter!.isNotEmpty) {
  //       filteredJobs = filteredJobs.where((job) {
  //         return job.experienceLevel != null &&
  //             filter.experienceFilter!.any((exp) => job.experienceLevel!
  //                 .toLowerCase()
  //                 .contains(exp.toLowerCase()));
  //       }).toList();
  //     }

  //     // Company filter: if filter.companyFilter is non-empty,
  //     // only keep jobs whose company name matches one of the filters.
  //     if (filter.companyFilter != null && filter.companyFilter!.isNotEmpty) {
  //       filteredJobs = filteredJobs.where((job) {
  //         return job.company != null &&
  //             job.company!.name != null &&
  //             filter.companyFilter!.any((comp) => job.company!.name!
  //                 .toLowerCase()
  //                 .contains(comp.toLowerCase()));
  //       }).toList();
  //     }

  //     // Salary range filter: if minSalary is set, job.salaryRange.min should be >= filter.minSalary.
  //     if (filter.minSalary != null && filter.minSalary! > 0) {
  //       filteredJobs = filteredJobs.where((job) {
  //         return job.salaryRange != null &&
  //             job.salaryRange!.min != null &&
  //             job.salaryRange!.min! >= filter.minSalary!;
  //       }).toList();
  //     }
  //     // Similarly, if maxSalary is set, job.salaryRange.max should be <= filter.maxSalary.
  //     if (filter.maxSalary != null && filter.maxSalary! > 0) {
  //       filteredJobs = filteredJobs.where((job) {
  //         return job.salaryRange != null &&
  //             job.salaryRange!.max != null &&
  //             job.salaryRange!.max! <= filter.maxSalary!;
  //       }).toList();
  //     }
  //   }

  //     final response = Response<dynamic>(
  //       requestOptions: RequestOptions(path: ''),
  //       data: [],//filteredJobs.map((job) => job.toJson()).toList(),
  //       statusCode: 200,
  //       statusMessage: 'OK',
  //     );

  //      return response;
  //   }
  // }
// List<Job> mockDBJobs = [
  // Job(
  //   id: '1',
  //   title: "Senior Software Engineer",
  //   industry: "Technology",
  //   company: Company(name: "Innovatech Solutions", size: "500+ employees"),
  //   description: "Lead development of scalable software solutions.",
  //   workplace: "Hybrid",
  //   type: "Full-time",
  //   experienceLevel: "Senior-Level",
  //   salaryRange: SalaryRange(min: 110000, max: 150000),
  //   location: Location(city: "San Francisco", country: "USA"),
  //   keywords: ["Java", "Kotlin", "Cloud"],
  //   createdAt: DateTime(2025, 03, 01),
  // ),
  // Job(
  //   id: '2',
  //   title: "Digital Marketing Specialist",
  //   industry: "Marketing",
  //   company: Company(name: "CreativeAds", size: "150 employees"),
  //   description: "Develop and manage digital marketing campaigns.",
  //   workplace: "Remote",
  //   type: "Contract",
  //   experienceLevel: "Mid-Level",
  //   salaryRange: SalaryRange(min: 55000, max: 75000),
  //   location: Location(city: "New York", country: "USA"),
  //   keywords: ["SEO", "Social Media", "Analytics"],
  //   createdAt: DateTime(2025, 02, 15),
  // ),
  // Job(
  //   id: '3',
  //   title: "Product Manager",
  //   industry: "Management",
  //   company: Company(name: "Global Ventures", size: "1000+ employees"),
  //   description: "Oversee product lifecycle and strategy.",
  //   workplace: "On-site",
  //   type: "Full-time",
  //   experienceLevel: "Director-Level",
  //   salaryRange: SalaryRange(min: 130000, max: 190000),
  //   location: Location(city: "Chicago", country: "USA"),
  //   keywords: ["Strategy", "Leadership", "Operations"],
  //   createdAt: DateTime(2025, 03, 05),
  // ),
  // Job(
  //   id: '4',
  //   title: "Junior Frontend Developer",
  //   industry: "Technology",
  //   company: Company(name: "WebWorks", size: "50 employees"),
  //   description: "Build responsive web interfaces with React.",
  //   workplace: "On-site",
  //   type: "Full-time",
  //   experienceLevel: "Entry-Level",
  //   salaryRange: SalaryRange(min: 45000, max: 60000),
  //   location: Location(city: "Austin", country: "USA"),
  //   keywords: ["JavaScript", "React", "CSS"],
  //   createdAt: DateTime(2025, 03, 10),
  // ),
  // Job(
  //   id: '5',
  //   title: "Data Analyst",
  //   industry: "Analytics",
  //   company: Company(name: "DataCorp", size: "300 employees"),
  //   description: "Analyze datasets and produce actionable insights.",
  //   workplace: "Remote",
  //   type: "Full-time",
  //   experienceLevel: "Mid-Level",
  //   salaryRange: SalaryRange(min: 60000, max: 80000),
  //   location: Location(city: "Boston", country: "USA"),
  //   keywords: ["SQL", "Python", "Tableau"],
  //   createdAt: DateTime(2025, 02, 28),
  // ),
//   Job(
//     id: '6',
//     title: "UX/UI Designer",
//     industry: "Design",
//     company: Company(name: "DesignPro", size: "120 employees"),
//     description: "Design intuitive user interfaces for mobile and web apps.",
//     workplace: "Hybrid",
//     type: "Full-time",
//     experienceLevel: "Mid-Level",
//     salaryRange: SalaryRange(min: 65000, max: 85000),
//     location: Location(city: "Los Angeles", country: "USA"),
//     keywords: ["Figma", "Sketch", "Adobe XD"],
//     createdAt: DateTime(2025, 03, 12),
//   ),
//   Job(
//     id: '7',
//     title: "Business Analyst",
//     industry: "Business",
//     company: Company(name: "BizInsights", size: "400 employees"),
//     description: "Collaborate with stakeholders to improve business processes.",
//     workplace: "On-site",
//     type: "Full-time",
//     experienceLevel: "Mid-Level",
//     salaryRange: SalaryRange(min: 70000, max: 90000),
//     location: Location(city: "Seattle", country: "USA"),
//     keywords: ["Analysis", "Requirements", "Documentation"],
//     createdAt: DateTime(2025, 03, 03),
//   ),
//   Job(
//     id: '8',
//     title: "Mobile App Developer",
//     industry: "Technology",
//     company: Company(name: "Appify", size: "250 employees"),
//     description: "Develop cross-platform mobile applications.",
//     workplace: "Remote",
//     type: "Contract",
//     experienceLevel: "Mid-Level",
//     salaryRange: SalaryRange(min: 75000, max: 95000),
//     location: Location(city: "Denver", country: "USA"),
//     keywords: ["Flutter", "Dart", "iOS", "Android"],
//     createdAt: DateTime(2025, 03, 08),
//   ),
//   Job(
//     id: '9',
//     title: "HR Manager",
//     industry: "Human Resources",
//     company: Company(name: "PeopleFirst", size: "350 employees"),
//     description: "Manage recruitment and employee relations.",
//     workplace: "On-site",
//     type: "Full-time",
//     experienceLevel: "Senior-Level",
//     salaryRange: SalaryRange(min: 80000, max: 110000),
//     location: Location(city: "Atlanta", country: "USA"),
//     keywords: ["Recruitment", "Employee Relations", "Training"],
//     createdAt: DateTime(2025, 03, 06),
//   ),
//   Job(
//     id: '10',
//     title: "Financial Analyst",
//     industry: "Finance",
//     company: Company(name: "MoneyMatters", size: "600 employees"),
//     description: "Evaluate financial data and forecast trends.",
//     workplace: "Hybrid",
//     type: "Full-time",
//     experienceLevel: "Mid-Level",
//     salaryRange: SalaryRange(min: 85000, max: 105000),
//     location: Location(city: "Dallas", country: "USA"),
//     keywords: ["Excel", "Financial Modeling", "Analysis"],
//     createdAt: DateTime(2025, 03, 11),
//   ),
//   Job(
//     id: '11',
//     title: "UX Researcher",
//     industry: "Design",
//     company: Company(name: "Creative Minds", size: "80 employees"),
//     description: "Conduct user research and usability testing.",
//     workplace: "Remote",
//     type: "Full-time",
//     experienceLevel: "Entry-Level",
//     salaryRange: SalaryRange(min: 50000, max: 70000),
//     location: Location(city: "Portland", country: "USA"),
//     keywords: ["Research", "Usability", "Testing"],
//     createdAt: DateTime(2025, 03, 15),
//   ),
//   Job(
//     id: '12',
//     title: "DevOps Engineer",
//     industry: "Technology",
//     company: Company(name: "CloudOps", size: "300 employees"),
//     description:
//         "Implement and manage CI/CD pipelines and cloud infrastructure.",
//     workplace: "Hybrid",
//     type: "Full-time",
//     experienceLevel: "Mid-Level",
//     salaryRange: SalaryRange(min: 90000, max: 120000),
//     location: Location(city: "Seattle", country: "USA"),
//     keywords: ["AWS", "Docker", "Kubernetes"],
//     createdAt: DateTime(2025, 03, 16),
//   ),
//   Job(
//     id: '13',
//     title: "Data Scientist",
//     industry: "Analytics",
//     company: Company(name: "Insight Analytics", size: "400 employees"),
//     description: "Develop predictive models and machine learning algorithms.",
//     workplace: "Remote",
//     type: "Full-time",
//     experienceLevel: "Senior-Level",
//     salaryRange: SalaryRange(min: 110000, max: 140000),
//     location: Location(city: "Boston", country: "USA"),
//     keywords: ["Python", "Machine Learning", "Statistics"],
//     createdAt: DateTime(2025, 03, 17),
//   ),
//   Job(
//     id: '14',
//     title: "Graphic Designer",
//     industry: "Design",
//     company: Company(name: "PixelPerfect", size: "60 employees"),
//     description: "Create visual content for digital and print media.",
//     workplace: "On-site",
//     type: "Full-time",
//     experienceLevel: "Entry-Level",
//     salaryRange: SalaryRange(min: 40000, max: 55000),
//     location: Location(city: "Los Angeles", country: "USA"),
//     keywords: ["Photoshop", "Illustrator", "Branding"],
//     createdAt: DateTime(2025, 03, 18),
//   ),
//   Job(
//     id: '15',
//     title: "Backend Developer",
//     industry: "Technology",
//     company: Company(name: "SecureSoft", size: "250 employees"),
//     description: "Build and maintain RESTful APIs.",
//     workplace: "Hybrid",
//     type: "Full-time",
//     experienceLevel: "Mid-Level",
//     salaryRange: SalaryRange(min: 80000, max: 100000),
//     location: Location(city: "Austin", country: "USA"),
//     keywords: ["Node.js", "Express", "MongoDB"],
//     createdAt: DateTime(2025, 03, 19),
//   ),
//   Job(
//     id: '16',
//     title: "Front End Developer",
//     industry: "Technology",
//     company: Company(name: "WebWizards", size: "180 employees"),
//     description: "Develop engaging web interfaces using Angular.",
//     workplace: "Remote",
//     type: "Full-time",
//     experienceLevel: "Mid-Level",
//     salaryRange: SalaryRange(min: 70000, max: 90000),
//     location: Location(city: "Denver", country: "USA"),
//     keywords: ["Angular", "TypeScript", "HTML", "CSS"],
//     createdAt: DateTime(2025, 03, 20),
//   ),
//   Job(
//     id: '17',
//     title: "Quality Assurance Engineer",
//     industry: "Technology",
//     company: Company(name: "TestRight", size: "120 employees"),
//     description: "Develop automated test scripts and conduct manual testing.",
//     workplace: "On-site",
//     type: "Full-time",
//     experienceLevel: "Entry-Level",
//     salaryRange: SalaryRange(min: 50000, max: 70000),
//     location: Location(city: "Chicago", country: "USA"),
//     keywords: ["Selenium", "Automation", "Manual Testing"],
//     createdAt: DateTime(2025, 03, 21),
//   ),
//   Job(
//     id: '18',
//     title: "Content Strategist",
//     industry: "Marketing",
//     company: Company(name: "BrandBoost", size: "90 employees"),
//     description: "Plan and develop content strategies for brand growth.",
//     workplace: "Remote",
//     type: "Contract",
//     experienceLevel: "Mid-Level",
//     salaryRange: SalaryRange(min: 60000, max: 80000),
//     location: Location(city: "New York", country: "USA"),
//     keywords: ["Content", "SEO", "Social Media"],
//     createdAt: DateTime(2025, 03, 22),
//   ),
//   Job(
//     id: '19',
//     title: "Mobile Game Developer",
//     industry: "Entertainment",
//     company: Company(name: "FunGames Studio", size: "300 employees"),
//     description: "Design and develop engaging mobile games.",
//     workplace: "On-site",
//     type: "Full-time",
//     experienceLevel: "Mid-Level",
//     salaryRange: SalaryRange(min: 75000, max: 95000),
//     location: Location(city: "San Diego", country: "USA"),
//     keywords: ["Unity", "C#", "Game Design"],
//     createdAt: DateTime(2025, 03, 23),
//   ),
//   Job(
//     id: '20',
//     title: "Operations Manager",
//     industry: "Business",
//     company: Company(name: "Optima Ops", size: "500 employees"),
//     description: "Manage day-to-day operations and improve efficiency.",
//     workplace: "Hybrid",
//     type: "Full-time",
//     experienceLevel: "Senior-Level",
//     salaryRange: SalaryRange(min: 95000, max: 120000),
//     location: Location(city: "Philadelphia", country: "USA"),
//     keywords: ["Operations", "Management", "Efficiency"],
//     createdAt: DateTime(2025, 03, 24),
//   ),
//   Job(
//     id: '21',
//     title: "Customer Support Specialist",
//     industry: "Customer Service",
//     company: Company(name: "ServiceNow", size: "400 employees"),
//     description: "Provide customer support via chat and email.",
//     workplace: "Remote",
//     type: "Full-time",
//     experienceLevel: "Entry-Level",
//     salaryRange: SalaryRange(min: 35000, max: 50000),
//     location: Location(city: "Phoenix", country: "USA"),
//     keywords: ["Support", "Communication", "CRM"],
//     createdAt: DateTime(2025, 03, 25),
//   ),
//   Job(
//     id: '22',
//     title: "Project Coordinator",
//     industry: "Management",
//     company: Company(name: "PlanIt", size: "150 employees"),
//     description: "Assist in project planning and coordination.",
//     workplace: "On-site",
//     type: "Full-time",
//     experienceLevel: "Entry-Level",
//     salaryRange: SalaryRange(min: 45000, max: 60000),
//     location: Location(city: "Miami", country: "USA"),
//     keywords: ["Coordination", "Communication", "Scheduling"],
//     createdAt: DateTime(2025, 03, 26),
//   ),
//   Job(
//     id: '23',
//     title: "Digital Content Creator",
//     industry: "Media",
//     company: Company(name: "Streamline Media", size: "220 employees"),
//     description: "Produce and edit digital content for social platforms.",
//     workplace: "Remote",
//     type: "Contract",
//     experienceLevel: "Mid-Level",
//     salaryRange: SalaryRange(min: 55000, max: 75000),
//     location: Location(city: "Los Angeles", country: "USA"),
//     keywords: ["Video Editing", "Photography", "Social Media"],
//     createdAt: DateTime(2025, 03, 27),
//   ),
//   Job(
//     id: '24',
//     title: "IT Support Technician",
//     industry: "Technology",
//     company: Company(name: "NetHelp", size: "300 employees"),
//     description: "Provide technical support and troubleshooting.",
//     workplace: "On-site",
//     type: "Full-time",
//     experienceLevel: "Entry-Level",
//     salaryRange: SalaryRange(min: 40000, max: 55000),
//     location: Location(city: "San Jose", country: "USA"),
//     keywords: ["Technical Support", "Troubleshooting", "Networking"],
//     createdAt: DateTime(2025, 03, 28),
//   ),
//   Job(
//     id: '25',
//     title: "Business Development Manager",
//     industry: "Business",
//     company: Company(name: "GrowthEdge", size: "350 employees"),
//     description: "Identify new business opportunities and partnerships.",
//     workplace: "Hybrid",
//     type: "Full-time",
//     experienceLevel: "Senior-Level",
//     salaryRange: SalaryRange(min: 100000, max: 130000),
//     location: Location(city: "Dallas", country: "USA"),
//     keywords: ["Sales", "Partnerships", "Strategy"],
//     createdAt: DateTime(2025, 03, 29),
//   ),
//   Job(
//     id: '26',
//     title: "Content Writer",
//     industry: "Media",
//     company: Company(name: "WriteNow", size: "80 employees"),
//     description: "Write engaging content for blogs and websites.",
//     workplace: "Remote",
//     type: "Part-time",
//     experienceLevel: "Entry-Level",
//     salaryRange: SalaryRange(min: 30000, max: 45000),
//     location: Location(city: "Seattle", country: "USA"),
//     keywords: ["Writing", "Editing", "Blogging"],
//     createdAt: DateTime(2025, 03, 30),
//   ),
//   Job(
//     id: '27',
//     title: "Cybersecurity Analyst",
//     industry: "Technology",
//     company: Company(name: "SecureNet", size: "500+ employees"),
//     description: "Monitor and analyze security systems for potential threats.",
//     workplace: "Hybrid",
//     type: "Full-time",
//     experienceLevel: "Mid-Level",
//     salaryRange: SalaryRange(min: 95000, max: 120000),
//     location: Location(city: "Washington", country: "USA"),
//     keywords: ["Cybersecurity", "Threat Analysis", "Risk Management"],
//     createdAt: DateTime(2025, 04, 01),
//   ),
//   Job(
//     id: '28',
//     title: "E-commerce Manager",
//     industry: "Retail",
//     company: Company(name: "ShopSphere", size: "600 employees"),
//     description: "Oversee online sales and manage digital storefronts.",
//     workplace: "Remote",
//     type: "Full-time",
//     experienceLevel: "Mid-Level",
//     salaryRange: SalaryRange(min: 85000, max: 110000),
//     location: Location(city: "Chicago", country: "USA"),
//     keywords: ["E-commerce", "Digital Marketing", "Analytics"],
//     createdAt: DateTime(2025, 04, 02),
//   ),
//   Job(
//     id: '29',
//     title: "Machine Learning Engineer",
//     industry: "Technology",
//     company: Company(name: "AIMinds", size: "200 employees"),
//     description: "Develop machine learning models for predictive analytics.",
//     workplace: "Hybrid",
//     type: "Full-time",
//     experienceLevel: "Senior-Level",
//     salaryRange: SalaryRange(min: 120000, max: 160000),
//     location: Location(city: "San Francisco", country: "USA"),
//     keywords: ["Machine Learning", "Python", "TensorFlow"],
//     createdAt: DateTime(2025, 04, 03),
//   ),
//   Job(
//     id: '30',
//     title: "Operations Analyst",
//     industry: "Business",
//     company: Company(name: "OpsInsight", size: "150 employees"),
//     description: "Analyze operational processes and recommend improvements.",
//     workplace: "On-site",
//     type: "Full-time",
//     experienceLevel: "Entry-Level",
//     salaryRange: SalaryRange(min: 50000, max: 65000),
//     location: Location(city: "Austin", country: "USA"),
//     keywords: ["Operations", "Analytics", "Process Improvement"],
//     createdAt: DateTime(2025, 04, 04),
//   ),
//   Job(
//     id: '31',
//     title: "Software Developer",
//     industry: "Technology",
//     company: Company(name: "GlobalTech", size: "300 employees"),
//     description: "Develop innovative solutions for our clients.",
//     workplace: "Remote",
//     type: "Full-time",
//     experienceLevel: "Mid-Level",
//     salaryRange: SalaryRange(min: 50000, max: 80000),
//     location: Location(city: "Toronto", country: "Canada"),
//     keywords: ["Java", "Spring", "AWS"],
//     createdAt: DateTime.now(),
//   ),
//   Job(
//     id: '32',
//     title: "Data Analyst",
//     industry: "Finance",
//     company: Company(name: "FinAnalytics", size: "150 employees"),
//     description: "Analyze financial data and provide insights.",
//     workplace: "Onsite",
//     type: "Full-time",
//     experienceLevel: "Entry-Level",
//     salaryRange: SalaryRange(min: 45000, max: 65000),
//     location: Location(city: "London", country: "UK"),
//     keywords: ["SQL", "Python", "Data Visualization"],
//     createdAt: DateTime.now(),
//   ),
//   Job(
//     id: '33',
//     title: "Project Manager",
//     industry: "Construction",
//     company: Company(name: "BuildRight", size: "400 employees"),
//     description: "Manage construction projects from start to finish.",
//     workplace: "Onsite",
//     type: "Full-time",
//     experienceLevel: "Senior-Level",
//     salaryRange: SalaryRange(min: 70000, max: 100000),
//     location: Location(city: "Berlin", country: "Germany"),
//     keywords: ["Management", "Planning", "Leadership"],
//     createdAt: DateTime.now(),
//   ),
//   Job(
//     id: '34',
//     title: "Digital Marketing Manager",
//     industry: "Marketing",
//     company: Company(name: "CreativeEdge", size: "250 employees"),
//     description: "Lead digital campaigns and manage online presence.",
//     workplace: "Remote",
//     type: "Full-time",
//     experienceLevel: "Mid-Level",
//     salaryRange: SalaryRange(min: 55000, max: 75000),
//     location: Location(city: "Paris", country: "France"),
//     keywords: ["SEO", "Content Marketing", "Social Media"],
//     createdAt: DateTime.now(),
//   ),
//   Job(
//     id: '35',
//     title: "UI/UX Designer",
//     industry: "Design",
//     company: Company(name: "DesignHive", size: "100 employees"),
//     description: "Design intuitive user interfaces and experiences.",
//     workplace: "Hybrid",
//     type: "Full-time",
//     experienceLevel: "Mid-Level",
//     salaryRange: SalaryRange(min: 50000, max: 70000),
//     location: Location(city: "Sydney", country: "Australia"),
//     keywords: ["Sketch", "Adobe XD", "User Research"],
//     createdAt: DateTime.now(),
//   ),
//   Job(
//     id: '36',
//     title: "Mobile App Developer",
//     industry: "Technology",
//     company: Company(name: "AppInnovate", size: "120 employees"),
//     description: "Develop high-quality mobile applications.",
//     workplace: "Onsite",
//     type: "Full-time",
//     experienceLevel: "Mid-Level",
//     salaryRange: SalaryRange(min: 60000, max: 85000),
//     location: Location(city: "Bangalore", country: "India"),
//     keywords: ["Flutter", "Dart", "iOS", "Android"],
//     createdAt: DateTime.now(),
//   ),
//   Job(
//     id: '37',
//     title: "Cloud Engineer",
//     industry: "Technology",
//     company: Company(name: "CloudNet", size: "350 employees"),
//     description: "Design and maintain cloud infrastructure.",
//     workplace: "Remote",
//     type: "Full-time",
//     experienceLevel: "Senior-Level",
//     salaryRange: SalaryRange(min: 75000, max: 110000),
//     location: Location(city: "Tokyo", country: "Japan"),
//     keywords: ["AWS", "Azure", "DevOps"],
//     createdAt: DateTime.now(),
//   ),
//   Job(
//     id: '38',
//     title: "Quality Assurance Engineer",
//     industry: "Technology",
//     company: Company(name: "QualityFirst", size: "200 employees"),
//     description: "Ensure the quality of software products.",
//     workplace: "Onsite",
//     type: "Full-time",
//     experienceLevel: "Entry-Level",
//     salaryRange: SalaryRange(min: 40000, max: 60000),
//     location: Location(city: "Beijing", country: "China"),
//     keywords: ["Testing", "Automation", "Selenium"],
//     createdAt: DateTime.now(),
//   ),
//   Job(
//     id: '39',
//     title: "Business Analyst",
//     industry: "Consulting",
//     company: Company(name: "ConsultCorp", size: "500 employees"),
//     description: "Provide strategic business insights to clients.",
//     workplace: "Hybrid",
//     type: "Full-time",
//     experienceLevel: "Mid-Level",
//     salaryRange: SalaryRange(min: 65000, max: 90000),
//     location: Location(city: "São Paulo", country: "Brazil"),
//     keywords: ["Analysis", "Reporting", "Business Intelligence"],
//     createdAt: DateTime.now(),
//   ),
//   Job(
//     id: '40',
//     title: "HR Manager",
//     industry: "Human Resources",
//     company: Company(name: "PeopleFirst", size: "150 employees"),
//     description: "Manage recruitment and employee relations.",
//     workplace: "Onsite",
//     type: "Full-time",
//     experienceLevel: "Senior-Level",
//     salaryRange: SalaryRange(min: 55000, max: 80000),
//     location: Location(city: "Cape Town", country: "South Africa"),
//     keywords: ["Recruitment", "Employee Engagement", "Policy"],
//     createdAt: DateTime.now(),
//   ),
//   Job(
//     id: '41',
//     title: "Product Manager",
//     industry: "Technology",
//     company: Company(name: "InnovateNow", size: "350 employees"),
//     description: "Oversee product development and roadmap.",
//     workplace: "Remote",
//     type: "Full-time",
//     experienceLevel: "Senior-Level",
//     salaryRange: SalaryRange(min: 80000, max: 120000),
//     location: Location(city: "Dublin", country: "Ireland"),
//     keywords: ["Agile", "Scrum", "Roadmap"],
//     createdAt: DateTime.now(),
//   ),
//   Job(
//     id: '42',
//     title: "UX Researcher",
//     industry: "Design",
//     company: Company(name: "UserFirst", size: "100 employees"),
//     description: "Conduct user research to inform design decisions.",
//     workplace: "Onsite",
//     type: "Full-time",
//     experienceLevel: "Entry-Level",
//     salaryRange: SalaryRange(min: 45000, max: 65000),
//     location: Location(city: "Berlin", country: "Germany"),
//     keywords: ["User Testing", "Interviews", "Data Analysis"],
//     createdAt: DateTime.now(),
//   ),
//   Job(
//     id: '43',
//     title: "Digital Content Writer",
//     industry: "Media",
//     company: Company(name: "ContentKing", size: "80 employees"),
//     description: "Write engaging digital content for multiple platforms.",
//     workplace: "Remote",
//     type: "Part-time",
//     experienceLevel: "Mid-Level",
//     salaryRange: SalaryRange(min: 35000, max: 50000),
//     location: Location(city: "London", country: "UK"),
//     keywords: ["Writing", "SEO", "Editing"],
//     createdAt: DateTime.now(),
//   ),
//   Job(
//     id: '44',
//     title: "Operations Manager",
//     industry: "Logistics",
//     company: Company(name: "LogiCorp", size: "400 employees"),
//     description: "Manage day-to-day operations and logistics.",
//     workplace: "Onsite",
//     type: "Full-time",
//     experienceLevel: "Senior-Level",
//     salaryRange: SalaryRange(min: 60000, max: 90000),
//     location: Location(city: "Madrid", country: "Spain"),
//     keywords: ["Operations", "Management", "Supply Chain"],
//     createdAt: DateTime.now(),
//   ),
//   Job(
//     id: '45',
//     title: "Graphic Designer",
//     industry: "Design",
//     company: Company(name: "PixelPerfect", size: "120 employees"),
//     description: "Create visual designs and marketing materials.",
//     workplace: "Hybrid",
//     type: "Contract",
//     experienceLevel: "Entry-Level",
//     salaryRange: SalaryRange(min: 30000, max: 50000),
//     location: Location(city: "Milan", country: "Italy"),
//     keywords: ["Photoshop", "Illustrator", "Creativity"],
//     createdAt: DateTime.now(),
//   ),
//   Job(
//     id: '46',
//     title: "Supply Chain Analyst",
//     industry: "Logistics",
//     company: Company(name: "SupplyWise", size: "200 employees"),
//     description: "Analyze supply chain processes and optimize performance.",
//     workplace: "Remote",
//     type: "Full-time",
//     experienceLevel: "Mid-Level",
//     salaryRange: SalaryRange(min: 50000, max: 75000),
//     location: Location(city: "Stockholm", country: "Sweden"),
//     keywords: ["Logistics", "Analytics", "Optimization"],
//     createdAt: DateTime.now(),
//   ),
//   Job(
//     id: '47',
//     title: "Mobile Designer",
//     industry: "Design",
//     company: Company(name: "AppArt", size: "90 employees"),
//     description: "Design engaging mobile experiences.",
//     workplace: "Remote",
//     type: "Contract",
//     experienceLevel: "Mid-Level",
//     salaryRange: SalaryRange(min: 40000, max: 60000),
//     location: Location(city: "Amsterdam", country: "Netherlands"),
//     keywords: ["UI/UX", "Sketch", "Prototyping"],
//     createdAt: DateTime.now(),
//   ),
//   Job(
//     id: '48',
//     title: "Cybersecurity Analyst",
//     industry: "Security",
//     company: Company(name: "SecureNet", size: "250 employees"),
//     description: "Monitor and secure IT systems.",
//     workplace: "Onsite",
//     type: "Full-time",
//     experienceLevel: "Mid-Level",
//     salaryRange: SalaryRange(min: 65000, max: 95000),
//     location: Location(city: "Zurich", country: "Switzerland"),
//     keywords: ["Security", "Monitoring", "Risk Assessment"],
//     createdAt: DateTime.now(),
//   ),
//   Job(
//     id: '49',
//     title: "Business Development Manager",
//     industry: "Sales",
//     company: Company(name: "GrowthHub", size: "300 employees"),
//     description: "Identify new business opportunities.",
//     workplace: "Hybrid",
//     type: "Full-time",
//     experienceLevel: "Senior-Level",
//     salaryRange: SalaryRange(min: 70000, max: 110000),
//     location: Location(city: "Melbourne", country: "Australia"),
//     keywords: ["Sales", "Strategy", "Networking"],
//     createdAt: DateTime.now(),
//   ),
//   Job(
//     id: '50',
//     title: "Customer Success Manager",
//     industry: "Customer Service",
//     company: Company(name: "ClientFirst", size: "180 employees"),
//     description: "Ensure client satisfaction and retention.",
//     workplace: "Remote",
//     type: "Full-time",
//     experienceLevel: "Mid-Level",
//     salaryRange: SalaryRange(min: 55000, max: 80000),
//     location: Location(city: "Singapore", country: "Singapore"),
//     keywords: ["Customer Service", "Relationship Management"],
//     createdAt: DateTime.now(),
//   ),
//   Job(
//     id: '51',
//     title: "Software Engineer",
//     industry: "Technology",
//     company: Company(name: "Microsoft", size: "10,000+ employees"),
//     description: "Develop scalable cloud solutions.",
//     workplace: "Hybrid",
//     type: "Full-time",
//     experienceLevel: "Mid-Level",
//     salaryRange: SalaryRange(min: 90000, max: 120000),
//     location: Location(city: "Seattle", country: "USA"),
//     keywords: ["C#", "Azure", "Cloud Computing"],
//     createdAt: DateTime(2025, 03, 01),
//   ),
//   Job(
//     id: '52',
//     title: "Data Scientist",
//     industry: "Technology",
//     company: Company(name: "Google", size: "10,000+ employees"),
//     description: "Analyze big data to improve AI models.",
//     workplace: "Remote",
//     type: "Full-time",
//     experienceLevel: "Senior-Level",
//     salaryRange: SalaryRange(min: 130000, max: 180000),
//     location: Location(city: "Mountain View", country: "USA"),
//     keywords: ["Python", "Machine Learning", "AI"],
//     createdAt: DateTime(2025, 03, 02),
//   ),
//   Job(
//     id: '53',
//     title: "UX Designer",
//     industry: "Technology",
//     company: Company(name: "Meta", size: "10,000+ employees"),
//     description: "Design engaging user experiences.",
//     workplace: "On-site",
//     type: "Full-time",
//     experienceLevel: "Entry-Level",
//     salaryRange: SalaryRange(min: 70000, max: 95000),
//     location: Location(city: "Menlo Park", country: "USA"),
//     keywords: ["UX", "Design Thinking", "Prototyping"],
//     createdAt: DateTime(2025, 03, 03),
//   ),
//   Job(
//     id: '54',
//     title: "Backend Engineer",
//     industry: "Technology",
//     company: Company(name: "Amazon", size: "10,000+ employees"),
//     description: "Develop and maintain backend services.",
//     workplace: "Hybrid",
//     type: "Full-time",
//     experienceLevel: "Mid-Level",
//     salaryRange: SalaryRange(min: 100000, max: 140000),
//     location: Location(city: "New York", country: "USA"),
//     keywords: ["Java", "AWS", "Microservices"],
//     createdAt: DateTime(2025, 03, 04),
//   ),
//   Job(
//     id: '55',
//     title: "AI Researcher",
//     industry: "Technology",
//     company: Company(name: "Google", size: "10,000+ employees"),
//     description: "Conduct cutting-edge AI research.",
//     workplace: "Remote",
//     type: "Full-time",
//     experienceLevel: "Senior-Level",
//     salaryRange: SalaryRange(min: 150000, max: 200000),
//     location: Location(city: "London", country: "UK"),
//     keywords: ["Deep Learning", "AI", "TensorFlow"],
//     createdAt: DateTime(2025, 03, 05),
//   ),
//   Job(
//     id: '56',
//     title: "Mobile Developer",
//     industry: "Technology",
//     company: Company(name: "Apple", size: "10,000+ employees"),
//     description: "Build iOS applications for Apple devices.",
//     workplace: "On-site",
//     type: "Full-time",
//     experienceLevel: "Mid-Level",
//     salaryRange: SalaryRange(min: 95000, max: 130000),
//     location: Location(city: "Cupertino", country: "USA"),
//     keywords: ["Swift", "iOS", "Xcode"],
//     createdAt: DateTime(2025, 03, 06),
//   ),
//   Job(
//     id: '57',
//     title: "Cybersecurity Analyst",
//     industry: "Technology",
//     company: Company(name: "Microsoft", size: "10,000+ employees"),
//     description: "Protect systems from cyber threats.",
//     workplace: "Hybrid",
//     type: "Full-time",
//     experienceLevel: "Senior-Level",
//     salaryRange: SalaryRange(min: 110000, max: 160000),
//     location: Location(city: "Berlin", country: "Germany"),
//     keywords: ["Cybersecurity", "Penetration Testing", "Cloud Security"],
//     createdAt: DateTime(2025, 03, 07),
//   ),
//   Job(
//     id: '58',
//     title: "Machine Learning Engineer",
//     industry: "Technology",
//     company: Company(name: "Meta", size: "10,000+ employees"),
//     description: "Develop ML models for social platforms.",
//     workplace: "Remote",
//     type: "Full-time",
//     experienceLevel: "Mid-Level",
//     salaryRange: SalaryRange(min: 120000, max: 160000),
//     location: Location(city: "Toronto", country: "Canada"),
//     keywords: ["Machine Learning", "AI", "Big Data"],
//     createdAt: DateTime(2025, 03, 08),
//   ),
//   Job(
//     id: '59',
//     title: "Frontend Developer",
//     industry: "Technology",
//     company: Company(name: "Amazon", size: "10,000+ employees"),
//     description: "Develop dynamic user interfaces.",
//     workplace: "Hybrid",
//     type: "Full-time",
//     experienceLevel: "Entry-Level",
//     salaryRange: SalaryRange(min: 75000, max: 110000),
//     location: Location(city: "Paris", country: "France"),
//     keywords: ["React", "JavaScript", "UI/UX"],
//     createdAt: DateTime(2025, 03, 09),
//   ),
//   Job(
//     id: '60',
//     title: "Embedded Systems Engineer",
//     industry: "Technology",
//     company: Company(name: "Samsung", size: "10,000+ employees"),
//     description: "Develop embedded software for IoT devices.",
//     workplace: "On-site",
//     type: "Full-time",
//     experienceLevel: "Senior-Level",
//     salaryRange: SalaryRange(min: 115000, max: 140000),
//     location: Location(city: "Seoul", country: "South Korea"),
//     keywords: ["Embedded C", "IoT", "Microcontrollers"],
//     createdAt: DateTime(2025, 03, 10),
//   ),
//   Job(
//     id: '61',
//     title: "Product Manager",
//     industry: "Technology",
//     company: Company(name: "Google", size: "10,000+ employees"),
//     description: "Oversee product development from concept to launch.",
//     workplace: "Hybrid",
//     type: "Full-time",
//     experienceLevel: "Senior-Level",
//     salaryRange: SalaryRange(min: 130000, max: 170000),
//     location: Location(city: "Zurich", country: "Switzerland"),
//     keywords: ["Product", "Management", "Agile"],
//     createdAt: DateTime(2025, 04, 01),
//   ),
//   Job(
//     id: '62',
//     title: "Data Analyst",
//     industry: "Analytics",
//     company: Company(name: "Meta", size: "10,000+ employees"),
//     description: "Analyze user data to drive business insights.",
//     workplace: "Remote",
//     type: "Full-time",
//     experienceLevel: "Mid-Level",
//     salaryRange: SalaryRange(min: 90000, max: 120000),
//     location: Location(city: "Dublin", country: "Ireland"),
//     keywords: ["Data", "SQL", "Analytics"],
//     createdAt: DateTime(2025, 04, 02),
//   ),
//   Job(
//     id: '63',
//     title: "Backend Developer",
//     industry: "Software",
//     company: Company(name: "Amazon", size: "10,000+ employees"),
//     description: "Build and maintain scalable backend systems.",
//     workplace: "Hybrid",
//     type: "Full-time",
//     experienceLevel: "Mid-Level",
//     salaryRange: SalaryRange(min: 105000, max: 140000),
//     location: Location(city: "Tokyo", country: "Japan"),
//     keywords: ["Node.js", "AWS", "API"],
//     createdAt: DateTime(2025, 04, 03),
//   ),
//   Job(
//     id: '64',
//     title: "Frontend Developer",
//     industry: "Software",
//     company: Company(name: "Apple", size: "10,000+ employees"),
//     description: "Develop responsive and elegant web interfaces.",
//     workplace: "On-site",
//     type: "Full-time",
//     experienceLevel: "Entry-Level",
//     salaryRange: SalaryRange(min: 85000, max: 110000),
//     location: Location(city: "Copenhagen", country: "Denmark"),
//     keywords: ["React", "JavaScript", "CSS"],
//     createdAt: DateTime(2025, 04, 04),
//   ),
//   Job(
//     id: '65',
//     title: "DevOps Engineer",
//     industry: "Technology",
//     company: Company(name: "Microsoft", size: "10,000+ employees"),
//     description: "Maintain and optimize CI/CD pipelines.",
//     workplace: "Remote",
//     type: "Full-time",
//     experienceLevel: "Mid-Level",
//     salaryRange: SalaryRange(min: 115000, max: 150000),
//     location: Location(city: "Toronto", country: "Canada"),
//     keywords: ["Docker", "Kubernetes", "Azure"],
//     createdAt: DateTime(2025, 04, 05),
//   ),
//   Job(
//     id: '66',
//     title: "Software Tester",
//     industry: "Quality Assurance",
//     company: Company(name: "Samsung", size: "10,000+ employees"),
//     description: "Perform manual and automated testing of software.",
//     workplace: "On-site",
//     type: "Contract",
//     experienceLevel: "Entry-Level",
//     salaryRange: SalaryRange(min: 60000, max: 80000),
//     location: Location(city: "Seoul", country: "South Korea"),
//     keywords: ["Testing", "Automation", "QA"],
//     createdAt: DateTime(2025, 04, 06),
//   ),
//   Job(
//     id: '67',
//     title: "Mobile App Developer",
//     industry: "Software",
//     company: Company(name: "Google", size: "10,000+ employees"),
//     description: "Develop innovative mobile applications.",
//     workplace: "Remote",
//     type: "Full-time",
//     experienceLevel: "Mid-Level",
//     salaryRange: SalaryRange(min: 100000, max: 135000),
//     location: Location(city: "Singapore", country: "Singapore"),
//     keywords: ["Flutter", "iOS", "Android"],
//     createdAt: DateTime(2025, 04, 07),
//   ),
//   Job(
//     id: '68',
//     title: "Cloud Engineer",
//     industry: "Technology",
//     company: Company(name: "Amazon", size: "10,000+ employees"),
//     description: "Design and maintain cloud infrastructure.",
//     workplace: "Hybrid",
//     type: "Full-time",
//     experienceLevel: "Senior-Level",
//     salaryRange: SalaryRange(min: 125000, max: 165000),
//     location: Location(city: "London", country: "UK"),
//     keywords: ["AWS", "Cloud", "Infrastructure"],
//     createdAt: DateTime(2025, 04, 08),
//   ),
//   Job(
//     id: '69',
//     title: "Cybersecurity Specialist",
//     industry: "Security",
//     company: Company(name: "Microsoft", size: "10,000+ employees"),
//     description: "Implement security measures for digital assets.",
//     workplace: "Hybrid",
//     type: "Full-time",
//     experienceLevel: "Senior-Level",
//     salaryRange: SalaryRange(min: 120000, max: 160000),
//     location: Location(city: "Paris", country: "France"),
//     keywords: ["Security", "Penetration Testing", "Compliance"],
//     createdAt: DateTime(2025, 04, 09),
//   ),
//   Job(
//     id: '70',
//     title: "Machine Learning Engineer",
//     industry: "Technology",
//     company: Company(name: "Meta", size: "10,000+ employees"),
//     description: "Build ML models for recommendation systems.",
//     workplace: "Remote",
//     type: "Full-time",
//     experienceLevel: "Mid-Level",
//     salaryRange: SalaryRange(min: 115000, max: 150000),
//     location: Location(city: "Berlin", country: "Germany"),
//     keywords: ["Python", "ML", "TensorFlow"],
//     createdAt: DateTime(2025, 04, 10),
//   ),
//   Job(
//     id: '71',
//     title: "Systems Architect",
//     industry: "Technology",
//     company: Company(name: "Apple", size: "10,000+ employees"),
//     description: "Design and architect complex systems.",
//     workplace: "On-site",
//     type: "Full-time",
//     experienceLevel: "Senior-Level",
//     salaryRange: SalaryRange(min: 135000, max: 180000),
//     location: Location(city: "Tokyo", country: "Japan"),
//     keywords: ["Architecture", "Design", "Scalability"],
//     createdAt: DateTime(2025, 04, 11),
//   ),
//   Job(
//     id: '72',
//     title: "UI/UX Designer",
//     industry: "Design",
//     company: Company(name: "Samsung", size: "10,000+ employees"),
//     description: "Create elegant user interfaces and experiences.",
//     workplace: "Remote",
//     type: "Full-time",
//     experienceLevel: "Entry-Level",
//     salaryRange: SalaryRange(min: 80000, max: 110000),
//     location: Location(city: "Bangkok", country: "Thailand"),
//     keywords: ["UI/UX", "Design", "Figma"],
//     createdAt: DateTime(2025, 04, 12),
//   ),
//   Job(
//     id: '73',
//     title: "QA Engineer",
//     industry: "Quality Assurance",
//     company: Company(name: "Google", size: "10,000+ employees"),
//     description: "Ensure product quality with rigorous testing.",
//     workplace: "Hybrid",
//     type: "Full-time",
//     experienceLevel: "Mid-Level",
//     salaryRange: SalaryRange(min: 90000, max: 120000),
//     location: Location(city: "Madrid", country: "Spain"),
//     keywords: ["Testing", "Automation", "Quality"],
//     createdAt: DateTime(2025, 04, 13),
//   ),
//   Job(
//     id: '74',
//     title: "Network Engineer",
//     industry: "Technology",
//     company: Company(name: "Amazon", size: "10,000+ employees"),
//     description: "Maintain and optimize network infrastructure.",
//     workplace: "On-site",
//     type: "Full-time",
//     experienceLevel: "Entry-Level",
//     salaryRange: SalaryRange(min: 85000, max: 115000),
//     location: Location(city: "Dubai", country: "UAE"),
//     keywords: ["Networking", "Cisco", "Security"],
//     createdAt: DateTime(2025, 04, 14),
//   ),
//   Job(
//     id: '75',
//     title: "Database Administrator",
//     industry: "IT",
//     company: Company(name: "Microsoft", size: "10,000+ employees"),
//     description: "Manage and optimize database systems.",
//     workplace: "Hybrid",
//     type: "Full-time",
//     experienceLevel: "Senior-Level",
//     salaryRange: SalaryRange(min: 110000, max: 150000),
//     location: Location(city: "Moscow", country: "Russia"),
//     keywords: ["SQL", "Oracle", "Database"],
//     createdAt: DateTime(2025, 04, 15),
//   ),
//   Job(
//     id: '76',
//     title: "Technical Writer",
//     industry: "Media",
//     company: Company(name: "Meta", size: "10,000+ employees"),
//     description: "Write and maintain technical documentation.",
//     workplace: "Remote",
//     type: "Full-time",
//     experienceLevel: "Entry-Level",
//     salaryRange: SalaryRange(min: 70000, max: 95000),
//     location: Location(city: "Amsterdam", country: "Netherlands"),
//     keywords: ["Writing", "Documentation", "Content"],
//     createdAt: DateTime(2025, 04, 16),
//   ),
//   Job(
//     id: '77',
//     title: "Full Stack Developer",
//     industry: "Software",
//     company: Company(name: "Apple", size: "10,000+ employees"),
//     description: "Develop both frontend and backend systems.",
//     workplace: "Hybrid",
//     type: "Full-time",
//     experienceLevel: "Mid-Level",
//     salaryRange: SalaryRange(min: 115000, max: 150000),
//     location: Location(city: "Stockholm", country: "Sweden"),
//     keywords: ["Full Stack", "React", "Node.js"],
//     createdAt: DateTime(2025, 04, 17),
//   ),
//   Job(
//     id: '78',
//     title: "Business Analyst",
//     industry: "Business",
//     company: Company(name: "Samsung", size: "10,000+ employees"),
//     description: "Analyze business processes and requirements.",
//     workplace: "On-site",
//     type: "Full-time",
//     experienceLevel: "Mid-Level",
//     salaryRange: SalaryRange(min: 90000, max: 125000),
//     location: Location(city: "Vienna", country: "Austria"),
//     keywords: ["Analysis", "Business", "Reporting"],
//     createdAt: DateTime(2025, 04, 18),
//   ),
//   Job(
//     id: '79',
//     title: "Security Engineer",
//     industry: "Security",
//     company: Company(name: "Google", size: "10,000+ employees"),
//     description: "Implement and monitor security measures.",
//     workplace: "Hybrid",
//     type: "Full-time",
//     experienceLevel: "Senior-Level",
//     salaryRange: SalaryRange(min: 120000, max: 160000),
//     location: Location(city: "Oslo", country: "Norway"),
//     keywords: ["Security", "Encryption", "Monitoring"],
//     createdAt: DateTime(2025, 04, 19),
//   ),
//   Job(
//     id: '80',
//     title: "Mobile Game Developer",
//     industry: "Gaming",
//     company: Company(name: "Amazon", size: "10,000+ employees"),
//     description: "Design and develop mobile games.",
//     workplace: "Remote",
//     type: "Full-time",
//     experienceLevel: "Mid-Level",
//     salaryRange: SalaryRange(min: 95000, max: 130000),
//     location: Location(city: "Helsinki", country: "Finland"),
//     keywords: ["Unity", "C#", "Game Development"],
//     createdAt: DateTime(2025, 04, 20),
//   ),
// ];
