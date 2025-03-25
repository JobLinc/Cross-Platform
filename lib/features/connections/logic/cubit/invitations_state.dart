part of 'invitations_cubit.dart';

abstract class InvitationsState {}

final class InvitationsInitial extends InvitationsState {}

final class InvitationsLoaded extends InvitationsState {
  List<UserConnection> Connections;
  InvitationsLoaded(this.Connections);
}

class InvitationsError extends InvitationsState {
  String error;
  InvitationsError(this.error);
}