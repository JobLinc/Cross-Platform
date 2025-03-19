import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:joblinc/features/jobs/data/models/job_model.dart';

class JobDetailScreen extends StatelessWidget {
  final Job jobDetails;
  final ScrollController scrollController;

  const JobDetailScreen({super.key, required this.scrollController, required this.jobDetails,});
  
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Material(
      borderRadius: BorderRadius.vertical(top:Radius.circular(20.r)),
      child: Container(
        decoration:BoxDecoration(
          color:Colors.white,
          
        ),
        padding: EdgeInsets.all(16.w),
        child: SingleChildScrollView(
          controller: scrollController,
          physics: ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 5.h,
                  margin: EdgeInsets.only(bottom: 16.h),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
              Text(
                "${jobDetails.company!.name}",
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.h,),
              Text(
                "${jobDetails.industry} - ${jobDetails.title}",
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.h,),
              Text(" ${jobDetails.location!.city}, ${jobDetails.location!.city}, ${jobDetails.location!.country}",
              style: TextStyle(fontSize: 14.sp),
              ),
              SizedBox(height: 8.h),
              Text("Reposted ${DateFormat.MMMd().format(jobDetails.createdAt!)} - ${DateFormat.jm().format(jobDetails.createdAt!)}",
              style: TextStyle(fontSize: 14.sp),
              ),
              SizedBox(height: 8.h),
              Text("${jobDetails.company!.size}",
              style: TextStyle(fontSize: 14.sp),
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Chip(label: Text("${jobDetails.workplace}")),
                  SizedBox(width: 8.h,),
                  Chip(label: Text("${jobDetails.type}")),
                ],
              ),
              SizedBox(height: 16.h),
              SizedBox(
                width: screenWidth * 0.9, 
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[400],
                    foregroundColor: Colors.white,
                    ),
                  child: Text("Apply"),
                  ),
              ),
              SizedBox(
                width: screenWidth * 0.9,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.red[400],
                  ),
                  child: Text("Save"), 
                  ),
              ),
              SizedBox(height: 16.h),
              Text(
                "${jobDetails.description}",
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              //Text("Get AI-powered advice on this job and more exclusive features with Premium."),
            ],
          ),
        ),
      ),
    );
  }
}