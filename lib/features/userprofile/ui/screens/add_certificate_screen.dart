import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/features/companypages/ui/widgets/form/custom_text_field.dart';
import 'package:joblinc/features/userprofile/data/models/certificate_model.dart';
import 'package:joblinc/features/userprofile/logic/cubit/profile_cubit.dart';

class UserAddCertificateScreen extends StatefulWidget {
  @override
  _UserAddCertificateScreenState createState() =>
      _UserAddCertificateScreenState();
}

class _UserAddCertificateScreenState extends State<UserAddCertificateScreen> {
  // Form controllers
  late TextEditingController certificateNameController;
  late TextEditingController issuingOrganizationController;
  late TextEditingController issueDateController;
  late TextEditingController expirationDateController;

  // Store actual DateTime objects for accurate parsing
  DateTime? selectedIssueDate;
  DateTime? selectedExpirationDate;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    certificateNameController = TextEditingController();
    issuingOrganizationController = TextEditingController();
    issueDateController = TextEditingController();
    expirationDateController = TextEditingController();
  }

  @override
  void dispose() {
    certificateNameController.dispose();
    issuingOrganizationController.dispose();
    issueDateController.dispose();
    expirationDateController.dispose();
    super.dispose();
  }

  // Method to show month/year picker
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

  void saveCertificate() {
    if (_formKey.currentState!.validate()) {
      if (selectedIssueDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select an issue date.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final Certification certificateToAdd = Certification(
        name: certificateNameController.text,
        organization: issuingOrganizationController.text,
        startYear: selectedIssueDate!,
        endYear: selectedExpirationDate,
        certificationId: '',
      );

      print(
          'Saving certificate with DateTime objects: Issue: $selectedIssueDate, Expiry: $selectedExpirationDate');
      print(context.read<ProfileCubit>().firstname);

      context.read<ProfileCubit>().addCertificate(certificateToAdd);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Add Certificate'),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: saveCertificate,
            tooltip: 'Save Certificate',
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
          } else if (state is CertificateAdded) {
            int count = 0;
            Navigator.of(context).pushNamedAndRemoveUntil(
              Routes.profileScreen,
              (route) => count++ >= 2,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Certificate added successfully!'),
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
                      Text('Add license or certification',
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

                  // Certificate Name
                  CustomRectangularTextFormField(
                    key: Key('profileAddCertificate_certificateName_textField'),
                    controller: certificateNameController,
                    labelText: 'Certificate Name*',
                    hintText: 'Ex: Microsoft certified network associate ',
                    maxLength: 255,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Certificate Name is required.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),

                  // Issuing Organization
                  CustomRectangularTextFormField(
                    key: Key(
                        'profileAddCertificate_issuingOrganization_textField'),
                    controller: issuingOrganizationController,
                    labelText: 'Issuing Organization*',
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

                  // Issue Date
                  CustomRectangularTextFormField(
                    key: Key('profileAddCertificate_issueDate_textField'),
                    controller: issueDateController,
                    labelText: 'Issue Date*',
                    readOnly: true,
                    onTap: () =>
                        _selectYear(context, issueDateController, true),
                  ),
                  SizedBox(height: 16.h),

                  // Expiration Date
                  CustomRectangularTextFormField(
                    key: Key('profileAddCertificate_expirationDate_textField'),
                    controller: expirationDateController,
                    labelText: 'Expiration Date',
                    readOnly: true,
                    onTap: () =>
                        _selectYear(context, expirationDateController, false),
                  ),
                  SizedBox(height: 200.h),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 40.h,
                    child: ElevatedButton(
                      key: Key('profileAddCertificate_save_button'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsManager.crimsonRed,
                      ),
                      onPressed: saveCertificate,
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
