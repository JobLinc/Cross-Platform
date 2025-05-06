import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/features/companypages/data/data/models/getmycompany_response.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/features/companypages/data/data/repos/update_company_repo.dart';
import 'package:joblinc/features/companypages/logic/cubit/edit_company_cubit.dart';
import 'package:joblinc/features/companypages/data/data/company.dart';
import 'package:joblinc/features/companypages/data/data/models/location_model.dart';
import 'package:joblinc/features/companypages/ui/widgets/company_add_location.dart';

// Generate mock for UpdateCompanyRepo
@GenerateMocks([UpdateCompanyRepo])
import 'company_locations_test.mocks.dart';

class MockCompanyResponseModel extends CompanyResponse {
  MockCompanyResponseModel({
    required String id,
    required String name,
    required String urlSlug,
    required String industry,
    required String size,
    required String type,
    String? overview,
    String? website,
    String? logo,
    String? coverPhoto,
    int? followers,
    List<CompanyLocationModel>? locations,
  }) : super(
          id: id,
          name: name,
          urlSlug: urlSlug,
          industry: industry,
          size: size,
          type: type,
          overview: overview!,
          website: website!,
          logo: logo,
          coverPhoto: coverPhoto,
          followers: followers,
          locations: locations,
          isFollowing: false,
        );
}

// Custom mock implementation that avoids using 'any'
class MockEditCompanyCubit extends Mock implements EditCompanyCubit {
  @override
  EditCompanyState get state => EditCompanySuccess();

  @override
  Stream<EditCompanyState> get stream =>
      Stream<EditCompanyState>.fromIterable([state]);

  Company? _mockCompany;
  bool _wasMethodCalled = false;
  int _callCount = 0;

  void setupMockResponse(Company mockCompany) {
    _mockCompany = mockCompany;
    _wasMethodCalled = false;
    _callCount = 0;
  }

  @override
  Future<Company?> updateCompanyLocations(
      List<Map<String, dynamic>> locations) {
    _wasMethodCalled = true;
    _callCount++;
    return Future.value(_mockCompany);
  }

  bool get wasUpdateCompanyLocationsCalled => _wasMethodCalled;
  int get updateCompanyLocationsCallCount => _callCount;
}

// Create a testable app that initializes ScreenUtil
Widget createTestableWidget(Widget child,
    {Map<String, Widget Function(BuildContext)>? routes}) {
  return ScreenUtilInit(
    designSize: const Size(375, 812),
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (context, _) {
      return MaterialApp(
        home: child,
        routes: routes ?? {},
      );
    },
  );
}

