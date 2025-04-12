import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/routing/routes.dart';
//import 'package:joblinc/core/di/dependency_injection.dart';
// import 'package:joblinc/core/routing/routes.dart' show Routes;

class UserProfileAddSection extends StatelessWidget {
  const UserProfileAddSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10.h, bottom: 2.h, left: 5.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(Icons.ios_share),
                onPressed: () {},
              ),
              Text(
                'Add education',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
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
                  onPressed: () {},
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
              Navigator.pushReplacementNamed(context, Routes.addCertificationScreen);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.flag_rounded),
                  onPressed: () {},
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
        // Padding(
        //   padding: EdgeInsets.only(top: 2, bottom: 2, left: 5),
        //   child: InkWell(
        //     onTap: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => BlocProvider(
        //             create: (context) => getIt<CreateCompanyCubit>(
        //               param1: (company) {
        //                 // Navigation logic when the company is created
        //                 Navigator.pushNamed(
        //                   context,
        //                   Routes.companyDashboard,
        //                   arguments: company,
        //                 );
        //               },
        //             ),
        //             child: CreateCompanyPage(),
        //           ),
        //         ),
        //       );
        //     },
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.start,
        //       children: [
        //         IconButton(
        //           icon: Icon(Icons.add),
        //           onPressed: () {},
        //         ),
        //         Text(
        //           'Create a LinkedIn Page',
        //           style: TextStyle(
        //             fontSize: 16,
        //             fontWeight: FontWeight.bold,
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
