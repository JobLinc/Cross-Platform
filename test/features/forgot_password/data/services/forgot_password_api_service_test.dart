import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:joblinc/features/forgetpassword/data/services/forgetpassword_api_service.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized(); // Ensure binding is initialized

  late MockDio mockDio;
  late ForgetPasswordApiService forgotPasswordApiService;

  setUp(() {
    mockDio = MockDio();
    forgotPasswordApiService = ForgetPasswordApiService(mockDio);
  });

  group('ForgotPasswordApiService', () {
    test('sendResetEmail() completes successfully on valid email', () async {
      // Arrange
      const email = 'test@example.com';

      when(() => mockDio.post(
            any(),
            data: {'email': email},
          )).thenAnswer((_) async => Response(
            data: {'message': 'Password reset email sent'},
            statusCode: 200,
            requestOptions: RequestOptions(path: '/auth/forgot-password'),
          ));

      // Act
      await forgotPasswordApiService.forgotPassword(email);

      // Assert
      verify(() => mockDio.post(any(), data: {'email': email})).called(1);
    });
    

  });
}
