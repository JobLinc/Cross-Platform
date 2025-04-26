import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:joblinc/features/login/data/models/login_response_model.dart';
import 'package:joblinc/features/login/logic/cubit/login_cubit.dart';
import 'package:joblinc/features/login/logic/cubit/login_state.dart';
import 'package:joblinc/features/login/data/repos/login_repo.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginRepo extends Mock implements LoginRepo {}

void main() {
  late LoginCubit loginCubit;
  late MockLoginRepo mockLoginRepo;

  setUp(() {
    mockLoginRepo = MockLoginRepo();
    loginCubit = LoginCubit(mockLoginRepo);
  });

  tearDown(() {
    loginCubit.close();
  });

  group('LoginCubit Tests', () {
    test('Initial state is LoginInitial', () {
      expect(loginCubit.state, isA<LoginInitial>());
    });

    blocTest<LoginCubit, LoginState>(
      'emits [LoginLoading, LoginSuccess] when login succeeds',
      build: () {
        when(() => mockLoginRepo.login(any(), any())).thenAnswer((_) async =>
            LoginResponseModel(
                accessToken: "token",
                refreshToken: "refreshToken",
                userId: "userId",
                role: 1,
                confirmed: true,
                email: "email"));
        return loginCubit;
      },
      act: (cubit) => cubit.login('test@example.com', 'password123'),
      expect: () => [
        isA<LoginLoading>(),
        isA<LoginSuccess>(),
      ],
      verify: (_) {
        verify(() => mockLoginRepo.login('test@example.com', 'password123'))
            .called(1);
      },
    );

    blocTest<LoginCubit, LoginState>(
      'emits [LoginLoading, LoginFailure] when login fails',
      build: () {
        when(() => mockLoginRepo.login(any(), any()))
            .thenThrow(Exception('Invalid credentials'));
        return loginCubit;
      },
      act: (cubit) => cubit.login('wrong@example.com', 'wrongpassword'),
      expect: () => [
        isA<LoginLoading>(),
        predicate<LoginFailure>(
            (state) => state.error.contains('Invalid credentials')),
      ],
      verify: (_) {
        verify(() => mockLoginRepo.login('wrong@example.com', 'wrongpassword'))
            .called(1);
      },
    );
  });
}
