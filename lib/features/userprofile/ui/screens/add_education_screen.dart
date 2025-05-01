// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/core/widgets/custom_snackbar.dart';
import 'package:joblinc/features/companypages/ui/widgets/form/custom_text_field.dart';
import 'package:joblinc/features/userprofile/data/models/education_model.dart';
import 'package:joblinc/features/userprofile/logic/cubit/profile_cubit.dart';

class AddEducationScreen extends StatefulWidget {
  Education? education;
  AddEducationScreen({
    super.key,
    this.education,
  });

  @override
  State<AddEducationScreen> createState() => _AddEducationScreenState();
}

class _AddEducationScreenState extends State<AddEducationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController schoolController = TextEditingController();
  final TextEditingController degreeController = TextEditingController();
  final TextEditingController fieldOfStudyController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController cgpaController = TextEditingController();
  DateTime? selectedIssueDate;
  DateTime? selectedExpirationDate;
  @override
  void initState() {
    super.initState();

    if (widget.education != null) {
      degreeController.text = widget.education!.degree;
      schoolController.text = widget.education!.school;
      fieldOfStudyController.text = widget.education!.fieldOfStudy;
      if (widget.education!.startDate != null) {
        final monthName = _getMonthName(widget.education!.startDate!.month);
        startDateController.text =
            "$monthName ${widget.education!.startDate!.year}";
        selectedIssueDate = widget.education!.startDate;
      }
      if (widget.education!.endDate != null) {
        final monthName = _getMonthName(widget.education!.endDate!.month);
        endDateController.text =
            "$monthName ${widget.education!.endDate!.year}";
        selectedExpirationDate = widget.education!.endDate;
      }
      if (widget.education!.cgpa != null) {
        cgpaController.text = widget.education!.cgpa!.toString();
      }
      if (widget.education!.description != null) {
        descriptionController.text = widget.education!.description!;
      }
    }
  }

  void saveEducation() {
    if (_formKey.currentState!.validate()) {
      if (widget.education == null) {
        final Education education = Education(
          educationId: '',
          degree: degreeController.text,
          school: schoolController.text,
          fieldOfStudy: fieldOfStudyController.text,
          startDate: selectedIssueDate,
          endDate: selectedExpirationDate,
          description: descriptionController.text == ''
              ? null
              : descriptionController.text,
          cgpa: cgpaController.text == ''
              ? null
              : double.parse(cgpaController.text),
        );
        context.read<ProfileCubit>().addEducation(education);
      } else {
        print("object");
        final Education education = Education(
          educationId: widget.education!.educationId,
          degree: degreeController.text,
          school: schoolController.text,
          fieldOfStudy: fieldOfStudyController.text,
          startDate: selectedIssueDate,
          endDate: selectedExpirationDate,
          description: descriptionController.text == ''
              ? null
              : descriptionController.text,
          cgpa: cgpaController.text == ''
              ? null
              : double.parse(cgpaController.text),
        );
        context.read<ProfileCubit>().editEducation(education);
      }
    }
  }

  Future<void> _selectYear(BuildContext context,
      TextEditingController controller, bool isIssueDate) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate:
          DateTime.now().add(Duration(days: 365 * 10)), // Allow future dates
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.black,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      setState(() {
        if (isIssueDate) {
          selectedIssueDate = selectedDate;
        } else {
          selectedExpirationDate = selectedDate;
        }

        final monthName = _getMonthName(selectedDate.month);
        controller.text = "$monthName ${selectedDate.year}";
      });
    }
  }

  String _getMonthName(int month) {
    const monthNames = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    return monthNames[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is EducationAdded) {
          int count = 0;
          Navigator.of(context).pushNamedAndRemoveUntil(
            Routes.profileScreen,
            (route) => count++ >= 2,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is EducationFailed) {
          CustomSnackBar.show(
              context: context,
              message: state.message,
              type: SnackBarType.error);
        }
      },
      builder: (context, state) {
        if (state is ProfileLoading) {
          return Center(child: CircularProgressIndicator());
        }
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('Add Education'),
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.save),
                tooltip: 'Save Education',
                onPressed: saveEducation,
              ),
            ],
          ),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
              children: [
                Text(
                  'Education Details',
                  style:
                      TextStyle(fontSize: 26.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6.h),
                Text(
                  '* Indicates required field',
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                ),
                SizedBox(height: 6.h),

                /// School
                CustomRectangularTextFormField(
                  controller: schoolController,
                  labelText: 'School*',
                  hintText: 'Ex: Stanford University',
                  maxLength: 255,
                  validator: (value) => value == null || value.isEmpty
                      ? 'School is required.'
                      : null,
                ),
                SizedBox(height: 20.h),

                /// Degree
                CustomRectangularTextFormField(
                  controller: degreeController,
                  labelText: 'Degree*',
                  hintText: 'Ex: Bachelor of Science',
                  maxLength: 255,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Degree is required.'
                      : null,
                ),
                SizedBox(height: 20.h),

                /// Field of Study
                CustomRectangularTextFormField(
                  controller: fieldOfStudyController,
                  labelText: 'Field of Study*',
                  hintText: 'Ex: Computer Science',
                  maxLength: 255,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Field of Study is required.'
                      : null,
                ),
                SizedBox(height: 20.h),

                /// Start Date (Optional)
                CustomRectangularTextFormField(
                  key: Key('profileAddCertificate_issueDate_textField'),
                  controller: startDateController,
                  labelText: 'Issue Date',
                  readOnly: true,
                  onTap: () => _selectYear(context, startDateController, true),
                ),
                SizedBox(height: 20.h),

                /// End Date (Optional)
                CustomRectangularTextFormField(
                  key: Key('profileAddCertificate_expirationDate_textField'),
                  controller: endDateController,
                  labelText: 'Expiration Date',
                  readOnly: true,
                  onTap: () => _selectYear(context, endDateController, false),
                ),
                SizedBox(height: 20.h),

                /// Description (Optional)
                CustomRectangularTextFormField(
                  controller: descriptionController,
                  labelText: 'Description',
                  hintText: 'Tell us more about your education...',
                  maxLines: 4,
                  maxLength: 500,
                ),
                SizedBox(height: 20.h),

                /// CGPA (Optional, Numeric only)
                TextFormField(
                  controller: cgpaController,
                  decoration: InputDecoration(
                    labelText: 'CGPA',
                    hintText: 'Ex: 3.75',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  validator: (value) {
                    if (value == null || value == '') {
                      return null;
                    }
                    // Validating the format
                    final regex = RegExp(r'^\d+(\.\d{1,2})?$');
                    if (!regex.hasMatch(value)) {
                      return 'Please enter a valid CGPA (up to two decimal places)';
                    }
                    // Validating that the value is within the range of 0 to 4.0
                    final cgpa = double.tryParse(value);
                    if (cgpa! < 0 || cgpa > 4) {
                      return 'CGPA should be between 0 and 4.0';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 30.h),

                /// Save Button
                SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsManager.crimsonRed,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.school, color: Colors.white),
                    label: Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: saveEducation,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
