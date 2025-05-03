import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/features/userprofile/data/models/user_profile_model.dart';
import 'package:joblinc/features/userprofile/logic/cubit/profile_cubit.dart';

class UserSkills extends StatefulWidget {
  const UserSkills({super.key, required this.profile, this.isuser = true});
  final UserProfile profile;
  final bool isuser;

  @override
  State<UserSkills> createState() => _UserSkillsState();
}

class _UserSkillsState extends State<UserSkills> {
// Helper method to get month name
  bool _showAllSkills = false;
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
    final skills = widget.profile.skills;
    final visibleSkills = _showAllSkills ? skills : skills.take(1).toList();

    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Skills',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              widget.isuser
                  ? IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, Routes.addSkillScreen);
                      },
                      icon: Icon(Icons.add),
                    )
                  : SizedBox.shrink(),
            ],
          ),

          // Skills List
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: visibleSkills.length,
            itemBuilder: (context, index) {
              final skill = visibleSkills[index];
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name + Icons
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
                              if (widget.isuser) ...[
                                IconButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      Routes.addSkillScreen,
                                      arguments: skill,
                                    );
                                  },
                                  icon: Icon(Icons.edit),
                                ),
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
                                          title: Text('Delete Skill'),
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
                                                Navigator.of(dialogContext)
                                                    .pop();
                                                context
                                                    .read<ProfileCubit>()
                                                    .removeSkill(skill.id);
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
                            style: TextStyle(fontSize: 14.sp),
                          ),
                          SizedBox(height: 4.h),
                          Divider(
                            color: Colors.grey[500],
                            thickness: 1,
                            height: 15.h,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // See More / See Less toggle
          if (skills.length > 1)
            TextButton(
              onPressed: () {
                setState(() {
                  _showAllSkills = !_showAllSkills;
                });
              },
              child: Text(
                  _showAllSkills ? "Show less Skills" : "Show more Skills"),
            ),
        ],
      ),
    );
  }
}
