import 'package:flutter_test/flutter_test.dart';
import 'package:joblinc/features/changeemail/data/repos/change_email_repo.dart';
import 'package:joblinc/features/changeemail/logic/cubit/change_email_cubit.dart';
import 'package:joblinc/features/changeemail/logic/cubit/change_email_state.dart';
import 'package:mocktail/mocktail.dart';

class MockChangeEmailRepo extends Mock implements ChangeEmailRepo {}

void main() {
  late ChangeEmailCubit cubit;
  late MockChangeEmailRepo repository;

  setUp(() {
    repository = MockChangeEmailRepo();
    cubit = ChangeEmailCubit(repository);
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state is ChangeEmailInitial', () {
    expect(cubit.state, isA<ChangeEmailInitial>());
  });

  test('emits [Loading, Failure] when updateEmail fails', () async {
    when(() => repository.updateEmail(any()))
        .thenThrow(Exception('error'));

    final expected = [
      isA<ChangeEmailLoading>(),
      isA<ChangeEmailFailure>(),
    ];

    expectLater(cubit.stream, emitsInOrder(expected));

    await cubit.updateEmail('fail@example.com');
  });


}
