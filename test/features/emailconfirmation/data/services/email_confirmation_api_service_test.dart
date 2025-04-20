import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:joblinc/features/emailconfirmation/data/services/email_confirmation_api_service.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockDio mockDio;
  late EmailConfirmationApiService emailConfirmationApiService;

  setUp(() {
    mockDio = MockDio();
    emailConfirmationApiService = EmailConfirmationApiService(mockDio);
  });

  group('EmailConfirmationApiService', () {
    test('sendConfirmationEmail() returns data on success', () async {
      // Arrange
      const email = 'test@example.com';
      final responseData = {'success': true};

      when(() => mockDio.post(
            any(),
            data: {'email': email},
          )).thenAnswer((_) async => Response(
            data: responseData,
            statusCode: 200,
            requestOptions:
                RequestOptions(path: '/auth/send-confirmation-email'),
          ));

      // Act
      final result =
          await emailConfirmationApiService.sendConfirmationEmail(email);

      // Assert
      expect(result, responseData);
    });

    test('sendConfirmationEmail() throws error message on DioException',
        () async {
      // Arrange
      const email = 'test@example.com';
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/auth/send-confirmation-email'),
        response: Response(
          data: {'message': 'Invalid email'},
          statusCode: 400,
          requestOptions: RequestOptions(path: '/auth/send-confirmation-email'),
        ),
        type: DioExceptionType.badResponse,
      );

      when(() => mockDio.post(
            any(),
            data: {'email': email},
          )).thenThrow(dioError);

      // Act & Assert
      expect(
        () async =>
            await emailConfirmationApiService.sendConfirmationEmail(email),
        throwsA('Invalid email'),
      );
    });

    test('sendConfirmationEmail() throws generic error on unexpected exception',
        () async {
      // Arrange
      const email = 'test@example.com';

      when(() => mockDio.post(
            any(),
            data: {'email': email},
          )).thenThrow(Exception('Unexpected error'));

      // Act & Assert
      expect(
        () async =>
            await emailConfirmationApiService.sendConfirmationEmail(email),
        throwsA('Something went wrong. Please try again.'),
      );
    });

    test('confirmEmail() returns data on success', () async {
      // Arrange
      const email = 'test@example.com';
      const token = 'token';
      const otp = '123456';
      final responseData = {'verified': true};

      when(() => mockDio.post(
            any(),
            data: {
              'email': email,
              'token': token,
              'otp': otp,
            },
          )).thenAnswer((_) async => Response(
            data: responseData,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/auth/confirm-email'),
          ));

      // Act
      final result = await emailConfirmationApiService.confirmEmail(
        email: email,
        token: token,
        otp: otp,
      );

      // Assert
      expect(result, responseData);
    });

    test('confirmEmail() throws error message on DioException', () async {
      // Arrange
      const email = 'test@example.com';
      const token = 'token';
      const otp = '123456';
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/auth/confirm-email'),
        response: Response(
          data: {'message': 'Invalid OTP'},
          statusCode: 400,
          requestOptions: RequestOptions(path: '/auth/confirm-email'),
        ),
        type: DioExceptionType.badResponse,
      );

      when(() => mockDio.post(
            any(),
            data: {
              'email': email,
              'token': token,
              'otp': otp,
            },
          )).thenThrow(dioError);

      // Act & Assert
      expect(
        () async => await emailConfirmationApiService.confirmEmail(
          email: email,
          token: token,
          otp: otp,
        ),
        throwsA('Invalid OTP'),
      );
    });

    test('confirmEmail() throws generic error on unexpected exception',
        () async {
      // Arrange
      const email = 'test@example.com';
      const token = 'token';
      const otp = '123456';

      when(() => mockDio.post(
            any(),
            data: {
              'email': email,
              'token': token,
              'otp': otp,
            },
          )).thenThrow(Exception('Unexpected error'));

      // Act & Assert
      expect(
        () async => await emailConfirmationApiService.confirmEmail(
          email: email,
          token: token,
          otp: otp,
        ),
        throwsA('Something went wrong. Please try again.'),
      );
    });
  });
}
