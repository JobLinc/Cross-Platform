import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:joblinc/features/signup/data/models/register_request_model.dart';
import 'package:joblinc/features/signup/data/models/register_response_model.dart';
import 'package:joblinc/features/signup/data/services/register_api_service.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized(); // Ensure binding is initialized

  late MockDio mockDio;
  late RegisterApiService registerApiService;

  setUp(() {
    mockDio = MockDio();
    registerApiService = RegisterApiService(mockDio);
  });

  group('RegisterApiService', () {
    test('register() returns RegisterResponse on success', () async {
      // Arrange
      final requestModel = RegisterRequestModel(
        firstname: 'Test',
        lastname: 'User',
        email: 'test@example.com',
        password: 'password123',
        country: 'Country',
        city: 'City',
        phoneNumber: '1234567890',
      );

      final responseData = {
        'accessToken': 'mockAccessToken',
        'refreshToken': 'mockRefreshToken',
        'userId': '123',
        'role': 1,
      };

      when(() => mockDio.post(
            any(),
            data: requestModel.toJson(),
          )).thenAnswer((_) async => Response(
            data: responseData,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/auth/register'),
          ));

      // Act
      final response = await registerApiService.register(requestModel);

      // Assert
      expect(response, isA<RegisterResponse>());
      expect(response.accessToken, 'mockAccessToken');
      expect(response.refreshToken, 'mockRefreshToken');
      expect(response.userId, '123');
      expect(response.role, 1);
    });



    test('register() throws Exception on unexpected error', () async {
      // Arrange
      final requestModel = RegisterRequestModel(
        firstname: 'Test',
        lastname: 'User',
        email: 'test@example.com',
        password: 'password123',
        country: 'Country',
        city: 'City',
        phoneNumber: '1234567890',
      );

      when(() => mockDio.post(
            any(),
            data: requestModel.toJson(),
          )).thenThrow(Exception('Unexpected error'));

      // Act & Assert
      expect(
        () async => await registerApiService.register(requestModel),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Unexpected error'),
        )),
      );
    });
  });
}
