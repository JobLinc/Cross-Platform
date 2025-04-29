import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/features/userprofile/data/models/user_profile_model.dart';
import 'package:joblinc/features/userprofile/logic/cubit/profile_cubit.dart';

class othersConnections extends StatelessWidget {
  final UserProfile profile;
  othersConnections({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Row(
        children: [
          Text(
            '${profile.numberOfConnections} connections',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.blue.shade800,
            ),
          ),
          if (profile.matualConnections > 0) ...[
            Text(' • '),
            Text(
              '${profile.matualConnections} mutual',
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ],
        ],
      ),
      onTap: () async {
        final shouldRefresh = await Navigator.pushNamed(
                context, Routes.othersConnectionScreen,
                arguments: profile.userId) ??
            false;

        if (shouldRefresh == true) {
          context.read<ProfileCubit>().getPublicUserProfile(profile.userId);
        }
      },
    );
  }
}
