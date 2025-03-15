part of 'connections_cubit.dart';

@immutable
sealed class ConnectionsState {}

final class ConnectionsInitial extends ConnectionsState {}

final class SearchState extends ConnectionsState {}

final class ChooseSort extends ConnectionsState {}

final class SortData extends ConnectionsState {}