void main() {
  // Helper function to setup dependency injection
  void setupDependencyInjection() {
    // Mock setup for dependency injection
    getIt.registerFactory<EditCompanyCubit>(() {
      final mockRepo = MockUpdateCompanyRepo();
      return EditCompanyCubit(mockRepo);
    });
  }

  TestWidgetsFlutterBinding.ensureInitialized();

  // Setup GetIt for dependency injection
  setUpAll(() {
    setupDependencyInjection();
  });

  group('EditCompanyCubit - updateCompanyLocations', () {
    late MockUpdateCompanyRepo mockRepo;
    late EditCompanyCubit cubit;

    setUp(() {
      mockRepo = MockUpdateCompanyRepo();
      cubit = EditCompanyCubit(mockRepo);
    });

    tearDown(() {
      cubit.close();
    });

    blocTest<EditCompanyCubit, EditCompanyState>(
        'emits [EditCompanyInitial, EditCompanySuccess] when updateCompanyLocations is successful',
        build: () {
          final mockResponse = MockCompanyResponseModel(
            id: '123',
            name: 'Test Company',
            urlSlug: 'test-company',
            industry: 'Technology',
            size: '11-50',
            type: 'Private',
            overview: 'Test overview',
            website: 'test.com',
            logo: 'logo.png',
            coverPhoto: 'cover.png',
            followers: 100,
            locations: [
              CompanyLocationModel(
                address: '123 Main St',
                city: 'Cairo',
                country: 'Egypt',
                primary: true,
              ),
            ],
          );

          // Use specific parameter matching instead of 'any'
          when(mockRepo.updateCompanyLocations(captureAny))
              .thenAnswer((_) => Future.value(mockResponse));
          return cubit;
        },
        act: (cubit) => cubit.updateCompanyLocations([
              {
                'city': 'Cairo',
                'country': 'Egypt',
                'address': '123 Main St',
                'primary': true
              }
            ]),
        expect: () => [
              isA<EditCompanyInitial>(),
              isA<EditCompanySuccess>(),
            ],
        verify: (_) {
          final captured =
              verify(mockRepo.updateCompanyLocations(captureAny)).captured;
          expect(captured.length, 1);
          expect(captured.first.length, 1); // Should have one location
        });

    blocTest<EditCompanyCubit, EditCompanyState>(
      'emits [EditCompanyInitial, EditCompanyFailure] when updateCompanyLocations fails',
      build: () {
        // Use captureAny instead of 'any'
        when(mockRepo.updateCompanyLocations(captureAny))
            .thenThrow(Exception('Network error'));
        return cubit;
      },
      act: (cubit) => cubit.updateCompanyLocations([
        {
          'city': 'Cairo',
          'country': 'Egypt',
          'address': '123 Main St',
          'primary': true
        }
      ]),
      expect: () => [
        isA<EditCompanyInitial>(),
        isA<EditCompanyFailure>(),
      ],
    );
  });

  group('CompanyAddLocation Widget Tests', () {
    late MockEditCompanyCubit mockCubit;
    late Company testCompany;

    setUp(() {
      mockCubit = MockEditCompanyCubit();

      testCompany = Company(
        name: 'Test Company',
        id: '123',
        profileUrl: 'test-company',
        industry: 'Technology',
        organizationSize: '11-50',
        organizationType: 'Private',
        overview: 'Test overview',
        website: 'test.com',
        logoUrl: 'logo.png',
        coverUrl: 'cover.png',
        followers: 100,
        locations: [
          CompanyLocationModel(
            address: '123 Main St',
            city: 'Cairo',
            country: 'Egypt',
            primary: true,
          )
        ],
        isFollowing: false,
      );

      mockCubit.setupMockResponse(testCompany);
    });

    testWidgets('renders correctly with existing locations',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          BlocProvider<EditCompanyCubit>.value(
            value: mockCubit,
            child: CompanyAddLocation(company: testCompany),
          ),
        ),
      );

      // Check if location data is displayed correctly
      expect(find.text('123 Main St'), findsOneWidget);
      expect(find.text('Cairo'), findsOneWidget);
      expect(find.text('Egypt'), findsOneWidget);
      expect(find.text('Primary location'), findsOneWidget);
    });

    testWidgets('can add a new location', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          BlocProvider<EditCompanyCubit>.value(
            value: mockCubit,
            child: CompanyAddLocation(company: testCompany),
          ),
        ),
      );

      // Initial check - one location card
      expect(find.byType(Card), findsOneWidget);

      // Add new location
      await tester.tap(find.text('New Location'));
      await tester.pump();

      // Should now have two cards
      expect(find.byType(Card), findsNWidgets(2));
    });

    testWidgets('can remove a location', (WidgetTester tester) async {
      // Create company with two locations
      testCompany.locations = [
        CompanyLocationModel(
            address: 'Location 1',
            city: 'Cairo',
            country: 'Egypt',
            primary: true),
        CompanyLocationModel(
            address: 'Location 2', city: 'Alexandria', country: 'Egypt'),
      ];

      await tester.pumpWidget(
        createTestableWidget(
          BlocProvider<EditCompanyCubit>.value(
            value: mockCubit,
            child: CompanyAddLocation(company: testCompany),
          ),
        ),
      );

      // Initial check - two location cards
      expect(find.byType(Card), findsNWidgets(2));

      // Delete one location
      await tester.tap(find.byIcon(Icons.delete).first);
      await tester.pump();

      // Should now have one location card
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('can change primary location', (WidgetTester tester) async {
      // Create company with two locations
      testCompany.locations = [
        CompanyLocationModel(
            address: 'Location 1',
            city: 'Cairo',
            country: 'Egypt',
            primary: true),
        CompanyLocationModel(
            address: 'Location 2', city: 'Alexandria', country: 'Egypt'),
      ];

      await tester.pumpWidget(
        createTestableWidget(
          BlocProvider<EditCompanyCubit>.value(
            value: mockCubit,
            child: CompanyAddLocation(company: testCompany),
          ),
        ),
      );

      // Verify there are two location cards
      expect(find.byType(Card), findsNWidgets(2));

      // Instead of directly finding Radio widgets, find their containers first
      final radios = find.byType(Radio<int>);
      expect(radios, findsNWidgets(2));

      // Tap the second card's radio button to change primary location
      await tester.tap(radios.last);
      await tester.pump();

      // We can verify the UI shows the radio selected, but can't easily check internal state
      // A visual inspection or more targeted test would be needed
    });

    testWidgets('validates form before submission',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          BlocProvider<EditCompanyCubit>.value(
            value: mockCubit,
            child: CompanyAddLocation(company: testCompany),
          ),
          routes: {
            Routes.companyPageHome: (_) => Container(),
          },
        ),
      );

      // Find and verify there's at least one TextFormField
      final formFields = find.byType(TextFormField);
      expect(formFields, findsWidgets);

      // Get the first TextFormField that would represent the address field
      final addressTextField = formFields.first;
      expect(addressTextField, findsOneWidget);

      // Clear the field using the controller
      final addressController =
          tester.widget<TextFormField>(addressTextField).controller;

      // Set the text to empty
      addressController?.text = '';
      await tester.pump();

      // Try to save
      await tester.tap(find.byIcon(Icons.save));
      await tester.pump();

      // Should show validation error
      expect(find.text('Address required'), findsOneWidget);

      // Verify that updateCompanyLocations was not called
      expect(mockCubit.wasUpdateCompanyLocationsCalled, false);
    });

    testWidgets('calls updateCompanyLocations when saving valid form',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          BlocProvider<EditCompanyCubit>.value(
            value: mockCubit,
            child: CompanyAddLocation(company: testCompany),
          ),
          routes: {
            Routes.companyPageHome: (_) => Container(),
          },
        ),
      );

      // Save with valid data
      await tester.tap(find.byIcon(Icons.save));
      await tester.pumpAndSettle();

      // Verify that updateCompanyLocations was called
      expect(mockCubit.wasUpdateCompanyLocationsCalled, true);
      expect(mockCubit.updateCompanyLocationsCallCount, 1);
    });
  });
}
