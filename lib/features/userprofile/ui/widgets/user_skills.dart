import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/features/userprofile/data/models/user_profile_model.dart';
import 'package:joblinc/features/userprofile/logic/cubit/profile_cubit.dart';

class UserSkills extends StatelessWidget {
  const UserSkills({super.key, required this.profile, this.isuser = true});
  final UserProfile profile;
  final bool isuser;

// Helper method to get month name
  String _getSkillLevel(int level) {
    const skillLevel = [
      "Novice",
      "Apprentice",
      "Competent",
      "Proficient",
      "Master"
    ];
    // Fixed the index calculation - level is 1-5, array indices are 0-4
    return skillLevel[level - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Skills',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            // Fixed: using the correct collection length
            itemCount: profile.skills.length,
            itemBuilder: (context, index) {
              // Added safety check to prevent out of bounds error
              if (index >= profile.skills.length) {
                return SizedBox.shrink();
              }
              final skill = profile.skills[index];
              return Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 5.h), // Reduced from 8.h to 4.h
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Put name and delete icon in the same row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  skill.name,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              if (isuser) ...[
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: ColorsManager.darkBurgundy,
                                    size: 20.r,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext dialogContext) {
                                        return AlertDialog(
                                          title: Text('Delete Certificate'),
                                          content: Text(
                                              'Are you sure you want to delete "${skill.name}"?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(dialogContext)
                                                    .pop();
                                              },
                                              child: Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                // Close dialog and delete certificate
                                                Navigator.of(dialogContext)
                                                    .pop();
                                                context
                                                    .read<ProfileCubit>()
                                                    .removeSkill(skill.id);
                                                // TODO: Implement actual delete functionality (Radwan)
                                              },
                                              child: Text(
                                                'Delete',
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(),
                                  splashRadius: 20.r,
                                ),
                              ]
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            _getSkillLevel(skill.level),
                            style: TextStyle(
                              fontSize: 14.sp,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Divider(
                            color: Colors.grey[500],
                            thickness: 1,
                            height: 15
                                .h, // Explicitly set height to control spacing
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
