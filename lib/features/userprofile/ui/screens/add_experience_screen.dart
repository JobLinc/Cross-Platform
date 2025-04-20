import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/features/companypages/ui/widgets/form/custom_text_field.dart';
import 'package:joblinc/features/userprofile/data/models/experience_model.dart';
import 'package:joblinc/features/userprofile/logic/cubit/profile_cubit.dart';

class UserAddExperienceScreen extends StatefulWidget {
  @override
  _UserAddExperienceScreenState createState() =>
      _UserAddExperienceScreenState();
}

class _UserAddExperienceScreenState extends State<UserAddExperienceScreen> {
  late TextEditingController experienceNameController;
  late TextEditingController organizationController;
  late TextEditingController startDateController;
  late TextEditingController endDateController;
  late TextEditingController descriptionController;

  DateTime? selectedstartDate;
  DateTime? selectedendDate;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    experienceNameController = TextEditingController();
    organizationController = TextEditingController();
    startDateController = TextEditingController();
    endDateController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    experienceNameController.dispose();
    organizationController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectYear(BuildContext context,
      TextEditingController controller, bool isstartDate) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(Duration(days: 365 * 10)),
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
        if (isstartDate) {
          selectedstartDate = selectedDate;
        } else {
          selectedendDate = selectedDate;
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

  void saveExperience() {
    if (_formKey.currentState!.validate()) {
      if (selectedstartDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select a start date.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final Experience experienceToAdd = Experience(
        position: experienceNameController.text,
        company: organizationController.text,
        startDate: selectedstartDate!,
        experienceId: '',
        endDate: selectedendDate,
        description: descriptionController.text,
      );

      print(
          'Saving Experience with DateTime objects: start: $selectedstartDate, Expiry: $selectedendDate');
      print(context.read<ProfileCubit>().firstname);

      context.read<ProfileCubit>().addExperience(experienceToAdd);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Add Experience'),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: saveExperience,
            tooltip: 'Save Experience',
          )
        ],
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is ExperienceAdded) {
            int count = 0;
            Navigator.of(context).pushNamedAndRemoveUntil(
              Routes.profileScreen,
              (route) => count++ >= 2,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Experience added successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return Center(child: CircularProgressIndicator());
          }

          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Add experience',
                          style: TextStyle(
                            fontSize: 25.sp,
                            fontWeight: FontWeight.bold,
                          )),
                      SizedBox(height: 8.h),
                      Text('* Indicates required field',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.grey[500],
                          )),
                      SizedBox(height: 20.h),
                    ],
                  ),
                  CustomRectangularTextFormField(
                    key: Key('profileAddExperience_ExperienceName_textField'),
                    controller: experienceNameController,
                    labelText: 'position*',
                    hintText: 'Ex: Junior AI Engineer ',
                    maxLength: 255,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Experience name is required.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),
                  CustomRectangularTextFormField(
                    key: Key(
                        'profileAddExperience_issuingOrganization_textField'),
                    controller: organizationController,
                    labelText: 'Company or organization*',
                    hintText: 'Ex: Microsoft',
                    maxLength: 250,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Issuing Organization is required.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),
                  CustomRectangularTextFormField(
                    key: Key('profileAddExperience_startDate_textField'),
                    controller: startDateController,
                    labelText: 'Start Date*',
                    readOnly: true,
                    onTap: () =>
                        _selectYear(context, startDateController, true),
                  ),
                  SizedBox(height: 16.h),
                  CustomRectangularTextFormField(
                    key: Key('profileAddExperience_endDate_textField'),
                    controller: endDateController,
                    labelText: 'End Date',
                    readOnly: true,
                    onTap: () => _selectYear(context, endDateController, false),
                  ),
                  SizedBox(height: 16.h),
                  CustomRectangularTextFormField(
                    key: Key('profileAddExperience_description_textField'),
                    controller: descriptionController,
                    labelText: 'Description*',
                    hintText: 'Add a description of your job',
                    maxLength: 1000,
                    maxLines: 4,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Description is required.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 40.h),
                  SizedBox(
                    width: double.infinity,
                    height: 40.h,
                    child: ElevatedButton(
                      key: Key('profileAddExperience_save_button'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsManager.crimsonRed,
                      ),
                      onPressed: saveExperience,
                      child: Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
