import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/core/widgets/custom_snackbar.dart';
import 'package:joblinc/features/companypages/data/data/company.dart';
import 'package:joblinc/features/companypages/data/data/repos/getmycompany_repo.dart';
import 'package:joblinc/features/companypages/data/data/services/getmycompany.dart';
import 'package:joblinc/features/companypages/ui/widgets/form/custom_text_field.dart';
import 'package:joblinc/features/userprofile/data/models/experience_model.dart';
import 'package:joblinc/features/userprofile/logic/cubit/profile_cubit.dart';

// ignore: must_be_immutable
class UserAddExperienceScreen extends StatefulWidget {
  ExperienceResponse? experience;

  @override
  UserAddExperienceScreen({this.experience});
  _UserAddExperienceScreenState createState() =>
      _UserAddExperienceScreenState();
}

class _UserAddExperienceScreenState extends State<UserAddExperienceScreen> {
  late TextEditingController experienceNameController;
  late TextEditingController organizationController;
  late TextEditingController startDateController;
  late TextEditingController endDateController;
  late TextEditingController descriptionController;
  String? selectedCompanyId;
  String? selectedMode;
  String? selectedType;
  late TextEditingController companyNameController;

  DateTime? selectedstartDate;
  DateTime? selectedendDate;

  List<String> modes = ["OnSite", "Remote", "Hybrid"];
  List<String> types = [
    "Full-time",
    "Part-time",
    "Contract",
    "Temporary",
    "Volunteer",
    "Internship"
  ];
  List<Company> companiesList = [];

  final _formKey = GlobalKey<FormState>();
  bool isStillWorking = false;

