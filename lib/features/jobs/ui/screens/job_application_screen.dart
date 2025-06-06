import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/features/jobs/data/models/job_applicants.dart';
import 'package:joblinc/features/jobs/data/models/job_model.dart';
import 'package:joblinc/features/jobs/logic/cubit/job_list_cubit.dart';
import 'package:joblinc/features/jobs/ui/widgets/resume_card.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JobApplicationScreen extends StatefulWidget {
  final Job job;
  const JobApplicationScreen({Key? key, required this.job}) : super(key: key);

  @override
  State<JobApplicationScreen> createState() => _JobApplicationScreenState();
}

class _JobApplicationScreenState extends State<JobApplicationScreen> {
  //final TextEditingController _emailController = TextEditingController();
  final TextEditingController _countryCodeController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  String? _selectedResumeId;
  //String? _selectedResumeLocalPath;
  List<Resume>? resumes;

  @override
  void initState() {
    super.initState();
    // _loadStoredResumes();
    //_emailController.text = mockMainUser.email ?? "";
  if (_countryCodeController.text.isEmpty) {
    _countryCodeController.text = "+20";
  }// Default to Egypt
    context.read<JobListCubit>().getAllResumes();
  }

  /// Save resume data in SharedPreferences
  Future<void> _saveResumeLocally(String resumeName, String localPath) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("selected_resume_id", resumeName);
    await prefs.setString("selected_resume_path", localPath);
  }

  Future<void> _pickResumeFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
      allowMultiple: false,
      );
    if (result != null && result.files.isNotEmpty) {
      final platformFile = result.files.first;
      if (platformFile.path != null) {
        final file = File(platformFile.path!);

        await context.read<JobListCubit>().uploadResume(file);

        await context.read<JobListCubit>().getAllResumes();
        // Get the app documents directory
        final directory = await getApplicationDocumentsDirectory();
        final localPath = '${directory.path}/${platformFile.name}';

        // Copy file to app storage
        final localFile = await file.copy(localPath);

        debugPrint("Resume saved at: $localPath");

        // Save file path in persistent storage
        await _saveResumeLocally(platformFile.name, localFile.path);
        //print(_selectedResumeId);
        setState(() {
          _selectedResumeId = platformFile.name;
          //_selectedResumeLocalPath = localFile.path;
        });

      }
    }
  }

  Future<void> _openResume(String resumeUrl, String resumeName) async {
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
    return BlocListener<JobListCubit, JobListState>(
      listener: (context, state) {
        // Show a loading snackbar while sending application
        if (state is JobApplicationSending) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 16.w),
                  Text("Sending application..."),
                ],
              ),
              duration: Duration(seconds: 8),
            ),
          );
        }
        // When application is sent, show success snackbar and pop screen
        else if (state is JobApplicationSent) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check, color: Colors.green),
                  SizedBox(width: 16.w),
                  Text("Application sent successfully"),
                ],
              ),
              duration: Duration(seconds: 2),
            ),
          );
          Future.delayed(Duration(seconds: 2), () {
            Navigator.of(context).pop(true);
          });
        } else if (state is JobApplicationErrorSending) {

          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          // CustomSnackBar.show(
          //   context: context,
          //   message: state.errorMessage.split(":").last,
          //   type: SnackBarType.error,
          // );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.error, color: Colors.red),
                  SizedBox(width: 16.w),
                  Text(state.errorMessage.split(":").last),
                ],
              ),
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Apply to ${widget.job.title ?? ""}"),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              buildContactInfoCard(),
              DropdownButtonFormField2<String>(
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 350.h,
                  width: 1.sw - 32, // Match parent width minus padding
                  direction:
                      DropdownDirection.textDirection, // Follow text direction
                  offset: const Offset(0, 0), // No offset
                ),
                value: _countryCodeController.text.isNotEmpty
                    ? _countryCodeController.text
                    : "+20",
                decoration: InputDecoration(
                  labelText: "Phone country code*",
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  labelStyle: const TextStyle(color: Colors.black),
                ),
                items: [
                  DropdownMenuItem(value: "+1", child: Text("USA (+1)")),
                  DropdownMenuItem(value: "+44", child: Text("UK (+44)")),
                  DropdownMenuItem(value: "+20", child: Text("Egypt (+20)")),
                  DropdownMenuItem(value: "+91", child: Text("India (+91)")),
                  DropdownMenuItem(
                      value: "+61", child: Text("Australia (+61)")),
                  DropdownMenuItem(value: "+81", child: Text("Japan (+81)")),
                  DropdownMenuItem(value: "+49", child: Text("Germany (+49)")),
                  DropdownMenuItem(value: "+33", child: Text("France (+33)")),
                  DropdownMenuItem(value: "+86", child: Text("China (+86)")),
                  DropdownMenuItem(value: "+7", child: Text("Russia (+7)")),
                ],
                onChanged: (value) {
                  setState(() {
                    _countryCodeController.text = value ?? "";
                  });
                },
              ),
              SizedBox(height: 16.h),
              buildTextField(_phoneNumberController, TextInputType.number,
                  "Mobile phone number*"),
              SizedBox(height: 16.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Resume",
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 320.h,
                  minHeight: 100.h,
                ),
                child: SingleChildScrollView(
                  child: BlocBuilder<JobListCubit, JobListState>(
                    builder: (context, state) {
                    if (state is JobResumeUploading) {
                        return  Column(children: [
                          Center(child: CircularProgressIndicator(color: ColorsManager.crimsonRed,)),
                          Center(child: Text("Uploading Resume",style: TextStyle(color:ColorsManager.crimsonRed ),),)
                        ],);
                      }else if (state is JobResumesLoading) {
                        return CircularProgressIndicator();
                      } else if (state is JobResumesLoaded) {
                        resumes = state.resumes!;
                        if (resumes!.isEmpty) {
                          return Text("No resumes found. Upload a new one.");
                        }
                        return ResumeList(
                          resumes: resumes!,
                          selectedResumeId: _selectedResumeId,
                          onResumeSelected: (resumeId) {
                            setState(() {
                              _selectedResumeId = resumeId;
                            });
                          },
                          onOpenResume: _openResume, // Pass `_openResume` function
                        );
                      } else {
                        if (resumes == null) {
                          return const Text("Error loading resumes.");
                        } else {
                          if (resumes!.isEmpty) {
                            return Text("No resumes found. Upload a new one.");
                          }
                          return ResumeList(
                            resumes: resumes!,
                            selectedResumeId: _selectedResumeId,
                            onResumeSelected: (resumeId) {
                              setState(() {
                                _selectedResumeId = resumeId;
                              });
                            },
                            onOpenResume:
                                _openResume, // Pass `_openResume` function
                          );
                        }
                      }
                    },
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _pickResumeFile,
                style: ElevatedButton.styleFrom(
                  backgroundColor:ColorsManager.getPrimaryColor(context),
                  foregroundColor: Colors.white,
                ),
                child: const Text("Upload New Resume"),
              ),
 
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.grey, // Change color as needed for Back
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Back"),
                  ),
                ),
                SizedBox(width: 80.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      //final email = _emailController.text.trim();
                      final countryCode = _countryCodeController.text.trim();
                      final phoneNumber = _phoneNumberController.text.trim();
                      if (countryCode.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  "Please select your phone country code.")),
                        );
                        return;
                      }
                      if (phoneNumber.isEmpty ||
                          int.tryParse(phoneNumber) == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  "Please enter a valid mobile phone number.")),
                        );
                        return;
                      }
                      if (_selectedResumeId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text("Please select or upload a resume.")),
                        );
                        return;
                      }
 
                      context
                          .read<JobListCubit>()
                          .applyJob(widget.job.id, {
                            "phone": phoneNumber,
                            "resumeId": _selectedResumeId,
                          });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsManager.getPrimaryColor(context),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Apply"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildContactInfoCard() {
    return Container(
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24.r,
            backgroundColor: Colors.blueGrey[300],
            child: const Icon(Icons.person, size: 28.0, color: Colors.white),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              "Contact info",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(TextEditingController controller,
      TextInputType keyboardType, String label) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey[200],
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        labelStyle: const TextStyle(color: Colors.black),
      ),
      cursorColor: Colors.black,
    );
  }
}