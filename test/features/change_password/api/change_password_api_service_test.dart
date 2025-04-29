import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:joblinc/features/changepassword/data/services/change_password_api_service.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockDio mockDio;
  late ChangePasswordApiService changePasswordApiService;

  setUp(() {
    mockDio = MockDio();
    changePasswordApiService = ChangePasswordApiService(mockDio);
  });

  group('ChangePasswordApiService', () {
    test('changePassword() returns data on success', () async {
      // Arrange
      const oldPassword = 'oldPass';
      const newPassword = 'newPass';
      const refreshToken = 'refreshToken';
      final responseData = {'success': true};

      when(() => mockDio.post(
            any(),
            data: {
              "oldPassword": oldPassword,
              "newPassword": newPassword,
              "refreshToken": refreshToken,
            },
          )).thenAnswer((_) async => Response(
                data: responseData,
                statusCode: 200,
                requestOptions: RequestOptions(path: '/auth/change-password'),
              ));

      // Act
      final result = await changePasswordApiService.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
        refreshToken: refreshToken,
      );

      // Assert
      expect(result, responseData);
    });

    test('changePassword() throws error message on DioException', () async {
      // Arrange
      const oldPassword = 'oldPass';
      const newPassword = 'newPass';
      const refreshToken = 'refreshToken';

      final dioError = DioException(
        requestOptions: RequestOptions(path: '/auth/change-password'),
        response: Response(
          data: {'message': 'Invalid input data'},
          statusCode: 400,
          requestOptions: RequestOptions(path: '/auth/change-password'),
        ),
        type: DioExceptionType.badResponse,
      );

      when(() => mockDio.post(
            any(),
            data: {
              "oldPassword": oldPassword,
              "newPassword": newPassword,
              "refreshToken": refreshToken,
            },
          )).thenThrow(dioError);

      // Act & Assert
      expect(
        () async => await changePasswordApiService.changePassword(
          oldPassword: oldPassword,
          newPassword: newPassword,
          refreshToken: refreshToken,
        ),
        throwsA('Invalid input data'),
      );
    });

    test('changePassword() throws generic error on unexpected exception', () async {
      // Arrange
      const oldPassword = 'oldPass';
      const newPassword = 'newPass';
      const refreshToken = 'refreshToken';

      when(() => mockDio.post(
            any(),
            data: {
              "oldPassword": oldPassword,
              "newPassword": newPassword,
              "refreshToken": refreshToken,
            },
          )).thenThrow(Exception('Unexpected error'));

      // Act & Assert
      expect(
        () async => await changePasswordApiService.changePassword(
          oldPassword: oldPassword,
          newPassword: newPassword,
          refreshToken: refreshToken,
        ),
        throwsA('Unexpected error occurred'),
      );
    });
  });
}
