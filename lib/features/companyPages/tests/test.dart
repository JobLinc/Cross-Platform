// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:bloc_test/bloc_test.dart';
// import '../logic/cubit/create_company_cubit.dart';
// import 'mock_api_service.dart';
// import '../data/company.dart';

// class MockCompanyApiService extends Mock implements CompanyApiService {}

// void main() {
//   late CreateCompanyCubit createCompanyCubit;
//   late MockCompanyApiService mockCompanyApiService;

//   setUp(() {
//     mockCompanyApiService = MockCompanyApiService();
//     createCompanyCubit =
//         CreateCompanyCubit(companyApiService: mockCompanyApiService);
//   });

//   tearDown(() {
//     createCompanyCubit.close();
//   });

//   group('CreateCompanyCubit Tests', () {
//     // Test successful company creation
//     blocTest<CreateCompanyCubit, CreateCompanyState>(
//       'emits [CreateCompanyLoading, CreateCompanySuccess] when company is created successfully',
//       build: () {
//         when(() => mockCompanyApiService.createCompany(any())).thenAnswer(
//           (_) async => Company(
//             id: '67d6f32f1cf460100f20f817',
//             name: 'Test Company',
//             email: 'test@company.io',
//             phone: '111111111',
//             industry: 'test',
//             owner: '67d4227ddd79de769352515c',
//             website: 'website',
//             admins: [],
//             overview: 'overview',
//             logo: 'logo.png',
//             coverPhoto: 'logo.png',
//             founded: DateTime.parse('2000-12-31T22:00:00.000Z'),
//             locations: [],
//             followers: 0,
//             employees: 0,
//             jobs: [],
//             createdAt: DateTime.parse('2025-03-16T15:50:07.776Z'),
//             updatedAt: DateTime.parse('2025-03-16T15:50:07.776Z'),
//           ),
//         );
//         return createCompanyCubit;
//       },
//       act: (cubit) => cubit.createCompany(
//         name: 'Test Company',
//         email: 'test@company.io',
//         phone: '111111111',
//         industry: 'test',
//         overview: 'overview',
//         website: 'website',
//         logo: 'logo.png',
//         coverPhoto: 'logo.png',
//         founded: '01-01-2001',
//         locations: [
//           {
//             'address': 'address',
//             'city': 'city',
//             'country': 'country',
//             'primary': true,
//           },
//         ],
//       ),
//       expect: () => [
//         CreateCompanyLoading(),
//         CreateCompanySuccess(),
//       ],
//     );

//     // Test failure when company creation throws an exception
//     blocTest<CreateCompanyCubit, CreateCompanyState>(
//       'emits [CreateCompanyLoading, CreateCompanyFailure] when company creation fails',
//       build: () {
//         when(() => mockCompanyApiService.createCompany(any()))
//             .thenThrow(Exception('Failed to create company'));
//         return createCompanyCubit;
//       },
//       act: (cubit) => cubit.createCompany(
//         name: 'Test Company',
//         email: 'test@company.io',
//         phone: '111111111',
//         industry: 'test',
//         overview: 'overview',
//         website: 'website',
//         logo: 'logo.png',
//         coverPhoto: 'logo.png',
//         founded: '01-01-2001',
//         locations: [
//           {
//             'address': 'address',
//             'city': 'city',
//             'country': 'country',
//             'primary': true,
//           },
//         ],
//       ),
//       expect: () => [
//         CreateCompanyLoading(),
//         CreateCompanyFailure(),
//       ],
//     );
//   });
// }
