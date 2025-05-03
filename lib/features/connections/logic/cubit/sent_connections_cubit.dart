import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/core/widgets/custom_snackbar.dart';
import 'package:joblinc/features/connections/data/Repo/connections_repo.dart';
import 'package:joblinc/features/connections/data/Web_Services/MockConnectionApiService.dart';
import 'package:joblinc/features/connections/data/models/connectiondemoModel.dart';

part 'sent_connections_state.dart';

class SentConnectionsCubit extends Cubit<SentConnectionsState> {
  final UserConnectionsRepository connectionsRepository;
  SentConnectionsCubit(this.connectionsRepository)
      : super(SentConnectionsInitial());

  Future<void> fetchSentInvitations() async {
    emit(SentConnectionsInitial());

    try {
      final response = await connectionsRepository.getSentInvitations();
      if (!isClosed) {
        emit(SentConnectionsLoaded(response));
      }
    } catch (error) {
      if (!isClosed) {
        emit(SentConnectionsError("An error occurred: $error"));
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
            message: "connection withdrawn succefully ",
            type: SnackBarType.success);
        fetchSentInvitations();
      } else {
        CustomSnackBar.show(
            context: context,
            message: "connection withdrawing failed ",
            type: SnackBarType.error);
        fetchSentInvitations();
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
  // void withdrawclicked(String userID) async {
  //   Response respone = await apiService.removeSentConnection(userID);
  //   if (respone.statusCode != 200) {
  //     if (!isClosed) {
  //       emit(SentConnectionsError("Failed to remove the connections"));
  //       return;
  //     }
  //   } else {
  //     if (!isClosed) {
  //       emit(SentConnectionsInitial());
  //     }
  //   }
  // }
}
