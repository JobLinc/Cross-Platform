part of 'sent_connections_cubit.dart';

abstract class SentConnectionsState {}

final class SentConnectionsInitial extends SentConnectionsState {}

final class SentConnectionsLoaded extends SentConnectionsState {
  List<UserConnection> Connections;
  SentConnectionsLoaded(this.Connections);
}

class SentConnectionsError extends SentConnectionsState {
  String error;
  SentConnectionsError(this.error);
}
