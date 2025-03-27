import 'package:joblinc/features/companyPages/data/data/repos/getmycompany_repo.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:dio/dio.dart';
import 'package:joblinc/features/companyPages/data/data/company.dart';
import 'package:joblinc/features/companyPages/data/data/services/getmycompany.dart';
import 'package:joblinc/features/companyPages/data/data/models/company_model.dart';

class MockDio extends Mock implements Dio {}
class MockCompanyApiService extends Mock implements CompanyApiService {}

void main() {
  late CompanyRepositoryImpl repository;
  late CompanyApiService mockApiService;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    mockApiService = MockCompanyApiService();
    repository = CompanyRepositoryImpl(mockApiService);
  });

  // Test data
  final mockApiResponse = CompanyResponse(
    id: 'comp_123',
    name: 'Tech Corp',
    addressUrl: 'https://techcorp.com',
    industry: 'Technology, Information and Internet',
    size: '11-50 employees',
    type: 'Privately Held',
    overview: 'Innovative tech company',
    website: 'https://techcorp.com',
    profilePictureUrl: 'https://techcorp.com/logo.png',
  );

  group('getCurrentCompany', () {
    test('should convert CompanyResponse to Company with proper enum mapping', () async {
      // Arrange
      when(() => mockDio.get('/companies/me'))
          .thenAnswer((_) async => Response(
                requestOptions: RequestOptions(path: '/companies/me'),
                data: mockApiResponse.toJson(),
                statusCode: 200,
              ));

      // Act
      final result = await repository.getCurrentCompany();

      // Assert
      expect(result, isA<Company>());
      expect(result.name, equals('Tech Corp'));
      expect(result.profileUrl, equals('https://techcorp.com'));
      expect(result.industry, equals(Industry.technology));
      expect(result.organizationSize, equals(OrganizationSize.elevenToFifty));
      expect(result.organizationType, equals(OrganizationType.privatelyHeld));
      expect(result.logoUrl, equals('https://techcorp.com/logo.png'));
    });

    test('should throw when enum conversion fails', () async {
      // Arrange
      final invalidResponse = CompanyResponse(
        id: 'comp_123',
        name: 'Tech Corp',
        addressUrl: 'https://techcorp.com',
        industry: 'Invalid Industry',
        size: 'Invalid Size',
        type: 'Invalid Type',
        overview: 'Innovative tech company',
        website: 'https://techcorp.com',
      );
      
      when(() => mockDio.get('/companies/me'))
          .thenAnswer((_) async => Response(
                requestOptions: RequestOptions(path: '/companies/me'),
                data: invalidResponse.toJson(),
                statusCode: 200,
              ));

      // Act & Assert
      expect(
        () => repository.getCurrentCompany(),
        throwsA(isA<Exception>()),
      );
    });

    test('should handle null optional fields', () async {
      // Arrange
      final minimalResponse = CompanyResponse(
        id: 'comp_123',
        name: 'Minimal Corp',
        addressUrl: 'https://minimal.com',
        industry: 'IT Services and IT Consulting',
        size: '2-10 employees',
        type: 'Public Company',
        overview: '',
        website: '',
        profilePictureUrl: null,
      );
      
      when(() => mockDio.get('/companies/me'))
          .thenAnswer((_) async => Response(
                requestOptions: RequestOptions(path: '/companies/me'),
                data: minimalResponse.toJson(),
                statusCode: 200,
              ));

      // Act
      final result = await repository.getCurrentCompany();

      // Assert
      expect(result.overview, isEmpty);
      expect(result.website, isEmpty);
      expect(result.logoUrl, isNull);
    });

    test('should propagate API service exceptions', () async {
      // Arrange
      when(() => mockDio.get('/companies/me'))
          .thenThrow(DioException(
            requestOptions: RequestOptions(path: '/companies/me'),
            error: 'Network error',
          ));

      // Act & Assert
      expect(
        () => repository.getCurrentCompany(),
        throwsA(isA<Exception>()),
      );
    });

    test('should handle non-200 status codes', () async {
      // Arrange
      when(() => mockDio.get('/companies/me'))
          .thenAnswer((_) async => Response(
                requestOptions: RequestOptions(path: '/companies/me'),
                statusCode: 404,
              ));

      // Act & Assert
      expect(
        () => repository.getCurrentCompany(),
        throwsA(isA<Exception>()),
      );
    });
  });
}