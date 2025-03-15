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
  bool connectedOnappear = true;
  void Searchclicked() {
    print("🚀 ConnectionsCubit switched to with state: $state");
    if (state != SearchState()) {
      // ✅ Prevents emitting the same state twice
      emit(SearchState());
    }
  }

  void Backclicked() {
    print("🚀 ConnectionsCubit switched to with state: $state");
    if (state != ConnectionsInitial()) {
      // ✅ Prevents emitting the same state twice
      emit(ConnectionsInitial());
    }
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
    emit(ChooseSort());
  }

  List<Map<String, String>> SortingData() {
    List<Map<String, String>> data = connections;
    if (firstNameSelected == false && lastNameSelected == false) {
      connectedOnappear = true;
      data.sort((a, b) {
        DateTime dateA = DateTime.parse(a["connected_on"]!);
        DateTime dateB = DateTime.parse(b["connected_on"]!);
        return dateB.compareTo(dateA);
      });
    } else {
      if (firstNameSelected == true) {
        data.sort((a, b) => a['firstname']!.compareTo(b['firstname']!));
        connectedOnappear = false;
      } else if (lastNameSelected == true) {
        data.sort((a, b) => a['lastname']!.compareTo(b['lastname']!));
        connectedOnappear = false;
      }
    }
    return data;
  }

  void showmodalclosed() {
    emit(SortData());
  }
}
