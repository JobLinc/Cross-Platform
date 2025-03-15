import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/features/companyPages/ui/widgets/company_more.dart';
import 'package:joblinc/features/companyPages/ui/widgets/follow_button.dart';
import 'package:joblinc/features/companyPages/ui/widgets/visit_company_website.dart';
import '../widgets/square_avatar.dart';
import '../../data/company.dart';

class CompanyData extends StatelessWidget {
  final Company company;
  
  CompanyData({required this.company ,super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image(
          fit: BoxFit.cover,
          image: NetworkImage(
              // TODO: Add an IF condition to check if the Cover Url is null
              company.coverUrl!), // Company Cover goes here
          width: double.infinity,
          height: 40.h,
        ),
        Padding(
          padding: EdgeInsets.only(top: 20.h, left: 17.w),
          child: SquareAvatar(
              imageUrl:
                  // TODO: Add an IF condition to check if the Logo Url is null to add default image
                  company.logoUrl!, // Company Logo goes here
              size: 60),
        ),
        Padding(
          padding: EdgeInsets.only(top: 65.h),
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          company.name, // Company Name goes here
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (company.isVerified)
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Icon(Icons.verified_user_outlined),
                          ) // Company Verification check goes here
                      ],
                    ),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment
                          .center, 
                      spacing: 10.0,
                      runSpacing: 4.0,
                      children: [
                        // Industry
                        Text(
                          company.industry.displayName,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.grey.shade600,
                          ),
                        ),

                        Icon(
                          Icons.circle,
                          size: 6.sp, 
                          color: Colors.grey.shade600,
                        ),

                        for (var part in company.location!.split(' '))
                          Text(
                            part,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.grey.shade600,
                            ),
                          ),

                        Icon(
                          Icons.circle,
                          size: 6.sp,
                          color: Colors.grey.shade600,
                        ),
                        // Followers
                        for (var part in "37M followers".split(
                            ' ')) // TODO: Add the real number of followers
                          Text(
                            part,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        
                        Icon(
                          Icons.circle,
                          size: 6.sp,
                          color: Colors.grey.shade600,
                        ),
                        // Organization size
                        for (var part in company
                            .organizationSize
                            .displayName
                            .split(
                                ' ')) 
                          Text(
                            part,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.grey.shade600,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12, left: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    VisitCompanyWebsite(
                      text: 'Visit Website',
                      backgroundColor: Color(0xFFD72638),
                      borderColor: Color(0xFFD72638),
                      foregroundColor: Colors.white,
                      icon: Icons.open_in_new,
                      websiteUrl: company.website!,
                      width: 150.w,
                      fontSize: 13.sp,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: FollowButton(
                        text: "+ Follow",
                        backgroundColor: Colors.white,
                        foregroundColor: Color(0xFFD72638),
                        borderColor: Color(0xFFD72638),
                        width: 130.w,
                        fontSize: 13.sp,
                      ),
                    ),
                    CompanyMoreButton(),
                    
                  ],
                ),
                
              ),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 16.w),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //         'Jobs', // Company Jobs goes here
              //         style: TextStyle(
              //           fontSize: 24.sp,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //       ListView.builder(
              //         shrinkWrap: true,
              //         itemCount: 5,
              //         itemBuilder: (context, index) {
              //           return Card(
              //             child: ListTile(
              //               title: Text(
              //                   'Software Engineer'), // Job Title goes here
              //               subtitle: Text(
              //                   'Redmond, Washington'), // Job Location goes here
              //               trailing: Text('Full Time'), // Job Type goes here
              //             ),
              //           );
              //         },
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ],
    );
  }
}
