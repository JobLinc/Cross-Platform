import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:joblinc/features/companyPages/data/data/services/getmycompany.dart';
import 'package:joblinc/features/companyPages/data/data/models/company_model.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late CompanyApiService apiService;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    apiService = CompanyApiService(mockDio);
    registerFallbackValue(RequestOptions(path: '/'));
  });

  final testUrl = '/companies/me';
  final validResponse = {
    'id': 'comp_123',
    'name': 'Tech Corp',
    'urlSlug': 'https://techcorp.com',
    'industry': 'Technology, Information and Internet',
    'size': '11-50 employees',
    'type': 'Privately Held',
    'overview': 'Innovative tech company',
    'website': 'https://techcorp.com',
    'profilePictureUrl': 'https://techcorp.com/logo.png',
  };

  group('getCurrentCompany', () {
    test('should return CompanyResponse with valid data', () async {
      // Arrange
      when(() => mockDio.get(testUrl)).thenAnswer(
        (_) async => Response(
          data: validResponse,
          statusCode: 200,
          requestOptions: RequestOptions(path: testUrl),
        ),
      );

      // Act
      final result = await apiService.getCurrentCompany();

      // Assert
      expect(result, isA<CompanyResponse>());
      expect(result.name, equals('Tech Corp'));
      expect(result.urlSlug, equals('https://techcorp.com'));
      expect(result.industry, equals('Technology, Information and Internet'));
      verify(() => mockDio.get(testUrl)).called(1);
    });

    test('should throw FormatException when missing required fields', () async {
      // Arrange
      final invalidResponse = {...validResponse}..remove('name');
      when(() => mockDio.get(testUrl)).thenAnswer(
        (_) async => Response(
          data: invalidResponse,
          statusCode: 200,
          requestOptions: RequestOptions(path: testUrl),
        ),
      );

      // Act & Assert
      expect(
        () => apiService.getCurrentCompany(),
        throwsA(isA<FormatException>()),
      );
    });

    test('should throw Exception on non-200 status', () async {
      // Arrange
      when(() => mockDio.get(testUrl)).thenAnswer(
        (_) async => Response(
          data: validResponse,
          statusCode: 404,
          requestOptions: RequestOptions(path: testUrl),
        ),
      );

      // Act & Assert
      expect(
        () => apiService.getCurrentCompany(),
        throwsA(isA<Exception>()),
      );
    });

    test('should throw Exception when response data is null', () async {
      // Arrange
      when(() => mockDio.get(testUrl)).thenAnswer(
        (_) async => Response(
          data: null,
          statusCode: 200,
          requestOptions: RequestOptions(path: testUrl),
        ),
      );

      // Act & Assert
      expect(
        () => apiService.getCurrentCompany(),
        throwsA(isA<Exception>()),
      );
    });

    test('should throw Exception on DioException', () async {
      // Arrange
      when(() => mockDio.get(testUrl)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: testUrl),
          error: 'Connection failed',
        ),
      );

      // Act & Assert
      expect(
        () => apiService.getCurrentCompany(),
        throwsA(isA<Exception>()),
      );
    });

    test('should throw FormatException on malformed JSON', () async {
      // Arrange
      when(() => mockDio.get(testUrl)).thenAnswer(
        (_) async => Response(
          data: {'invalid': 'data'},
          statusCode: 200,
          requestOptions: RequestOptions(path: testUrl),
        ),
      );

      // Act & Assert
      expect(
        () => apiService.getCurrentCompany(),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
