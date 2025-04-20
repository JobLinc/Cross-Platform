import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:joblinc/features/jobs/data/models/job_model.dart';
import 'package:joblinc/features/jobs/data/models/job_application_model.dart';
import 'package:joblinc/features/jobs/data/repos/job_repo.dart';
import 'package:joblinc/features/jobs/logic/cubit/job_list_cubit.dart';
import 'package:joblinc/features/jobs/logic/cubit/my_jobs_cubit.dart';

/// A Mockito mock for the repository.
class MockJobRepo extends Mock implements JobRepo {}

void main() {
  // Sample instances to drive the tests:
  final sampleCompany = Company(name: 'ACME', size: '100-500');
  final sampleSalary = SalaryRange(min: 50.0, max: 100.0);
  final sampleLocation = Location(city: 'New York', country: 'USA');
  final sampleJob = Job(
    id: 'j1',
    title: 'Flutter Developer',
    industry: 'Tech',
    company: sampleCompany,
    description: 'Build apps',
    workplace: 'Remote',
    type: 'Full-time',
    experienceLevel: 'Mid',
    salaryRange: sampleSalary,
    location: sampleLocation,
    keywords: ['flutter', 'dart'],
    createdAt: DateTime.now(),
  );

  final sampleApplicant = Applicant(
    id: 'u1',
    firstname: 'John',
    lastname: 'Doe',
    username: 'johnd',
    email: 'john@example.com',
    country: 'USA',
    city: 'NY',
    phoneNumber: '+1234567890',
  );

  final sampleResume = Resume(
    id: 'r1',
    url: 'https://example.com/cv.pdf',
    date: DateTime.now(),
    size: 12345,
    name: 'cv',
    extension: '.pdf',
  );

  final sampleApplication = JobApplication(
    applicant: sampleApplicant,
    job: sampleJob,
    resume: sampleResume,
    createdAt: DateTime.now(),
  );

  group('JobListCubit', () {
    late MockJobRepo mockRepo;
    late JobListCubit cubit;

    setUp(() {
      mockRepo = MockJobRepo();
      cubit = JobListCubit(mockRepo);
    });

    tearDown(() => cubit.close());

    blocTest<JobListCubit, JobListState>(
      'getAllJobs → [Loading, Empty] when repo returns []',
      build: () {
        when(mockRepo.getAllJobs()).thenAnswer((_) async => []);
        return cubit;
      },
      act: (c) => c.getAllJobs(),
      expect: () => [
        isA<JobListLoading>(),
        isA<JobListEmpty>(),
      ],
    );

    blocTest<JobListCubit, JobListState>(
      'getAllJobs → [Loading, Loaded] when repo returns non-empty',
      build: () {
        when(mockRepo.getAllJobs())
            .thenAnswer((_) async => [sampleJob]);
        return cubit;
      },
      act: (c) => c.getAllJobs(),
      expect: () => [
        isA<JobListLoading>(),
        predicate<JobListLoaded>((s) => s.jobs!.length == 1 && s.jobs!.first.id == 'j1'),
      ],
    );

    blocTest<JobListCubit, JobListState>(
      'getAllJobs → [Loading, Error] on throw',
      build: () {
        when(mockRepo.getAllJobs()).thenThrow(Exception('oops'));
        return cubit;
      },
      act: (c) => c.getAllJobs(),
      expect: () => [
        isA<JobListLoading>(),
        isA<JobListErrorLoading>(),
      ],
    );

    blocTest<JobListCubit, JobListState>(
      'getSavedJobs → [JobSavedLoading, JobSavedEmpty] when []',
      build: () {
        when(mockRepo.getSavedJobs()).thenAnswer((_) async => []);
        return cubit;
      },
      act: (c) => c.getSavedJobs(),
      expect: () => [
        isA<JobSavedLoading>(),
        isA<JobSavedEmpty>(),
      ],
    );

    blocTest<JobListCubit, JobListState>(
      'getAppliedJobs → [JobAppliedLoading, JobAppliedLoaded] when non-empty',
      build: () {
        when(mockRepo.getAppliedJobs())
            .thenAnswer((_) async => [sampleJob]);
        return cubit;
      },
      act: (c) => c.getAppliedJobs(),
      expect: () => [
        isA<JobAppliedLoading>(),
        predicate<JobAppliedLoaded>((s) => s.appliedJobs.first.id == 'j1'),
      ],
    );

    blocTest<JobListCubit, JobListState>(
      'getSearchedFilteredJobs → [JobSearchLoading, JobSearchEmpty] when []',
      build: () {
        when(mockRepo.getSearchedFilteredJobs('kw', null, null))
            .thenAnswer((_) async => []);
        return cubit;
      },
      act: (c) => c.getSearchedFilteredJobs('kw', null, null),
      expect: () => [
        isA<JobSearchLoading>(),
        isA<JobSearchEmpty>(),
      ],
    );

    blocTest<JobListCubit, JobListState>(
      'getJobDetails → [JobDetailsLoading, JobDetailsLoaded]',
      build: () {
        when(mockRepo.getSavedJobs()).thenAnswer((_) async => [sampleJob]);
        when(mockRepo.getAppliedJobs()).thenAnswer((_) async => [sampleJob]);
        return cubit;
      },
      act: (c) => c.getJobDetails(),
      expect: () => [
        isA<JobDetailsLoading>(),
        isA<JobDetailsLoaded>(),
      ],
    );

    blocTest<JobListCubit, JobListState>(
      'getAllResumes → [JobResumesLoading, JobResumesLoaded]',
      build: () {
        when(mockRepo.getAllResumes())
            .thenAnswer((_) async => [sampleResume]);
        return cubit;
      },
      act: (c) => c.getAllResumes(),
      expect: () => [
        isA<JobResumesLoading>(),
        predicate<JobResumesLoaded>((s) => s.resumes!.first.id == 'r1'),
      ],
    );

    blocTest<JobListCubit, JobListState>(
      'applyJob → [JobApplicationSending, JobApplicationSent]',
      build: () {
        when(mockRepo.applyJob('j1', sampleApplication))
            .thenAnswer((_) async => {});
        return cubit;
      },
      act: (c) => c.applyJob('j1', sampleApplication),
      expect: () => [
        isA<JobApplicationSending>(),
        isA<JobApplicationSent>(),
      ],
    );

    blocTest<JobListCubit, JobListState>(
      'applyJob → [JobApplicationSending, JobApplicationErrorSending] on throw',
      build: () {
        when(mockRepo.applyJob('j1', sampleApplication))
            .thenThrow(Exception('fail'));
        return cubit;
      },
      act: (c) => c.applyJob('j1', sampleApplication),
      expect: () => [
        isA<JobApplicationSending>(),
        isA<JobApplicationErrorSending>(),
      ],
    );

    blocTest<JobListCubit, JobListState>(
      'createJob → [JobCreating, JobCreated]',
      build: () {
        when(mockRepo.createJob(sampleJob)).thenAnswer((_) async => {});
        return cubit;
      },
      act: (c) => c.createJob(sampleJob),
      expect: () => [
        isA<JobCreating>(),
        isA<JobCreated>(),
      ],
    );

    blocTest<JobListCubit, JobListState>(
      'emitJobSearchInitial → [JobSearchInitial]',
      build: () => cubit,
      act: (c) => c.emitJobSearchInitial(),
      expect: () => [isA<JobSearchInitial>()],
    );
  });

  group('MyJobsCubit', () {
    late MockJobRepo mockRepo;
    late MyJobsCubit cubit;

    setUp(() {
      mockRepo = MockJobRepo();
      cubit = MyJobsCubit(mockRepo);
    });

    tearDown(() => cubit.close());

    blocTest<MyJobsCubit, MyJobsState>(
      'getSavedJobs → [MyJobsLoading, MySavedJobsEmpty] for []',
      build: () {
        when(mockRepo.getSavedJobs()).thenAnswer((_) async => []);
        return cubit;
      },
      act: (c) => c.getSavedJobs(),
      expect: () => [
        isA<MyJobsLoading>(),
        isA<MySavedJobsEmpty>(),
      ],
    );

    blocTest<MyJobsCubit, MyJobsState>(
      'getAppliedJobs → [MyJobsLoading, MyAppliedJobsLoaded] for non-empty',
      build: () {
        when(mockRepo.getAppliedJobs())
            .thenAnswer((_) async => [sampleJob]);
        return cubit;
      },
      act: (c) => c.getAppliedJobs(),
      expect: () => [
        isA<MyJobsLoading>(),
        predicate<MyAppliedJobsLoaded>((s) => s.appliedJobs.first.id == 'j1'),
      ],
    );

    blocTest<MyJobsCubit, MyJobsState>(
      'getCreatedJobs → [MyJobsLoading, MyCreatedJobsLoaded] for non-empty',
      build: () {
        when(mockRepo.getCreatedJobs())
            .thenAnswer((_) async => [sampleJob]);
        return cubit;
      },
      act: (c) => c.getCreatedJobs(),
      expect: () => [
        isA<MyJobsLoading>(),
        predicate<MyCreatedJobsLoaded>((s) => s.createdJobs.first.id == 'j1'),
      ],
    );

    blocTest<MyJobsCubit, MyJobsState>(
      'getJobApplications → [MyJobsLoading, MyJobApplicationsEmpty] for []',
      build: () {
        when(mockRepo.getJobApplications()).thenAnswer((_) async => []);
        return cubit;
      },
      act: (c) => c.getJobApplications(),
      expect: () => [
        isA<MyJobsLoading>(),
        isA<MyJobApplicationsEmpty>(),
      ],
    );

    blocTest<MyJobsCubit, MyJobsState>(
      'getJobApplicants → [MyJobsLoading, MyJobApplicantsLoaded] for non-empty',
      build: () {
        when(mockRepo.getJobApplicants('j1'))
            .thenAnswer((_) async => [sampleApplication]);
        return cubit;
      },
      act: (c) => c.getJobApplicants('j1'),
      expect: () => [
        isA<MyJobsLoading>(),
        predicate<MyJobApplicantsLoaded>((s) =>
            s.jobApplicants.first.job.id == 'j1'),
      ],
    );

    blocTest<MyJobsCubit, MyJobsState>(
      'getJobApplicantById → [MyJobApplicantLoading, MyJobApplicantLoaded]',
      build: () {
        when(mockRepo.getJobApplicantById('j1', 'u1'))
            .thenAnswer((_) async => sampleApplication);
        return cubit;
      },
      act: (c) => c.getJobApplicantById('j1', 'u1'),
      expect: () => [
        isA<MyJobApplicantLoading>(),
        predicate<MyJobApplicantLoaded>(
            (s) => s.jobApplicant.applicant.id == 'u1'),
      ],
    );

    blocTest<MyJobsCubit, MyJobsState>(
      'emitMyJobApplicantLoaded → [MyJobApplicantLoaded]',
      build: () => cubit,
      act: (c) => c.emitMyJobApplicantLoaded(sampleApplication),
      expect: () => [
        predicate<MyJobApplicantLoaded>(
            (s) => s.jobApplicant.status == 'Pending'),
      ],
    );
  });
}
