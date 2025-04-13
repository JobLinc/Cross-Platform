import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/features/jobs/data/models/job_model.dart';
import 'package:joblinc/features/jobs/logic/cubit/job_list_cubit.dart';
import 'package:joblinc/features/premium/data/models/user_model.dart';

class JobCreationScreen extends StatefulWidget {
  const JobCreationScreen({Key? key}) : super(key: key);

  @override
  _JobCreationScreenState createState() => _JobCreationScreenState();
}

class _JobCreationScreenState extends State<JobCreationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Text controllers for text fields.
  final titleController = TextEditingController();
  final industryController = TextEditingController();
  final descriptionController = TextEditingController();
  final keywordsController = TextEditingController();
  final cityController = TextEditingController();
  final countryController = TextEditingController();
  final minSalaryController = TextEditingController();
  final maxSalaryController = TextEditingController();

  // Dropdown values.
  String? experienceLevel;
  String? workplace;
  String? jobType;

  // Enhanced InputDecoration that keeps label and borders black and sets cursor color to red.
  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.black, fontSize: 14.sp),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black),
        borderRadius: BorderRadius.circular(8.r),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(8.r),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    industryController.dispose();
    descriptionController.dispose();
    keywordsController.dispose();
    cityController.dispose();
    countryController.dispose();
    minSalaryController.dispose();
    maxSalaryController.dispose();
    super.dispose();
  }

  void _createJob() {
    if (_formKey.currentState!.validate()) {
      final job = Job(
        title: titleController.text,
        industry: industryController.text,
        company: Company(
          name: "${mockMainUser.firstname} ${mockMainUser.lastname}",
          size: "Individual Employer",
        ),
        description: descriptionController.text,
        workplace: workplace,
        type: jobType,
        experienceLevel: experienceLevel,
        salaryRange: SalaryRange(
          min: double.tryParse(minSalaryController.text) ?? 0,
          max: double.tryParse(maxSalaryController.text) ?? 0,
        ),
        location: Location(
          city: cityController.text,
          country: countryController.text,
        ),
        keywords: keywordsController.text
            .split(',')
            .map((e) => e.trim())
            .where((element) => element.isNotEmpty)
            .toList(),
        createdAt: DateTime.now(),
      );

      // Here, you could call an API or Bloc to create the job.
      // For this example, we'll just print the job details.
      context.read<JobListCubit>().createJob(job);
      //print("Job Created: ${job.title}, ${job.industry}, ${job.company?.name}");
    }
  }

  @override
  Widget build(BuildContext context) {
    //final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create Job",
          style: TextStyle(color: Colors.black, fontSize: 18.sp),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: BlocListener<JobListCubit, JobListState>(
        listener: (context, state) {
          if (state is JobCreating) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(width: 16.w),
                    Text("Creating Job..."),
                  ],
                ),
                duration: Duration(minutes: 1),
              ),
            );
          }
          // When application is sent, show success snackbar and pop screen
          else if (state is JobCreated) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.check, color: Colors.green),
                    SizedBox(width: 16.w),
                    Text("Job Created successfully"),
                  ],
                ),
                duration: Duration(seconds: 2),
              ),
            );
            Future.delayed(Duration(seconds: 2), () {
              Navigator.pop(context);
            });
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Job Title
                TextFormField(
                  controller: titleController,
                  cursorColor: Colors.red,
                  decoration: _inputDecoration("Job Title"),
                  validator: (value) =>
                      value == null || value.isEmpty ? "Enter job title" : null,
                ),
                SizedBox(height: 16.h),
                // Industry
                TextFormField(
                  controller: industryController,
                  cursorColor: Colors.red,
                  decoration: _inputDecoration("Industry"),
                  validator: (value) =>
                      value == null || value.isEmpty ? "Enter industry" : null,
                ),
                SizedBox(height: 16.h),
                // Experience Level Dropdown
                DropdownButtonFormField<String>(
                  decoration: _inputDecoration("Experience Level"),
                  value: experienceLevel,
                  items: ["Entry", "Mid", "Senior"]
                      .map((level) => DropdownMenuItem(
                            value: level,
                            child:
                                Text(level, style: TextStyle(fontSize: 14.sp)),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      experienceLevel = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? "Select an experience level" : null,
                ),
                SizedBox(height: 16.h),
                // Workplace Dropdown
                DropdownButtonFormField<String>(
                  decoration: _inputDecoration("Workplace"),
                  value: workplace,
                  items: ["Onsite", "Remote", "Hybrid"]
                      .map((work) => DropdownMenuItem(
                            value: work,
                            child:
                                Text(work, style: TextStyle(fontSize: 14.sp)),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      workplace = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? "Select a workplace" : null,
                ),
                SizedBox(height: 16.h),
                // Job Type Dropdown
                DropdownButtonFormField<String>(
                  decoration: _inputDecoration("Job Type"),
                  value: jobType,
                  items: ["Full-time", "Part-time", "Contract"]
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child:
                                Text(type, style: TextStyle(fontSize: 14.sp)),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      jobType = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? "Select a job type" : null,
                ),
                SizedBox(height: 16.h),
                // Description
                TextFormField(
                  controller: descriptionController,
                  cursorColor: Colors.red,
                  decoration: _inputDecoration("Job Description"),
                  maxLines: 3,
                  validator: (value) => value == null || value.isEmpty
                      ? "Enter job description"
                      : null,
                ),
                SizedBox(height: 16.h),
                // Salary Range Inputs (side by side)
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: minSalaryController,
                        cursorColor: Colors.red,
                        decoration: _inputDecoration("Min Salary"),
                        keyboardType: TextInputType.number,
                        validator: (value) => value == null || value.isEmpty
                            ? "Enter min salary"
                            : null,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: TextFormField(
                        controller: maxSalaryController,
                        cursorColor: Colors.red,
                        decoration: _inputDecoration("Max Salary"),
                        keyboardType: TextInputType.number,
                        validator: (value) => value == null || value.isEmpty
                            ? "Enter max salary"
                            : null,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                // Location: City
                TextFormField(
                  controller: cityController,
                  cursorColor: Colors.red,
                  decoration: _inputDecoration("City"),
                  validator: (value) =>
                      value == null || value.isEmpty ? "Enter city" : null,
                ),
                SizedBox(height: 16.h),
                // Location: Country
                TextFormField(
                  controller: countryController,
                  cursorColor: Colors.red,
                  decoration: _inputDecoration("Country"),
                  validator: (value) =>
                      value == null || value.isEmpty ? "Enter country" : null,
                ),
                SizedBox(height: 16.h),
                // Keywords
                TextFormField(
                  controller: keywordsController,
                  cursorColor: Colors.red,
                  decoration: _inputDecoration("Keywords (comma separated)"),
                ),
                SizedBox(height: 24.h),
                ElevatedButton(
                  onPressed: _createJob,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.red,
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.red),
                    padding: EdgeInsets.symmetric(
                      horizontal: 32.w,
                      vertical: 16.h,
                    ),
                    textStyle: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text("Create Job"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
