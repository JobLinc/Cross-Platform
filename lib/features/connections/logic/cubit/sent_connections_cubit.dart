import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/features/connections/data/Web_Services/MockConnectionApiService.dart';
import 'package:joblinc/features/connections/data/models/connectiondemoModel.dart';

part 'sent_connections_state.dart';

class SentConnectionsCubit extends Cubit<SentConnectionsState> {
  final MockConnectionApiService apiService;
  SentConnectionsCubit(this.apiService) : super(SentConnectionsInitial());

  Future<void> fetchSentInvitations() async {
    emit(SentConnectionsInitial());

    try {
      final response = await apiService.getSentConnections();

      if (response.statusCode == 200) {
        final fetchedConnections = (response.data as List)
            .map(
                (item) => UserConnection.fromJson(item as Map<String, dynamic>))
            .toList();
        if (!isClosed) {
          emit(SentConnectionsLoaded(fetchedConnections.reversed.toList()));
        }
      } else {
        if (!isClosed) {
          emit(SentConnectionsError("Failed to load sent connections"));
        }
      }
    } catch (error) {
      if (!isClosed) {
        emit(SentConnectionsError("An error occurred: $error"));
      }
    }
  }

  void withdrawclicked(String userID) async {
    Response respone = await apiService.removeSentConnection(userID);
    if (respone.statusCode != 200) {
      if (!isClosed) {
        emit(SentConnectionsError("Failed to remove the connections"));
        return;
      }
    } else {
      if (!isClosed) {
        emit(SentConnectionsInitial());
      }
    }
  }
}
