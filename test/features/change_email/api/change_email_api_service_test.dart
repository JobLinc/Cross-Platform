import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:joblinc/features/changeemail/data/services/change_email_api_service.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockDio mockDio;
  late ChangeEmailApiService changeEmailApiService;

  setUp(() {
    mockDio = MockDio();
    changeEmailApiService = ChangeEmailApiService(mockDio);
  });

  group('ChangeEmailApiService', () {
    test('updateEmail() returns data on success', () async {
      // Arrange
      const newEmail = 'new@example.com';
      final responseData = {'success': true, 'email': newEmail};

      when(() => mockDio.put(
            any(),
            data: {'email': newEmail},
          )).thenAnswer((_) async => Response(
                data: responseData,
                statusCode: 200,
                requestOptions: RequestOptions(path: '/user/edit/email'),
              ));

      // Act
      final result = await changeEmailApiService.updateEmail(newEmail);

      // Assert
      expect(result, responseData);
    });

    test('updateEmail() throws error message on DioException', () async {
      // Arrange
      const newEmail = 'new@example.com';
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/user/edit/email'),
        response: Response(
          data: {'message': 'Invalid email address'},
          statusCode: 400,
          requestOptions: RequestOptions(path: '/user/edit/email'),
        ),
        type: DioExceptionType.badResponse,
      );

      when(() => mockDio.put(
            any(),
            data: {'email': newEmail},
          )).thenThrow(dioError);

      // Act & Assert
      expect(
        () async => await changeEmailApiService.updateEmail(newEmail),
        throwsA('Invalid email address'),
      );
    });

    test('updateEmail() throws generic error on unexpected exception', () async {
      // Arrange
      const newEmail = 'new@example.com';

      when(() => mockDio.put(
            any(),
            data: {'email': newEmail},
          )).thenThrow(Exception('Unexpected error'));

      // Act & Assert
      expect(
        () async => await changeEmailApiService.updateEmail(newEmail),
        throwsA('Something went wrong. Please try again.'),
      );
    });
  });
}
