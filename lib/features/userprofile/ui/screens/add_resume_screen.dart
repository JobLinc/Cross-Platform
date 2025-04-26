import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/features/userprofile/logic/cubit/profile_cubit.dart';

class UserAddResumeScreen extends StatefulWidget {
  const UserAddResumeScreen({super.key});

  @override
  State<UserAddResumeScreen> createState() => _UserAddResumeScreenState();
}

class _UserAddResumeScreenState extends State<UserAddResumeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () async {
              final result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['pdf'],
                allowMultiple: false,
              );

              if (result != null && result.files.isNotEmpty) {
                final platformFile = result.files.first;

                if (platformFile.path != null) {
                  final file = File(platformFile.path!);

                  print("Opening file: ${platformFile.name}");
                  if (!mounted) return;
                  context.read<ProfileCubit>().uploadResume(file);
                  // Open the file using the OpenFile package
                  //await OpenFile.open(platformFile.path!); // This works for both PDFs and Word docs
                }
              }
            },
            child: Text("Upload resume")),
      ),
    );
  }
}
