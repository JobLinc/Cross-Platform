import 'package:bloc/bloc.dart';
import 'package:joblinc/features/connections/data/Repo/UserConnections.dart';
import 'package:joblinc/features/connections/data/Web_Services/MockConnectionApiService.dart';
import 'package:joblinc/features/connections/data/models/connectiondemoModel.dart';
import 'package:joblinc/features/connections/data/models/pendingconnectionsdemomodel.dart';
import 'package:meta/meta.dart';

part 'invitations_state.dart';

class InvitationsCubit extends Cubit<InvitationsState> {
  final MockConnectionApiService apiService;
  InvitationsCubit(this.apiService) : super(InvitationsInitial());
  Future<void> fetchPendingInvitations() async {
    emit(InvitationsInitial());

    try {
      final response = await apiService.getPendingInvitations();

      if (response.statusCode == 200) {
        final fetchedconnections = (response.data as List)
            .map(
                (item) => UserConnection.fromJson(item as Map<String, dynamic>))
            .toList();

        emit(InvitationsLoaded(fetchedconnections));
      } else {
        emit(InvitationsError("Failed to load connections"));
      }
    } catch (error) {
      emit(InvitationsError("An error occurred: $error"));
    }
  }

  void handleInvitation(UserConnection connection, String status) async {
    if (status == "Accepted") {
      final addResponse = await apiService.addConnection(connection);
      if (addResponse.statusCode != 201) {
        emit(InvitationsError("Failed to accept pending invitation"));
        return;
      }
    }
    final response =
        await apiService.removePendingInvitation(connection.userId);
    if (response.statusCode == 200) {
      emit(InvitationsInitial());
    } else {
      emit(InvitationsError("Failed to remove pending invitation"));
    }
  }
}
