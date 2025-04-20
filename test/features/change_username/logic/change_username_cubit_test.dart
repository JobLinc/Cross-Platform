import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:joblinc/features/changeusername/data/repos/change_username_repo.dart';
import 'package:joblinc/features/changeusername/logic/cubit/change_username_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockChangeUsernameRepo extends Mock implements ChangeUsernameRepo {}

void main() {
  late ChangeUsernameCubit changeUsernameCubit;
  late MockChangeUsernameRepo mockChangeUsernameRepo;

  setUp(() {
    mockChangeUsernameRepo = MockChangeUsernameRepo();
    changeUsernameCubit = ChangeUsernameCubit(mockChangeUsernameRepo);
  });

  tearDown(() {
    changeUsernameCubit.close();
  });

  group('ChangeUsernameCubit Tests', () {
    test('Initial state is ChangeUsernameInitial', () {
      expect(changeUsernameCubit.state, isA<ChangeUsernameInitial>());
    });

    blocTest<ChangeUsernameCubit, ChangeUsernameState>(
      'emits [ChangeUsernameLoading, ChangeUsernameSuccess] when change username succeeds',
      build: () {
        when(() => mockChangeUsernameRepo.changeUsername(
              newUsername: any(named: 'newUsername'),
            )).thenAnswer((_) async => Future.value());
        return changeUsernameCubit;
      },
      act: (cubit) => cubit.changeUsername(
        newUsername: 'newusername',
      ),
      expect: () => [
        isA<ChangeUsernameLoading>(),
        isA<ChangeUsernameSuccess>(),
      ],
      verify: (_) {
        verify(() => mockChangeUsernameRepo.changeUsername(
              newUsername: 'newusername',
            )).called(1);
      },
    );

    blocTest<ChangeUsernameCubit, ChangeUsernameState>(
      'emits [ChangeUsernameLoading, ChangeUsernameFailure] when change username fails',
      build: () {
        when(() => mockChangeUsernameRepo.changeUsername(
              newUsername: any(named: 'newUsername'),
            )).thenThrow(Exception('Change failed'));
        return changeUsernameCubit;
      },
      act: (cubit) => cubit.changeUsername(
        newUsername: 'failusername',
      ),
      expect: () => [
        isA<ChangeUsernameLoading>(),
        predicate<ChangeUsernameFailure>(
            (state) => state.error.contains('Change failed')),
      ],
      verify: (_) {
        verify(() => mockChangeUsernameRepo.changeUsername(
              newUsername: 'failusername',
            )).called(1);
      },
    );
  });
}
