import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/features/chat/ui/screens/document_viewer_screen.dart';
import 'package:joblinc/features/userprofile/data/models/user_profile_model.dart';
import 'package:joblinc/features/userprofile/logic/cubit/profile_cubit.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class UserResumes extends StatefulWidget {
  const UserResumes({super.key, required this.profile, this.isuser = true});
  final UserProfile profile;
  final bool isuser;

  @override
  State<UserResumes> createState() => _UserResumesState();
}

class _UserResumesState extends State<UserResumes> {
  bool _showAll = false;
  String _formatFileSize(int sizeInBytes) {
    if (sizeInBytes >= 1024 * 1024) {
      return "${(sizeInBytes / (1024 * 1024)).toStringAsFixed(2)} MB";
    } else if (sizeInBytes >= 1024) {
      return "${(sizeInBytes / 1024).toStringAsFixed(2)} KB";
    }
    return "$sizeInBytes B";
  }

  String _formatDate(DateTime date) {
    return "${_getMonthName(date.month)} ${date.day}, ${date.year}";
  }

  String _getMonthName(int month) {
    const monthNames = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    return monthNames[month - 1];
  }

  Future<void> _openResume(
      String resumeUrl, String resumeName, BuildContext context) async {
    final directory = await getApplicationDocumentsDirectory();
    final localPath = '${directory.path}/$resumeName';
    final file = File(localPath);

    if (await file.exists()) {
      await OpenFile.open(localPath);
    } else if (await canLaunchUrl(Uri.parse(resumeUrl))) {
      // await launchUrl(Uri.parse(resumeUrl));
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DocumentViewerScreen(
            url: resumeUrl,
            type: resumeName.toLowerCase().endsWith('.pdf')
                ? 'pdf'
                : resumeName.toLowerCase().endsWith('.doc') ||
                        resumeName.toLowerCase().endsWith('.docx')
                    ? 'doc'
                    : 'other',
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open resume.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final resumes = widget.profile.resumes;
    final visibleResumes = _showAll
        ? resumes
        : resumes.take(1).toList(); // show only 1 if not expanded

    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Uploaded Resumes',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (widget.isuser)
                IconButton(
                  onPressed: () async {
                    final result = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['pdf', 'doc', 'docx'],
                      allowMultiple: false,
                    );

                    if (result != null && result.files.isNotEmpty) {
                      final platformFile = result.files.first;

                      if (platformFile.path != null) {
                        final file = File(platformFile.path!);
                        context.read<ProfileCubit>().uploadResume(file);
                      }
                    }
                  },
                  icon: Icon(Icons.add),
                ),
            ],
          ),

          // Resumes List
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: visibleResumes.length,
            itemBuilder: (context, index) {
              final resume = visibleResumes[index];
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    print('Resume tapped: ${resume.name}');
                                    _openResume(
                                        resume.file, resume.name, context);
                                  },
                                  child: Text(
                                    resume.name,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.blue.shade700,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                              if (widget.isuser)
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
                                          title: Text('Delete Resume'),
                                          content: Text(
                                              'Are you sure you want to delete "${resume.name}"?'),
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
                                                    .deleteresume(resume.id);
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
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            _formatFileSize(resume.size),
                            style: TextStyle(fontSize: 14.sp),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            "Uploaded ${_formatDate(resume.createdAt)}",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[600],
                            ),
                          ),
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

          // Show "See more" or "See less"
          if (resumes.length > 1)
            TextButton(
              onPressed: () {
                setState(() {
                  _showAll = !_showAll;
                });
              },
              child: Text(_showAll ? "Show less Resumes" : "Show more Resumes"),
            ),
        ],
      ),
    );
  }
}
