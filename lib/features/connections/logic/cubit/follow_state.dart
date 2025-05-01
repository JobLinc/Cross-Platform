part of 'follow_cubit.dart';

abstract class FollowState {}

final class FollowInitial extends FollowState {}

final class FollowLoaded extends FollowState {
  final List<Follow> follows;
  FollowLoaded( this.follows);
}

final class FollowError extends FollowState 
{
  String error;
  FollowError(this.error);
}
