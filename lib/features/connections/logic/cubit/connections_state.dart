part of 'connections_cubit.dart';

@immutable
sealed class ConnectionsState {}

final class ConnectionsInitial extends ConnectionsState {}

final class SearchState extends ConnectionsState {}

final class ChooseSort extends ConnectionsInitial {}

final class SortData extends ConnectionsInitial {}
