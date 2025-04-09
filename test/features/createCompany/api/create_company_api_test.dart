import 'package:flutter_test/flutter_test.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/features/companyPages/data/data/models/createcompany_response.dart';
import 'package:joblinc/features/companyPages/data/data/services/createcompany_api_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';

// Mock Classes
class MockDio extends Mock implements Dio {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockDio mockDio;
  late CreateCompanyApiService createCompanyApiService;

  setUpAll(() async {
    await setupGetIt();
  });

  setUp(() {
    mockDio = MockDio();
    createCompanyApiService = CreateCompanyApiService(mockDio);
  });

  test('createCompany() returns CreateCompanyResponse on success', () async {
    final responseData = {
      'accessToken': 'mockAccessToken',
      'refreshToken': 'mockRefreshToken',
      'userId': '123',
      'role': 1,
    };

    when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
      (_) async => Response(
        data: responseData,
        statusCode: 200,
        requestOptions: RequestOptions(path: ''),
      ),
    );

    final response = await createCompanyApiService.createCompany(
      'Test Company',
        'test-company',
        'Software Development',
        '0-1 employees',
        'privately held',
        'overview',
        'https://www.linkedin.com',
    );

    expect(response, isA<CreateCompanyResponse>());
  });

  test('createCompany() throws DioException on failure', () async {
    when(() => mockDio.post(any(), data: any(named: 'data'))).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          data: {'message': 'Company creation failed'},
          statusCode: 400,
          requestOptions: RequestOptions(path: ''),
        ),
      ),
    );

    expect(
      () async => await createCompanyApiService.createCompany(
        'Test Company',
        'test-company',
        'Software Development',
        '0-1 employees',
        'privately held',
        'overview',
        'https://www.linkedin.com',
      ),
      throwsA(isA<DioException>()),
    );
  });

  test('createCompany() handles network error gracefully', () async {
    when(() => mockDio.post(any(), data: any(named: 'data'))).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.connectionTimeout,
      ),
    );

    try {
      await createCompanyApiService.createCompany(
        'Test Company',
        'test-company',
        'Software Development',
        '0-1 employees',
        'privately held',
        'overview',
        'https://www.linkedin.com',
      );
    } catch (e) {
      expect(e, isA<DioException>());
      final dioError = e as DioException;
      expect(dioError.type, DioExceptionType.connectionTimeout);
    }
  });

  test('createCompany() handles invalid email format error', () async {
    when(() => mockDio.post(any(), data: any(named: 'data'))).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          data: {'message': 'Invalid email format'},
          statusCode: 422,
          requestOptions: RequestOptions(path: ''),
        ),
      ),
    );

    expect(
      () async => await createCompanyApiService.createCompany(
        'Test Company',
        'test-company',
        'Software Development',
        '0-1 employees',
        'privately held',
        'overview',
        'https://www.linkedin.com',
      ),
      throwsA(predicate((e) =>
          e is DioException &&
          e.response?.statusCode == 422 &&
          e.response?.data['message'] == 'Invalid email format')),
    );
  });

  test('createCompany() handles unauthorized access error', () async {
    when(() => mockDio.post(any(), data: any(named: 'data'))).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          data: {'message': 'Unauthorized'},
          statusCode: 401,
          requestOptions: RequestOptions(path: ''),
        ),
      ),
    );

    expect(
      () async => await createCompanyApiService.createCompany(
        'Test Company',
        'test-company',
        'Software Development',
        '0-1 employees',
        'privately held',
        'overview',
        'https://www.linkedin.com',
      ),
      throwsA(predicate((e) =>
          e is DioException &&
          e.response?.statusCode == 401 &&
          e.response?.data['message'] == 'Unauthorized')),
    );
  });
}
