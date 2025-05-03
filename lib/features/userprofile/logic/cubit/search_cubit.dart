import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/features/connections/data/Repo/connections_repo.dart';
import 'package:joblinc/features/userprofile/data/models/user_profile_model.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final UserConnectionsRepository repository;
  Timer? _debounce;

  SearchCubit(this.repository) : super(SearchInitial());

  void search(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.isEmpty) {
        emit(SearchInitial());
        return;
      }

      emit(SearchLoading());
      try {
        final users = await repository.searchUsers(query);
        emit(SearchLoaded(users));
      } catch (e) {
        emit(SearchError(e.toString()));
      }
    });
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
