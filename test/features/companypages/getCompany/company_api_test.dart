import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:joblinc/features/companypages/data/data/services/getmycompany.dart';
import 'package:joblinc/features/companypages/data/data/models/company_model.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late CompanyApiService apiService;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    apiService = CompanyApiService(mockDio);
    registerFallbackValue(RequestOptions(path: '/'));
  });

  final companyId = 'comp_123';
  final testUrl = '/companies?id=$companyId';
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

  group('getCompanyById', () {
    test('should throw Exception on non-200 status', () async {
      // Arrange
      when(() => mockDio.get(
            testUrl,
            options: any(named: 'options'),
          )).thenAnswer(
        (_) async => Response(
          data: validResponse,
          statusCode: 404,
          requestOptions: RequestOptions(path: testUrl),
        ),
      );

      // Act & Assert
      expect(
        () => apiService.getCompanyById(companyId),
        throwsA(isA<Exception>()),
      );
    });

    test('should throw Exception when response data is null', () async {
      // Arrange
      when(() => mockDio.get(
            testUrl,
            options: any(named: 'options'),
          )).thenAnswer(
        (_) async => Response(
          data: null,
          statusCode: 200,
          requestOptions: RequestOptions(path: testUrl),
        ),
      );

      // Act & Assert
      expect(
        () => apiService.getCompanyById(companyId),
        throwsA(isA<Exception>()),
      );
    });

    test('should throw Exception on DioException', () async {
      // Arrange
      when(() => mockDio.get(
            testUrl,
            options: any(named: 'options'),
          )).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: testUrl),
          error: 'Connection failed',
        ),
      );

      // Act & Assert
      expect(
        () => apiService.getCompanyById(companyId),
        throwsA(isA<Exception>()),
      );
    });
  });
}
