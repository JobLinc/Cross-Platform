part of 'connections_cubit.dart';

abstract class ConnectionsState {}

final class ConnectionsInitial extends ConnectionsState {}



// final class ChooseSort extends ConnectionsState {}



final class ConnectionsLoaded extends ConnectionsState {
  List<UserConnection> Connections;
  ConnectionsLoaded(this.Connections);
}
class ConnectionsError extends ConnectionsState {
  String error;
  ConnectionsError(this.error);
}
