import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/core/widgets/custom_snackbar.dart';
import 'package:joblinc/features/connections/data/Repo/connections_repo.dart';
import 'package:joblinc/features/connections/data/Web_Services/MockConnectionApiService.dart';
import 'package:joblinc/features/connections/data/models/connectiondemoModel.dart';
import 'package:joblinc/features/connections/data/models/pendingconnectionsdemomodel.dart';
import 'package:meta/meta.dart';

part 'invitations_state.dart';

class InvitationsCubit extends Cubit<InvitationsState> {
  final UserConnectionsRepository connectionsRepository;
  InvitationsCubit(this.connectionsRepository) : super(InvitationsInitial());
  Future<void> fetchPendingInvitations() async {
    emit(InvitationsInitial());

    try {
      final response = await connectionsRepository.getInvitations();

      if (!isClosed) {
        emit(InvitationsLoaded(response));
      }
    } catch (error) {
      if (!isClosed) {
        emit(InvitationsError("An error occurred: $error"));
      }
    }
  }

  void respondToConnectionInvitation(
      UserConnection connection, String status, BuildContext context) async {
    try {
      final response = await connectionsRepository.respondToConnection(
        connection.userId,
        status,
      );

      if (response.statusCode == 200) {
        CustomSnackBar.show(
          context: context,
          message: "Connection $status successfully",
          type: SnackBarType.success,
        );
        fetchPendingInvitations();
      } else {
        CustomSnackBar.show(
          context: context,
          message: "Failed to $status connection",
          type: SnackBarType.error,
        );
        fetchPendingInvitations();
      }
    } catch (error) {
      if (!isClosed) {
        CustomSnackBar.show(
          context: context,
          message: "Couldn't $status the connection",
          type: SnackBarType.error,
        );
      }
    }
  }

  // void handleInvitation(UserConnection connection, String status) async {
  //   if (status == "Accepted") {
  //     final addResponse = await apiService.addConnection(connection);
  //     if (addResponse.statusCode != 201) {
  //       emit(InvitationsError("Failed to accept pending invitation"));
  //       return;
  //     }
  //   }
  //   final response =
  //       await apiService.removePendingInvitation(connection.userId);
  //   if (response.statusCode == 200) {
  //     emit(InvitationsInitial());
  //   } else {
  //     emit(InvitationsError("Failed to remove pending invitation"));
  //   }
  // }
}
