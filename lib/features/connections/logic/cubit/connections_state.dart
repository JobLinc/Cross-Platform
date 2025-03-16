part of 'connections_cubit.dart';

abstract class ConnectionsState {}

final class ConnectionsInitial extends ConnectionsState {}

final class SearchState extends ConnectionsState {}

final class ChooseSort extends ConnectionsState {}

final class InvitationResponse extends ConnectionsState {}
