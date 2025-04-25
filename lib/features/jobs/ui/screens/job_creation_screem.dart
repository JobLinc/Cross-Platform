import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/features/jobs/logic/cubit/job_list_cubit.dart';
import 'package:joblinc/features/jobs/ui/widgets/drop_down_Text_Fomr.dart';
import 'package:joblinc/features/signup/ui/widgets/city_text_field.dart';
import 'package:joblinc/features/signup/ui/widgets/country_text_field.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/core/theming/font_styles.dart';

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
  final skillsController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final countryController = TextEditingController();
  final minSalaryController = TextEditingController();
  final maxSalaryController = TextEditingController();
  final currencyController = TextEditingController();
  final experienceController = TextEditingController();
  final typeController = TextEditingController();
  final placeController = TextEditingController();
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
    skillsController.dispose();
    cityController.dispose();
    countryController.dispose();
    minSalaryController.dispose();
    maxSalaryController.dispose();
    currencyController.dispose();
    experienceController.dispose();
    typeController.dispose();
    placeController.dispose();
    super.dispose();
  }

  void _createJob() {
    if (_formKey.currentState!.validate()) {
      Map<String,dynamic> jobReq = 
      {
        'title':titleController.text,
        'industry': industryController.text,
        'description': descriptionController.text,
        'workplace': placeController.text,
        'type': typeController.text,
        'experienceLevel': experienceController.text,
        'salaryRange': {
          'from':double.tryParse(minSalaryController.text) ?? 0,
          'to':double.tryParse(maxSalaryController.text) ?? 0,
          'currency':currencyController.text,
        },
        'location': {
          'address':addressController.text,
          'city': cityController.text,
          'country': countryController.text,
        },
        'skills': skillsController.text
            .split(',')
            .map((e) => e.trim())
            .where((element) => element.isNotEmpty)
            .toList(),
      };

      print("Job Created: ${jobReq['experienceLevel']},${jobReq['workplace']},${jobReq['type']},${jobReq['salaryRange']},${jobReq['location']},${jobReq['skills']}");
      // // Here, you could call an API or Bloc to create the job.
      // // For this example, we'll just print the job details.
      context.read<JobListCubit>().createJob(jobReq:jobReq);

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

                DropDownTextFormField(
                    fieldName: "Experience Level",
                    choiceController: experienceController),
                SizedBox(height: 16.h),

                DropDownTextFormField(
                    fieldName: "Workplace", choiceController: placeController),
                SizedBox(height: 16.h),

                DropDownTextFormField(
                    fieldName: "Job Type", choiceController: typeController),
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
                    SizedBox(width: 16.w),
                    Expanded(
                        child: CurrencyDropDownTextFormField(
                            fieldName: "Currency",
                            currencyController: currencyController))
                  ],
                ),
                SizedBox(height: 16.h),


                CountryTextFormField(
                    key: Key('job_country_textfield'),
                    countryController: countryController),
                SizedBox(
                  height: 16.h,
                ),
                CityTextFormField(
                    key: Key('job_city_textfield'),
                    cityController: cityController),
                

                SizedBox(height: 16.h),
                // Address
                TextFormField(
                  controller: addressController,
                  cursorColor: Colors.red,
                  decoration: _inputDecoration("Address"),
                  validator: (value) => value == null || value.isEmpty
                      ? "Enter Job Address"
                      : null,
                ),
                SizedBox(height: 16.h),
                // Keywords
                TextFormField(
                  controller: skillsController,
                  cursorColor: Colors.red,
                  decoration: _inputDecoration("Skills (comma separated)"),
                  validator: (value) => value == null || value.isEmpty
                      ? "Enter needed Job skills"
                      : null,
                ),
                SizedBox(height: 24.h),

              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Row(
          children: [
            SizedBox(width: 50.w),
            ElevatedButton(
              onPressed: _createJob,
              style: ElevatedButton.styleFrom(
                foregroundColor: ColorsManager.getPrimaryColor(context),
                backgroundColor: Colors.white,
                side: const BorderSide(color: Colors.red),
                padding: EdgeInsets.symmetric(
                  horizontal: 100.w,
                  vertical: 16.h,
                ),
                textStyle: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: Text(
                "Create Job",
                style: TextStyles.font13SemiBold(context)
                    .copyWith(color: ColorsManager.getPrimaryColor(context)),
              ),
            ),
            SizedBox(width: 50.w),
          ],
        ),
      ),
    );
  }
}
                // Experience Level Dropdown
                // DropdownButtonFormField<String>(
                //   decoration: _inputDecoration("Experience Level"),
                //   value: experienceLevel,
                //   items: ["Entry", "Mid", "Senior"]
                //       .map((level) => DropdownMenuItem(
                //             value: level,
                //             child:
                //                 Text(level, style: TextStyle(fontSize: 14.sp)),
                //           ))
                //       .toList(),
                //   onChanged: (value) {
                //     setState(() {
                //       experienceLevel = value;
                //     });
                //   },
                //   validator: (value) =>
                //       value == null ? "Select an experience level" : null,
                // ), 
                //               // // Workplace Dropdown
                // DropdownButtonFormField<String>(
                //   decoration: _inputDecoration("Workplace"),
                //   value: workplace,
                //   items: ["Onsite", "Remote", "Hybrid"]
                //       .map((work) => DropdownMenuItem(
                //             value: work,
                //             child:
                //                 Text(work, style: TextStyle(fontSize: 14.sp)),
                //           ))
                //       .toList(),
                //   onChanged: (value) {
                //     setState(() {
                //       workplace = value;
                //     });
                //   },
                //   validator: (value) =>
                //       value == null ? "Select a workplace" : null,
                // ),                // // Job Type Dropdown
                // DropdownButtonFormField<String>(
                //   decoration: _inputDecoration("Job Type"),
                //   value: jobType,
                //   items: ["Full-time", "Part-time", "Contract"]
                //       .map((type) => DropdownMenuItem(
                //             value: type,
                //             child:
                //                 Text(type, style: TextStyle(fontSize: 14.sp)),
                //           ))
                //       .toList(),
                //   onChanged: (value) {
                //     setState(() {
                //       jobType = value;
                //     });
                //   },
                //   validator: (value) =>
                //       value == null ? "Select a job type" : null,
                // ),      // Job(
      //   title: titleController.text,
      //   industry: industryController.text,
      //   company: Company(
      //     name: "${mockMainUser.firstname} ${mockMainUser.lastname}",
      //     size: "Individual Employer",
      //   ),
      //   description: descriptionController.text,
      //   workplace: workplace,
      //   type: jobType,
      //   experienceLevel: experienceLevel,
      //   salaryRange: SalaryRange(
      //     min: double.tryParse(minSalaryController.text) ?? 0,
      //     max: double.tryParse(maxSalaryController.text) ?? 0,
      //   ),
      //   location: Location(
      //     city: cityController.text,
      //     country: countryController.text,
      //   ),
      //   keywords: keywordsController.text
      //       .split(',')
      //       .map((e) => e.trim())
      //       .where((element) => element.isNotEmpty)
      //       .toList(),
      //   createdAt: DateTime.now(),
      // );                // ElevatedButton(
                //   onPressed: _createJob,
                //   style: ElevatedButton.styleFrom(
                //     foregroundColor: Colors.red,
                //     backgroundColor: Colors.white,
                //     side: const BorderSide(color: Colors.red),
                //     padding: EdgeInsets.symmetric(
                //       horizontal: 32.w,
                //       vertical: 16.h,
                //     ),
                //     textStyle: TextStyle(
                //       fontSize: 16.sp,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                //   child: const Text("Create Job"),
                // ),// SizedBox(height: 16.h),
                // Location: Country
                // TextFormField(
                //   controller: countryController,
                //   cursorColor: Colors.red,
                //   decoration: _inputDecoration("Country"),
                //   validator: (value) =>
                //       value == null || value.isEmpty ? "Enter country" : null,
                // ),                // Location: City
                // Row(
                //   children: [
                //     // Expanded(
                //     //   child: TextFormField(
                //     //     controller: cityController,
                //     //     cursorColor: Colors.red,
                //     //     decoration: _inputDecoration("City"),
                //     //     validator: (value) => value == null || value.isEmpty
                //     //         ? "Enter city"
                //     //         : null,
                //     //   ),
                //     // ),

                //     // Expanded(
                //     //   child: TextFormField(
                //     //     controller: countryController,
                //     //     cursorColor: Colors.red,
                //     //     decoration: _inputDecoration("Country"),
                //     //     validator: (value) => value == null || value.isEmpty
                //     //         ? "Enter country"
                //     //         : null,
                //     //   ),
                //     // ),
                //   ],
                // ),