import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/routing/routes.dart';

class UserProfileAddSection extends StatelessWidget {
  const UserProfileAddSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10.h, bottom: 2.h, left: 5.w),
          child: InkWell(
            onTap: () {
              Navigator.pushReplacementNamed(context, Routes.addExperienceScreen);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.ios_share),
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, Routes.addSkillScreen);
                  },
                ),
                Text(
                  'Add experience',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 2, bottom: 2, left: 5),
          child: InkWell(
            onTap: () {
              Navigator.pushReplacementNamed(context, Routes.addSkillScreen);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, Routes.addSkillScreen);
                  },
                ),
                Text(
                  'Add skills',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 2, bottom: 2, left: 5),
          child: InkWell(
            onTap: () {
              Navigator.pushReplacementNamed(
                  context, Routes.addCertificationScreen);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.flag_rounded),
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, Routes.addCertificationScreen);
                  },
                ),
                Text(
                  'Add licenses & certifications',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top:2, bottom: 2, left: 5),
          child: InkWell(
            onTap: () {
              Navigator.pushReplacementNamed(context, Routes.addResumeScreen);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, Routes.addResumeScreen);
                  },
                ),
                Text(
                  'Add resume',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
