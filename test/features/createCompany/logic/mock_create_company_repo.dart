import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:joblinc/features/companyPages/data/data/company.dart';
import 'package:joblinc/features/companyPages/logic/cubit/create_company_cubit.dart';
import 'package:joblinc/features/companyPages/data/data/repos/createcompany_repo.dart';
import 'package:mocktail/mocktail.dart';

class MockCreateCompanyRepo extends Mock implements CreateCompanyRepo {}

void main() {
  // Initialize the Flutter binding
  TestWidgetsFlutterBinding.ensureInitialized();

  late CreateCompanyCubit createCompanyCubit;
  late MockCreateCompanyRepo mockCreateCompanyRepo;

  setUp(() {
    mockCreateCompanyRepo = MockCreateCompanyRepo();
    createCompanyCubit = CreateCompanyCubit(
      mockCreateCompanyRepo,
      onCompanyCreated: (company) {
        // Dummy callback for testing
      },
    );

    // Registering fallback values for mocktail
    registerFallbackValue(Industry.technology);
    registerFallbackValue(OrganizationSize.zeroToOne);
    registerFallbackValue(OrganizationType.privatelyHeld);
  });

  tearDown(() {
    createCompanyCubit.close();
  });

  group('CreateCompanyCubit Tests', () {
    test('Initial state is CreateCompanyInitial', () {
      expect(createCompanyCubit.state, isA<CreateCompanyInitial>());
    });

    blocTest<CreateCompanyCubit, CreateCompanyState>(
      'emits [CreateCompanyLoading, CreateCompanySuccess] when createCompany succeeds',
      build: () {
        when(() => mockCreateCompanyRepo.createCompany(
          any(), any(), any(), any(), any(),
        )).thenAnswer((_) async {
          print("Mock createCompany called successfully.");
          return Future.value();
        });
        return createCompanyCubit;
      },
      act: (cubit) => cubit.createCompany(
        nameController: TextEditingController(text: 'Test Company'),
        jobLincUrlController: TextEditingController(text: 'test-company'),
        selectedIndustry: Industry.technology,
        orgSize: OrganizationSize.zeroToOne,
        orgType: OrganizationType.privatelyHeld,
        websiteController: TextEditingController(text: 'https://test.com'),

      ),
      expect: () => [
        isA<CreateCompanyLoading>(),
        isA<CreateCompanySuccess>(),
      ],
      verify: (_) {
        verify(() => mockCreateCompanyRepo.createCompany(
          any(), // name
          any(), // email
          any(), // password
          any(), // industry
          any(), // overview
        )).called(1);
      },
    );

    blocTest<CreateCompanyCubit, CreateCompanyState>(
      'emits [CreateCompanyLoading, CreateCompanyFailure] when createCompany fails',
      build: () {
        when(() => mockCreateCompanyRepo.createCompany(
          any(), any(), any(), any(), any(),
        )).thenThrow(Exception('Failed to create company'));
        return createCompanyCubit;
      },
      act: (cubit) => cubit.createCompany(
        nameController: TextEditingController(text: 'Test Company'),
        jobLincUrlController: TextEditingController(text: 'test-company'),
        selectedIndustry: Industry.technology,
        orgSize: OrganizationSize.zeroToOne,
        orgType: OrganizationType.privatelyHeld,
        websiteController: TextEditingController(text: 'https://test.com'),

      ),
      expect: () => [
        isA<CreateCompanyLoading>(),
        predicate<CreateCompanyFailure>(
          (state) => state.error.contains('Failed to create company'),
        ),
      ],
      verify: (_) {
        verify(() => mockCreateCompanyRepo.createCompany(
          any(), any(), any(), any(), any(),
        )).called(1);
      },
    );
  });
}
