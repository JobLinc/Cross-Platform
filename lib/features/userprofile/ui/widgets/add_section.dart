import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/features/userprofile/logic/cubit/profile_cubit.dart';
import 'package:open_file/open_file.dart';

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
              Navigator.pushReplacementNamed(
                  context, Routes.addExperienceScreen);
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
          padding: EdgeInsets.only(top: 2, bottom: 2, left: 5),
          child: InkWell(
            onTap: () async {
              //Navigator.pushReplacementNamed(context, Routes.addResumeScreen);
              final result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['pdf'],
                allowMultiple: false,
              );

              if (result != null && result.files.isNotEmpty) {
                final platformFile = result.files.first;

                if (platformFile.path != null) {
                  final file = File(platformFile.path!);

                  // Now upload with the cubit
                  Navigator.of(context).pop();
                  context.read<ProfileCubit>().uploadResume(file);
                  // Open the file using the OpenFile package
                  //await OpenFile.open(platformFile.path!); // This works for both PDFs and Word docs
                }
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () async {
                    //Navigator.pushReplacementNamed(context, Routes.addResumeScreen);
                    final result = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['pdf'],
                      allowMultiple: false,
                    );

                    if (result != null && result.files.isNotEmpty) {
                      final platformFile = result.files.first;

                      if (platformFile.path != null) {
                        final file = File(platformFile.path!);
                        Navigator.of(context).pop();
                        context.read<ProfileCubit>().uploadResume(file);
                        // Open the file using the OpenFile package
                        //await OpenFile.open(platformFile.path!); // This works for both PDFs and Word docs
                      }
                    }
                    // Pick files, filtering for PDF files only
                    // final result = await FilePicker.platform.pickFiles(
                    //   type: FileType.custom,
                    //   allowedExtensions: ['pdf'],
                    //   allowMultiple: false,
                    // );

                    // if (result != null && result.files.isNotEmpty) {
                    //   final platformFile = result.files.first;

                    //   if (platformFile.path != null) {
                    //     final file = File(platformFile.path!);

                    //     print("Opening file: ${platformFile.name}");

                    //     // Open the file using the OpenFile package
                    //     // await OpenFile.open(platformFile.path!); // This works for both PDFs and Word docs

                    //     context
                    //         .read<ProfileCubit>()
                    //         .uploadResume(file, context);
                    //   }
                    // }
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
