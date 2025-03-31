import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:joblinc/features/userProfile/data/service/my_user_profile_api.dart';
import 'package:joblinc/features/userProfile/data/models/user_profile_model.dart';

@GenerateNiceMocks([MockSpec<Dio>()])
import 'get_my_user_profile_test.mocks.dart';

void main() {
  late UserProfileApiService apiService;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    apiService = UserProfileApiService(mockDio);

    final mockOptions = BaseOptions(
      baseUrl: 'https://localhost:3000/api',
    );
    when(mockDio.options).thenReturn(mockOptions);
  });

  group('UserProfileApiService', () {
    final userProfileJson = {
      'firstname': 'John',
      'lastname': 'Doe',
      'headline': 'Software Engineer',
      'about': 'Passionate about coding',
      'profilePicture': 'https://example.com/profile.jpg',
      'coverPicture': 'https://example.com/cover.jpg',
      'numberOfConnections': 150,
      'matualConnections': 5,
    };

    test('getUserProfile should return user profile when API call succeeds', () async {
      // Arrange
      when(mockDio.get('/user/me')).thenAnswer((_) async => 
        Response(
          data: userProfileJson,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/user/me')
        )
      );

      // Act
      final result = await apiService.getUserProfile();

      // Assert
      expect(result, isA<UserProfile>());
      expect(result.firstname, equals('John'));
      expect(result.lastname, equals('Doe'));
      expect(result.headline, equals('Software Engineer'));
      expect(result.numberOfConnections, equals(150));
      verify(mockDio.get('/user/me')).called(1);
    });

    test('getUserProfile should throw exception when API call fails', () async {
      // Arrange
      when(mockDio.get('/user/me')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/user/me'),
          error: 'Network error',
          type: DioExceptionType.connectionError
        )
      );

      // Act & Assert
      expect(
        () => apiService.getUserProfile(),
        throwsA(isA<Exception>())
      );
      verify(mockDio.get('/user/me')).called(1);
    });
  });
}