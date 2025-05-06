import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/helpers/auth_helpers/auth_service.dart';
import 'package:joblinc/features/companypages/data/data/company.dart';
import 'package:joblinc/features/companypages/data/data/repos/getmycompany_repo.dart';
import 'package:joblinc/features/companypages/data/data/services/getmycompany.dart';
import 'package:joblinc/features/companypages/ui/screens/dashboard/company_analytics.dart';

// Generate mock classes with nice mocks for better error messages
@GenerateNiceMocks(
    [MockSpec<CompanyApiService>(), MockSpec<AuthService>(), MockSpec<Dio>()])
import 'analytics_test.mocks.dart';

void main() {
  late MockCompanyApiService mockApiService;
  late CompanyRepositoryImpl mockCompanyRepository;
  late MockAuthService mockAuthService;
  late MockDio mockDio;

  setUp(() {
    mockApiService = MockCompanyApiService();
    mockAuthService = MockAuthService();
    mockDio = MockDio();
    mockCompanyRepository = CompanyRepositoryImpl(mockApiService);

    // Configure DI for testing
    configureTestDependencies(
        mockApiService, mockAuthService, mockCompanyRepository, mockDio);
  });

  final testCompany = Company(
    name: 'Test Company',
    profileUrl: 'test-company',
    industry: 'Technology',
    organizationSize: 'Medium',
    organizationType: 'Private',
    overview: 'Test overview',
    website: 'https://testcompany.com',
    logoUrl: 'https://testlogo.com',
    id: '12345',
    coverUrl: 'https://testcover.com',
    followers: 100,
    isFollowing: true,
    locations: [],
  );

  testWidgets('CompanyAnalytics shows stats correctly when API call succeeds',
      (WidgetTester tester) async {
    // Important: Mock the Dio.get method directly since that's what the widget uses
    when(mockDio.get('/companies/stats', options: anyNamed('options')))
        .thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/companies/stats'),
              data: {
                'totalJobsCount': 10,
                'totalApplicantsCount': 100,
                'acceptedApplicantsCount': 30,
                'rejectedApplicantsCount': 20,
              },
              statusCode: 200,
            ));

    when(mockAuthService.refreshToken(companyId: anyNamed('companyId')))
        .thenAnswer((_) async => true);

    // No longer needed since the widget creates its own repository
    // when(mockCompanyRepository.getCompanyStats())
    //    .thenAnswer((_) async => testCompanyStats);

    // Pump the widget and wait for frame
    await tester.pumpWidget(MaterialApp(
      home: CompanyAnalytics(company: testCompany),
    ));

    // Verify loading indicator is shown initially
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Allow the future to complete
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpAndSettle();

    // Verify stats are displayed correctly
    expect(find.text('Total Job Postings'), findsOneWidget);
    expect(find.text('10'), findsOneWidget);

    expect(find.text('Total Applicants'), findsOneWidget);
    expect(find.text('100'), findsOneWidget);

    expect(find.text('Accepted Candidates'), findsOneWidget);
    expect(find.text('30 (30.0%)'), findsOneWidget);

    expect(find.text('Rejected Candidates'), findsOneWidget);
    expect(find.text('20 (20.0%)'), findsOneWidget);
  });

  testWidgets('CompanyAnalytics shows error when API call fails',
      (WidgetTester tester) async {
    // Mock the failed API response
    when(mockDio.get('/companies/stats', options: anyNamed('options')))
        .thenThrow(DioException(
            requestOptions: RequestOptions(path: '/companies/stats'),
            error: 'Failed to load stats'));

    when(mockAuthService.refreshToken(companyId: anyNamed('companyId')))
        .thenAnswer((_) async => true);

    // Build our app and trigger a frame
    await tester.pumpWidget(MaterialApp(
      home: CompanyAnalytics(company: testCompany),
    ));

    // Verify loading indicator is shown
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Trigger the future completion and rebuild
    await tester.pumpAndSettle();

    // Verify error message is displayed
    expect(find.textContaining('Error:'), findsOneWidget);
  });
}

// Helper function to configure dependencies for testing
void configureTestDependencies(
    MockCompanyApiService mockApiService,
    MockAuthService mockAuthService,
    CompanyRepositoryImpl mockCompanyRepository,
    MockDio mockDio) {
  // Reset the dependency injection before registering new instances
  try {
    getIt.reset();
  } catch (e) {
    // Ignore if getIt is not initialized yet
  }

  // Register mock dependencies
  getIt.registerSingleton<Dio>(mockDio); // This is the key change
  getIt.registerSingleton<AuthService>(mockAuthService);
  getIt.registerSingleton<CompanyApiService>(mockApiService);
}
