import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:joblinc/features/jobs/data/models/job_application_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher.dart';

class JobApplicationCard extends StatelessWidget {
  final JobApplication jobApplication;

  const JobApplicationCard({
    Key? key,
    required this.jobApplication,
  }) : super(key: key);

  Future<void> _openResume(BuildContext context, String resumeUrl, String resumeName) async {
    final directory = await getApplicationDocumentsDirectory();
    final localPath = '${directory.path}/$resumeName';
    final file = File(localPath);

    if (await file.exists()) {
      await OpenFile.open(localPath);
    } else if (await canLaunchUrl(Uri.parse(resumeUrl))) {
      await launchUrl(Uri.parse(resumeUrl));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open resume.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final job = jobApplication.job;
    final resume = jobApplication.resume;
    final dateStr = DateFormat.yMMMd().format(jobApplication.createdAt);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.red, width: 2), // Red border around card
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1) Job Title
          Text(
            job.title ?? "",
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black, // Changed from blue to black
            ),
          ),
          SizedBox(height: 4.h),

          // 2) Company & Industry
          Text(
            "${job.company?.name ?? ""} • ${job.industry ?? ""}",
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 4.h),

          // 3) Location
          Text(
            "${job.location?.city ?? ""}, ${job.location?.country ?? ""}",
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
          ),

          SizedBox(height: 12.h),

          // 4) Status
          Text(
            "Status: ${jobApplication.status}",
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: _statusColor(jobApplication.status),
            ),
          ),
          SizedBox(height: 4.h),

          // 5) Applied Date
          Text(
            "Applied on: $dateStr",
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[700],
            ),
          ),

          SizedBox(height: 12.h),

          // 6) Resume Header
          Text(
            "Resume",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black, // Changed from blue to black
            ),
          ),
          SizedBox(height: 4.h),

          // Resume Card
          GestureDetector(
            onTap: () => _openResume(context, resume.url, resume.name),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.red.shade400),
                borderRadius: BorderRadius.circular(8.r),
              ),
              padding: EdgeInsets.all(8.w),
              child: Row(
                children: [
                  // Extension badge
                  Container(
                    width: 50.w,
                    height: 50.w,
                    decoration: BoxDecoration(
                      color: Colors.red.shade400,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      resume.extension.replaceAll('.', '').toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),

                  // Name, size, date
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          resume.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          "${(resume.size / 1024.0).toStringAsFixed(1)} kB - Last updated on ${DateFormat('M/d/yyyy').format(resume.date)}",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case "application pending review":
        return Colors.orange;
      case "decision in progress":
        return Colors.blue;
      case "approved":
        return Colors.green;
      case "rejected":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}


class JobApplicationList extends StatelessWidget {
  final List<JobApplication> jobApplications;

  const JobApplicationList({
    Key? key,
    required this.jobApplications,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white70,
      child: ListView.builder(
        itemCount: jobApplications.length,
        itemBuilder: (context, index) {
          final jobApp = jobApplications[index];
          return JobApplicationCard(
            jobApplication: jobApp,
          );
        },
      ),
    );
  }
}