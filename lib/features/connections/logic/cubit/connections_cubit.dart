import 'package:bloc/bloc.dart';
import 'package:joblinc/features/connections/data/connectiondemoModel.dart';
import 'package:meta/meta.dart';

part 'connections_state.dart';

class ConnectionsCubit extends Cubit<ConnectionsState> {
  ConnectionsCubit() : super(ConnectionsInitial()) {
    print("🚀 ConnectionsCubit initialized with state: $state");
  }
  List<Map<String, String>> connections = GetConnections();
  bool recentlyAddedSelected = true;
  bool firstNameSelected = false;
  bool lastNameSelected = false;
  void Searchclicked() {
    print("🚀 ConnectionsCubit switched to with state: $state");
    emit(SearchState());
  }

  void Backclicked() {
    print("🚀 ConnectionsCubit switched to with state: $state");
    emit(ConnectionsInitial());
  }

  void buttonPressed(String name) {
    if (name == "Recently added") {
      recentlyAddedSelected = !recentlyAddedSelected;
      firstNameSelected = false;
      lastNameSelected = false;
    } else if (name == "First name") {
      firstNameSelected = !firstNameSelected;
      recentlyAddedSelected = false;
      lastNameSelected = false;
    } else if (name == "Last name") {
      lastNameSelected = !lastNameSelected;
      firstNameSelected = false;
      recentlyAddedSelected = false;
    }
    emit(SortState());
  }
}
