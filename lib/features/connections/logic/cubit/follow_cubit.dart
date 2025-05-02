import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:joblinc/core/widgets/custom_snackbar.dart';
import 'package:joblinc/features/connections/data/Repo/connections_repo.dart';
import 'package:joblinc/features/userprofile/data/models/follow_model.dart';

part 'follow_state.dart';

class FollowCubit extends Cubit<FollowState> {
  final UserConnectionsRepository connectionsRepository;
  FollowCubit(this.connectionsRepository) : super(FollowInitial());
  Future<void> fetchFollowing() async {
    emit(FollowInitial());

    try {
      final response = await connectionsRepository.getFollowing();
      if (!isClosed) {
        emit(FollowLoaded(response));
      }
    } catch (error) {
      if (!isClosed) {
        emit(FollowError("An error occurred: $error"));
      }
    }
  }

  void unfollowConnection(String userId, BuildContext context) async {
    try {
      final response = await connectionsRepository.unfollwConnection(userId);
      if (response.statusCode == 200) {
        CustomSnackBar.show(
            context: context,
            message: "connection unfollowed succefully ",
            type: SnackBarType.success);
        fetchFollowing();
      } else {
        CustomSnackBar.show(
            context: context,
            message: "connection unfollowed failed ",
            type: SnackBarType.error);
        fetchFollowing();
      }
    } catch (error) {
      if (!isClosed) {
        CustomSnackBar.show(
            context: context,
            message: "couldn't unfollow connection",
            type: SnackBarType.error);
      }
    }
  }

  Future<void> fetchFollowers() async {
    emit(FollowInitial());

    try {
      final response = await connectionsRepository.getFollowers();
      if (!isClosed) {
        emit(FollowLoaded(response));
      }
    } catch (error) {
      if (!isClosed) {
        emit(FollowError("An error occurred: $error"));
      }
    }
  }
}
