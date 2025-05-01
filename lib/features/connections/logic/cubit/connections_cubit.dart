import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:joblinc/core/widgets/custom_snackbar.dart';
import 'package:joblinc/features/connections/data/Repo/connections_repo.dart';
import 'package:joblinc/features/connections/data/Web_Services/MockConnectionApiService.dart';
import 'package:joblinc/features/connections/data/models/connectiondemoModel.dart';
import 'package:joblinc/features/connections/data/models/pendingconnectionsdemomodel.dart';

part 'connections_state.dart';

class ConnectionsCubit extends Cubit<ConnectionsState> {
  final UserConnectionsRepository connectionsRepository;
  //final MockConnectionApiService apiService;

  ConnectionsCubit(this.connectionsRepository) : super(ConnectionsInitial());
  late List<UserConnection> connections;
  bool recentlyAddedSelected = true;
  bool firstNameSelected = false;
  bool lastNameSelected = false;
  bool connectedOnappear = true;
  Future<void> fetchConnections() async {
    emit(ConnectionsInitial());

    try {
      final response = await connectionsRepository.getConnections();
      if (!isClosed) {
        emit(ConnectionsLoaded(response));
        connections = response;
      }
      // if (response.statusCode == 200) {
      //   final fetchedconnections = (response.data as List)
      //       .map(
      //           (item) => UserConnection.fromJson(item as Map<String, dynamic>))
      //       .toList();
      //   connections = fetchedconnections.reversed.toList();
      //   if (!isClosed) {
      //     emit(ConnectionsLoaded(fetchedconnections.reversed.toList()));
      //   }
      // } else {
      //   if (!isClosed) {
      //     emit(ConnectionsError("Failed to load connections"));
      //   }
      // }
    } catch (error) {
      if (!isClosed) {
        emit(ConnectionsError("An error occurred: $error"));
      }
    }
  }

  void removeConnection(UserConnection connection, BuildContext context) async {
    try {
      final response = await connectionsRepository.changeConnectionStatus(
          connection.userId, "Canceled");
      if (response.statusCode == 200) {
        CustomSnackBar.show(
            context: context,
            message: "connection removed succefully ",
            type: SnackBarType.success);
        fetchConnections();
      } else {
        CustomSnackBar.show(
            context: context,
            message: "connection removal failed ",
            type: SnackBarType.error);
        fetchConnections();
      }
    } catch (error) {
      if (!isClosed) {
        CustomSnackBar.show(
            context: context,
            message: error.toString(),
            type: SnackBarType.error);
      }
    }
  }

  void unblockConnection(String userId, BuildContext context) async {
    try {
      final response = await connectionsRepository.changeConnectionStatus(
          userId, "Unblocked");
      if (response.statusCode == 200) {
        CustomSnackBar.show(
            context: context,
            message: "connection Blocked succefully ",
            type: SnackBarType.success);
        fetchBlockedConnections();
      } else {
        CustomSnackBar.show(
            context: context,
            message: "connection Blocking failed ",
            type: SnackBarType.error);
        fetchBlockedConnections();
      }
    } catch (error) {
      if (!isClosed) {
        CustomSnackBar.show(
            context: context,
            message: error.toString(),
            type: SnackBarType.error);
      }
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

  Future<void> fetchUserConnections(String userId) async {
    emit(ConnectionsInitial());

    try {
      final response = await connectionsRepository.getUserConnections(userId);
      if (!isClosed) {
        emit(ConnectionsLoaded(response));
      }
      // Optionally store the fetched connections if needed
      // userConnections = response;
    } catch (error) {
      if (!isClosed) {
        emit(ConnectionsError("An error occurred: $error"));
      }
    }
  }

  Future<void> fetchBlockedConnections() async {
    emit(ConnectionsInitial());

    try {
      final response = await connectionsRepository.getBlockedConnections();
      if (!isClosed) {
        emit(ConnectionsLoaded(response));
        connections = response;
      }
    } catch (error) {
      if (!isClosed) {
        emit(ConnectionsError("An error occurred: $error"));
      }
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