  @override
  void initState() {
    super.initState();
    experienceNameController = TextEditingController();
    organizationController = TextEditingController();
    startDateController = TextEditingController();
    endDateController = TextEditingController();
    descriptionController = TextEditingController();
    getCompanies();

    if (widget.experience != null) {
      print('Experience ID: ${widget.experience!.id}');
      print('Experience Company ID: ${widget.experience!.company.id}');
      print('Experience Company Name: ${widget.experience!.company.name}');
      print('Experience Position: ${widget.experience!.position}');
      print('Experience Start Date: ${widget.experience!.startDate}');
      print('Experience End Date: ${widget.experience!.endDate}');
      print('Experience Description: ${widget.experience!.description}');
      print('Experience Mode: ${widget.experience!.mode}');
      print('Experience Type: ${widget.experience!.type}');

      experienceNameController.text = widget.experience!.position;
      startDateController.text =
          DateFormat('MMMM yyyy').format(widget.experience!.startDate);
      selectedstartDate = widget.experience!.startDate;
      if (widget.experience!.endDate != 'Present' &&
          DateTime.tryParse(widget.experience!.endDate) != null &&
          DateTime.parse(widget.experience!.endDate).isBefore(DateTime.now())) {
        selectedendDate = DateTime.parse(widget.experience!.endDate);
        endDateController.text =
            DateFormat('MMMM yyyy').format(selectedendDate!);
      } else {
        endDateController.text = 'Present';
        isStillWorking = true;
      }
      descriptionController.text = widget.experience!.description;
      selectedMode = widget.experience!.mode;
      selectedType = widget.experience!.type;
      // Set company dropdown or organizationController based on company id
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final expCompanyId = widget.experience!.company.id;
        if (expCompanyId == '') {
          setState(() {
            selectedCompanyId = null;
            organizationController.text = widget.experience!.company.name;
          });
        } else {
          setState(() {
            selectedCompanyId = expCompanyId;
            organizationController.text = '';
          });
        }
      });
    }
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
      firstDate: DateTime(1990),
      lastDate: isstartDate
          ? DateTime.now().add(Duration(days: 365 * 10))
          : DateTime.now(),
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

  void getCompanies() async {
    final companies = await CompanyRepositoryImpl(
      CompanyApiService(getIt<Dio>()),
    ).getAllCompanies();
    setState(() {
      companiesList = companies;
    });
  }

  void saveExperience() {
    if (_formKey.currentState!.validate()) {
      if (selectedstartDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Start date is required.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (!isStillWorking && selectedendDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Please select an end date or tick that you are currently working in this role.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (selectedendDate != null &&
          selectedstartDate!.isAfter(selectedendDate!)) {
        CustomSnackBar.show(
          context: context,
          type: SnackBarType.error,
          message: 'Start date cannot be after end date.',
        );
        return;
      }

      if ((selectedCompanyId == null || selectedCompanyId!.isEmpty) &&
          (organizationController.text.isEmpty)) {
        CustomSnackBar.show(
          context: context,
          type: SnackBarType.error,
          message: 'Please select a company or enter its name.',
        );
        return;
      }
      if (selectedCompanyId != null && selectedCompanyId!.isNotEmpty) {
        final ExperienceModel experienceToAdd = ExperienceModel(
          experienceId: '',
          companyId: selectedCompanyId!,
          position: experienceNameController.text,
          startDate: selectedstartDate!,
          endDate: selectedendDate == null
              ? 'Present'
              : DateFormat('yyyy-MM-dd').format(selectedendDate!),
          description: descriptionController.text,
          mode: selectedMode ?? '',
          type: selectedType ?? '',
        );
        print(
            'Saving Experience with DateTime objects: start: $selectedstartDate, Expiry: $selectedendDate');
        if (widget.experience == null) {
          context.read<ProfileCubit>().addExperience(experienceToAdd);
        } else {
          experienceToAdd.experienceId = widget.experience!.id;
          context.read<ProfileCubit>().editExperience(experienceToAdd);
        }
      } else {
        final ExperienceModel experienceToAdd = ExperienceModel(
          position: experienceNameController.text,
          company: organizationController.text,
          startDate: selectedstartDate!,
          endDate: selectedendDate == null
              ? 'Present'
              : DateFormat('yyyy-MM-dd').format(selectedendDate!),
          description: descriptionController.text,
          mode: selectedMode ?? '',
          type: selectedType ?? '',
          experienceId: '',
        );

        print(
            'Saving Experience with DateTime objects: start: $selectedstartDate, Expiry: $selectedendDate');
        print(context.read<ProfileCubit>());
        if (widget.experience == null) {
          context.read<ProfileCubit>().addExperience(experienceToAdd);
        } else {
          experienceToAdd.experienceId = widget.experience!.id;
          context.read<ProfileCubit>().editExperience(experienceToAdd);
        }
        
      }
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
            CustomSnackBar.show(
              context: context,
              type: SnackBarType.success,
              message: 'Experience added successfully.',
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
                  SizedBox(height: 30.h),
                  DropdownButtonFormField<String>(
                    key: Key('profileAddExperience_company_dropdown'),
                    value: selectedCompanyId,
                    items: companiesList
                        .map((company) => DropdownMenuItem<String>(
                              value: company.id,
                              child: Text(company.name),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCompanyId = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Company',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[500]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[500]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[500]!),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  CustomRectangularTextFormField(
                    key: Key('profileAddExperience_organization_textField'),
                    controller: organizationController,
                    hintText: 'If the company is not listed, add it here',
                    maxLength: 255,
                    validator: (value) {
                      if ((value == null || value.isEmpty) &&
                          (selectedCompanyId == null ||
                              selectedCompanyId!.isEmpty)) {
                        return 'Organization name is required.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 25.h),
                  DropdownButtonFormField<String>(
                    key: Key('profileAddExperience_mode_dropdown'),
                    value: selectedMode,
                    items: modes
                        .map((mode) => DropdownMenuItem<String>(
                              value: mode,
                              child: Text(mode),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedMode = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Mode',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[500]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[500]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[500]!),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  DropdownButtonFormField<String>(
                    key: Key('profileAddExperience_type_dropdown'),
                    value: selectedType,
                    items: types
                        .map((type) => DropdownMenuItem<String>(
                              value: type,
                              child: Text(type),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedType = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Type',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[500]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[500]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[500]!),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Checkbox(
                        value: isStillWorking,
                        activeColor: Colors.red,
                        onChanged: (value) {
                          setState(() {
                            isStillWorking = value!;
                            if (isStillWorking) {
                              selectedendDate = null;
                              endDateController.text = 'Present';
                            } else {
                              endDateController.clear();
                            }
                          });
                        },
                      ),
                      Text('I am still working in this role',
                          style: TextStyle(
                            fontSize: 16.sp,
                          )),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  CustomRectangularTextFormField(
                    key: Key('profileAddExperience_startDate_textField'),
                    controller: startDateController,
                    labelText: 'Start Date*',
                    readOnly: true,
                    onTap: () =>
                        _selectYear(context, startDateController, true),
                  ),
                  SizedBox(height: 10.h),
                  CustomRectangularTextFormField(
                    key: Key('profileAddExperience_endDate_textField'),
                    controller: endDateController,
                    labelText: 'End Date*',
                    readOnly: true,
                    onTap: isStillWorking
                        ? null
                        : () => _selectYear(context, endDateController, false),
                  ),
                  SizedBox(height: 20.h),
                  CustomRectangularTextFormField(
                    key: Key('profileAddExperience_description_textField'),
                    controller: descriptionController,
                    labelText: 'Description*',
                    hintText: 'Add a description of your job',
                    maxLength: 2000,
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Description is required.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
        child: SizedBox(
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
      ),
    );
  }
}
