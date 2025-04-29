import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:joblinc/features/changepassword/data/repos/change_password_repo.dart';
import 'package:joblinc/features/changepassword/logic/cubit/change_password_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockChangePasswordRepo extends Mock implements ChangePasswordRepo {}

void main() {
  late ChangePasswordCubit changePasswordCubit;
  late MockChangePasswordRepo mockChangePasswordRepo;

  setUp(() {
    mockChangePasswordRepo = MockChangePasswordRepo();
    changePasswordCubit = ChangePasswordCubit(mockChangePasswordRepo);
  });

  tearDown(() {
    changePasswordCubit.close();
  });

  group('ChangePasswordCubit Tests', () {
    test('Initial state is ChangePasswordInitial', () {
      expect(changePasswordCubit.state, isA<ChangePasswordInitial>());
    });

    blocTest<ChangePasswordCubit, ChangePasswordState>(
      'emits [ChangePasswordLoading, ChangePasswordSuccess] when change password succeeds',
      build: () {
        when(() => mockChangePasswordRepo.changePassword(
              oldPassword: any(named: 'oldPassword'),
              newPassword: any(named: 'newPassword'),
            )).thenAnswer((_) async => Future.value());
        return changePasswordCubit;
      },
      act: (cubit) => cubit.changePassword(
        oldPassword: 'oldPass',
        newPassword: 'newPass',
      ),
      expect: () => [
        isA<ChangePasswordLoading>(),
        isA<ChangePasswordSuccess>(),
      ],
      verify: (_) {
        verify(() => mockChangePasswordRepo.changePassword(
              oldPassword: 'oldPass',
              newPassword: 'newPass',
            )).called(1);
      },
    );

    blocTest<ChangePasswordCubit, ChangePasswordState>(
      'emits [ChangePasswordLoading, ChangePasswordFailure] when change password fails',
      build: () {
        when(() => mockChangePasswordRepo.changePassword(
              oldPassword: any(named: 'oldPassword'),
              newPassword: any(named: 'newPassword'),
            )).thenThrow(Exception('Change failed'));
        return changePasswordCubit;
      },
      act: (cubit) => cubit.changePassword(
        oldPassword: 'old',
        newPassword: 'new',
      ),
      expect: () => [
        isA<ChangePasswordLoading>(),
        predicate<ChangePasswordFailure>(
            (state) => state.error.contains('Change failed')),
      ],
      verify: (_) {
        verify(() => mockChangePasswordRepo.changePassword(
              oldPassword: 'old',
              newPassword: 'new',
            )).called(1);
      },
    );
  });
}
