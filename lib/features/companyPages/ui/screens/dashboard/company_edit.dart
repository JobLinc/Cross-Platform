import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/features/companypages/data/data/company.dart';
import 'package:joblinc/features/companypages/data/data/models/update_company_model.dart';
import 'package:joblinc/features/companypages/logic/cubit/edit_company_cubit.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/features/companypages/ui/widgets/form/industry_comboBox.dart';
import 'package:joblinc/features/companypages/ui/widgets/form/joblincUrl_textField.dart';
import 'package:joblinc/features/companypages/ui/widgets/form/name_textField.dart';
import 'package:joblinc/features/companypages/ui/widgets/form/organizationSize_comboBox.dart';
import 'package:joblinc/features/companypages/ui/widgets/form/organizationType_comboBox.dart';
import 'package:joblinc/features/companypages/ui/widgets/form/overview_textField.dart';
import 'package:joblinc/features/companypages/ui/widgets/form/website_textField.dart';
import 'package:joblinc/core/di/dependency_injection.dart';

class CompanyPageEditScreen extends StatefulWidget {
  final Company company;
  const CompanyPageEditScreen({super.key, required this.company});

  @override
  State<CompanyPageEditScreen> createState() => _CompanyPageEditScreenState();
}

class _CompanyPageEditScreenState extends State<CompanyPageEditScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _formInitialized = false;

  late TextEditingController companyNameController;
  late TextEditingController websiteController;
  late TextEditingController jobLincUrlController;
  late TextEditingController overviewController;
  late TextEditingController cityController;
  late TextEditingController countryController;
  late Industry selectedIndustry;
  late OrganizationSize selectedOrgSize;
  late OrganizationType selectedOrgType;

  @override
  void initState() {
    super.initState();
    companyNameController = TextEditingController();
    websiteController = TextEditingController();
    jobLincUrlController = TextEditingController();
    overviewController = TextEditingController();
    cityController = TextEditingController();
    countryController = TextEditingController();

    // Initialize dropdown values from company or use defaults
    selectedIndustry = IndustryExtension.fromDisplayName(widget.company.industry) ?? Industry.technology;
    selectedOrgSize = OrganizationSizeExtension.fromDisplayName(widget.company.organizationSize) ?? OrganizationSize.elevenToFifty;
    selectedOrgType = OrganizationTypeExtension.fromDisplayName(widget.company.organizationType) ?? OrganizationType.privatelyHeld;
  }

  @override
  void dispose() {
    companyNameController.dispose();
    websiteController.dispose();
    jobLincUrlController.dispose();
    overviewController.dispose();
    cityController.dispose();
    countryController.dispose();
    super.dispose();
  }

  void updateCompanyData() {
    if (_formKey.currentState!.validate()) {
      final updateModel = UpdateCompanyModel(
        name: companyNameController.text.isNotEmpty
            ? companyNameController.text
            : null,
        website:
            websiteController.text.isNotEmpty ? websiteController.text : null,
        urlSlug: jobLincUrlController.text.isNotEmpty
            ? jobLincUrlController.text
            : null,
        overview:
            overviewController.text.isNotEmpty ? overviewController.text : null,
        industry: selectedIndustry.displayName,
        size: selectedOrgSize.displayName,
        type: selectedOrgType.displayName,
      );
      context.read<EditCompanyCubit>().updateCompany(updateModel);
    }
  }

  void _initializeForm() {
    if (!_formInitialized) {
      companyNameController.text = widget.company.name;
      websiteController.text = widget.company.website ?? '';
      jobLincUrlController.text = widget.company.profileUrl;
      overviewController.text = widget.company.overview!;
      cityController.text = widget.company.city ?? '';
      countryController.text = widget.company.country ?? '';

      _formInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditCompanyCubit>(
      create: (_) => getIt<EditCompanyCubit>(),
      child: BlocConsumer<EditCompanyCubit, EditCompanyState>(
        listener: (context, state) {
          if (state is EditCompanyFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          } else if (state is EditCompanySuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Company updated successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            widget.company.name = companyNameController.text;
            widget.company.website = websiteController.text;
            widget.company.profileUrl = jobLincUrlController.text;
            widget.company.overview = overviewController.text;
            widget.company.industry = selectedIndustry.displayName;
            widget.company.organizationSize = selectedOrgSize.displayName;
            widget.company.organizationType = selectedOrgType.displayName;

            Navigator.pushReplacementNamed(
              context,
              Routes.companyPageHome,
              arguments: {'company': widget.company, 'isAdmin': true},
            );
          }
        },
        builder: (context, state) {
          _initializeForm();
          return Scaffold(
            appBar: AppBar(
              title: const Text("Edit Company"),
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CompanyNameTextFormField(
                            nameController: companyNameController),
                        SizedBox(height: 16.h),
                        CompanyWebsiteTextFormField(
                            websiteController: websiteController),
                        SizedBox(height: 16.h),
                        CompanyjobLincUrlTextFormField(
                            jobLincUrlController: jobLincUrlController),
                        SizedBox(height: 16.h),
                        OverviewTextFormField(
                            overviewController: overviewController),
                        SizedBox(height: 16.h),
                        IndustryDropdown(
                          value: selectedIndustry,
                          onChanged: (value) {
                            selectedIndustry = value!;
                          },
                        ),
                        SizedBox(height: 20.h),
                        OrganizationSizeDropdown(
                          value: selectedOrgSize,
                          onChanged: (value) {
                            selectedOrgSize = value!;
                          },
                        ),
                        SizedBox(height: 5.h),
                        OrganizationTypeDropdown(
                          value: selectedOrgType,
                          onChanged: (value) {
                            selectedOrgType = value!;
                          },
                        ),
                        // Add other fields here
                        SizedBox(height: 16.h),
                        TextButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, 
                            Routes.companyLocations,
                            arguments: widget.company
                          ),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 12.h),
                          shape: StadiumBorder(
                            side: BorderSide(
                              color: ColorsManager.crimsonRed,
                            ),
                          ),
                        ),
                        child: Text(
                          'Manage Company Locations',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: ColorsManager.crimsonRed,
                          ),
                        ),
                      ),
                        SizedBox(height: 80.h), // Extra space for the button
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                    color: Colors.white,
                    child: SizedBox(
                      height: 30.h,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorsManager.crimsonRed,
                        ),
                        onPressed: updateCompanyData,
                        child: Text(
                          'Save',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
