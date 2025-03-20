import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:joblinc/features/connections/data/Repo/UserConnections.dart';
import 'package:joblinc/features/connections/data/Web_Services/MockConnectionApiService.dart';
import 'package:joblinc/features/connections/data/models/connectiondemoModel.dart';
import 'package:joblinc/features/connections/data/models/pendingconnectionsdemomodel.dart';

part 'connections_state.dart';

class ConnectionsCubit extends Cubit<ConnectionsState> {
  //final UserConnectionsRepository connectionsRepository;
  final MockConnectionApiService apiService;

  ConnectionsCubit(this.apiService) : super(ConnectionsInitial());
  late List<UserConnection> connections;
  bool recentlyAddedSelected = true;
  bool firstNameSelected = false;
  bool lastNameSelected = false;
  bool connectedOnappear = true;
  Future<void> fetchConnections() async {
    emit(ConnectionsInitial());

    try {
      final response = await apiService.getConnections();

      if (response.statusCode == 200) {
        final fetchedconnections = (response.data as List)
            .map(
                (item) => UserConnection.fromJson(item as Map<String, dynamic>))
            .toList();
        connections = fetchedconnections;
        emit(ConnectionsLoaded(fetchedconnections));
      } else {
        emit(ConnectionsError("Failed to load connections"));
      }
    } catch (error) {
      emit(ConnectionsError("An error occurred: $error"));
    }
  }

  void Searchclicked() {
    if (state != SearchState()) {
      emit(SearchState());
    }
  }

  void Backclicked() {
    if (state != ConnectionsInitial()) {
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
  }

  List<UserConnection> SortingData() {
    List<UserConnection> data = connections;
    if (firstNameSelected == false && lastNameSelected == false) {
      // connectedOnappear = true;
      // data.sort((a, b) {
      //   DateTime dateA = DateTime.parse(a.connectionStatus"connected_on"!);
      //   DateTime dateB = DateTime.parse(b["connected_on"]!);
      //   return dateB.compareTo(dateA);
      // });
    } else {
      if (firstNameSelected == true) {
        data.sort((a, b) => a.firstname!.compareTo(b.firstname!));
        connectedOnappear = false;
      } else if (lastNameSelected == true) {
        data.sort((a, b) => a.lastname!.compareTo(b.lastname!));
        connectedOnappear = false;
      }
    }
    return data;
  }
}
