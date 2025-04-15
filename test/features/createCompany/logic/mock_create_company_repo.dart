import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:joblinc/features/companypages/data/data/company.dart';
import 'package:joblinc/features/companypages/logic/cubit/create_company_cubit.dart';
import 'package:joblinc/features/companypages/data/data/repos/createcompany_repo.dart';
import 'package:mocktail/mocktail.dart';

class MockCreateCompanyRepo extends Mock implements CreateCompanyRepo {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late CreateCompanyCubit createCompanyCubit;
  late MockCreateCompanyRepo mockCreateCompanyRepo;

  setUp(() {
    mockCreateCompanyRepo = MockCreateCompanyRepo();
    createCompanyCubit = CreateCompanyCubit(
      mockCreateCompanyRepo,
      onCompanyCreated: (company) {}, // Simplified callback
    );

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
              name: any(), // name
              urlSlug: any(), // urlSlug
              industry: any(), // industry
              size: any(), // size
              type: any(), // type
              overview: any(), // overview
              website: any(named: 'website'),
            )).thenAnswer((_) async {});
        return createCompanyCubit;
      },
      act: (cubit) => cubit.createCompany(
        nameController: TextEditingController(text: 'Test Company'),
        jobLincUrlController: TextEditingController(text: 'test-company'),
        selectedIndustry: Industry.technology,
        orgSize: OrganizationSize.zeroToOne,
        orgType: OrganizationType.privatelyHeld,
        websiteController: TextEditingController(text: 'https://test.com'),
        overviewController: TextEditingController(text: 'Test overview'),
      ),
      expect: () => [
        isA<CreateCompanyLoading>(),
        isA<CreateCompanySuccess>(),
      ],
      verify: (_) {
        verify(() => mockCreateCompanyRepo.createCompany(
              name: 'Test Company',
              urlSlug: 'test-company',
              industry: Industry.technology.displayName,
              size: OrganizationSize.zeroToOne.displayName,
              type: OrganizationType.privatelyHeld.displayName,
              overview: 'Test overview',
              website: 'https://test.com',
            )).called(1);
      },
    );

    blocTest<CreateCompanyCubit, CreateCompanyState>(
      'emits [CreateCompanyLoading, CreateCompanyFailure] when createCompany fails',
      build: () {
        when(() => mockCreateCompanyRepo.createCompany(
              name: any(),
              urlSlug: any(),
              industry: any(),
              size: any(),
              type: any(),
              overview: any(),
              website: any(named: 'website'),
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
        overviewController: TextEditingController(text: 'Test overview'),
      ),
      expect: () => [
        isA<CreateCompanyLoading>(),
        isA<CreateCompanyFailure>(),
      ],
    );
  });
}
