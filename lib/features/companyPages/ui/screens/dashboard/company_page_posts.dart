import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/features/companypages/data/data/company.dart';
import 'package:joblinc/features/companypages/ui/widgets/dashboard/dashboard_appbar.dart';
import 'package:url_launcher/url_launcher.dart';

class CompanyPagePosts extends StatelessWidget {
  final Company company;

  const CompanyPagePosts({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DashboardAppbar(
        company: company,
        selectedValue: "Page Posts",
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          // TODO: Add a list view of posts Fathy
          Container(
            height: 200.h,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 8.w),
                    child: Text(
                      'Build compelling ads',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.only(left: 8.w),
                          child: Text(
                            'Ahmed, learn how to create high-performing ads',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.grey[700],
                            ),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                            'https://media.licdn.com/dms/image/v2/D4E14AQE-5TZTcaMjsg/galapagos-inFeedBackgroundImage-analyzedImage/galapagos-inFeedBackgroundImage-analyzedImage/0/1715698166166?e=1743249600&v=beta&t=so-YKKOplPE61YUo2MLlq0hUM2VCpkVsH_UtEJGJyBc',
                          ),
                          radius: 50.h,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      launch(
                          'https://www.linkedin.com/help/linkedin/answer/a452425');
                    },
                    child: Text(
                      'Learn more',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: ColorsManager.warmWhite,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: ColorsManager.crimsonRed,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
                      shape: StadiumBorder(
                        side: BorderSide(
                          color: ColorsManager.crimsonRed,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
