import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/features/companypages/data/data/repos/createcompany_repo.dart';
import 'package:joblinc/features/companypages/ui/widgets/edit_button.dart';
import 'package:joblinc/features/companypages/ui/widgets/form/industry_comboBox.dart';
import 'package:joblinc/features/companypages/ui/widgets/form/joblincUrl_textField.dart';
import 'package:joblinc/features/companypages/ui/widgets/form/organizationType_comboBox.dart';
import 'package:joblinc/features/companypages/ui/widgets/form/overview_textField.dart';
import '../../../../core/widgets/hyperlink.dart';
import '../../data/data/company.dart';
import '../widgets/square_avatar.dart';
import '../widgets/form/name_textField.dart';
import '../widgets/form/website_textField.dart';
import '../widgets/form/organizationSize_comboBox.dart';
import '../widgets/form/submit_company.dart';
import '../widgets/form/terms_and_conditions.dart';
import '../../logic/cubit/create_company_cubit.dart';

// ignore: must_be_immutable
class CreateCompanyPage extends StatelessWidget {
  CreateCompanyPage({super.key, this.cubit}); 
  final _formKey = GlobalKey<FormState>();
  final _termsAndConditionsKey = GlobalKey<TermsAndConditionsCheckBoxState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _jobLincUrlController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _overviewController = TextEditingController();
  late Industry _selectedIndustry;
  late OrganizationSize _orgSize;
  late OrganizationType _orgType;
  
  final CreateCompanyCubit? cubit; 
  bool get isTestEnvironment {
    return Platform.environment.containsKey('FLUTTER_TEST');
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit ?? CreateCompanyCubit(
        getIt<CreateCompanyRepo>(),
        onCompanyCreated: (company) {
          // Navigate to the Company Dashboard
          Navigator.pushNamed(
            context,
            Routes.companyDashboard,
            arguments: company,
          );
        },
      ),
      child: BlocListener<CreateCompanyCubit, CreateCompanyState>(
        listener: (context, state) {
          if (state is CreateCompanySuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Company created successfully!')),
            );
          } else if (state is CreateCompanyFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Failed to create company. Please try again.')),
            );
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Color(0xFFFAFAFA),
            centerTitle: true, // Center the title
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.grey.shade600),
              onPressed: () {
                Navigator.pop(context); // Navigate back
              },
            ),
            title: Row(
              children: [
                Text(
                  "Create page",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                    color: Colors.grey.shade800,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 170),
                  child: SubmitCompany(
                    formKey: _formKey,
                    onTap: () {
                      if (_formKey.currentState!.validate() &&
                          _termsAndConditionsKey.currentState!.validate() ==
                              null) {
                        // Form is valid, proceed with submission using the Cubit
                        print('Form is valid');
                        context.read<CreateCompanyCubit>().createCompany(
                              nameController: _nameController,
                              jobLincUrlController: _jobLincUrlController,
                              selectedIndustry: _selectedIndustry,
                              orgSize: _orgSize,
                              orgType: _orgType,
                              websiteController: _websiteController,
                              overviewController: _overviewController,
                            );
                      } else {
                        print('Form is invalid');
                        _termsAndConditionsKey.currentState!.validate();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    if (!isTestEnvironment)
                      Image(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            "https://thingscareerrelated.com/wp-content/uploads/2021/10/default-background-image.png"), // Company Cover goes here
                        width: double.infinity,
                        height: 90.h,
                      ),
                    if (!isTestEnvironment)
                      Padding(
                        padding: EdgeInsets.only(top: 50.h, left: 17.w),
                        child: SquareAvatar(
                          imageUrl:
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTfphRB8Syzj7jIYXedFOeVZwicec0QaUv2cBwPc0l7NnXdjBKpoL9nDSeX46Tich1Razk&usqp=CAU",
                          size: 80,
                        ),
                      ),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 85.h, left: 60.h),
                          child: EditButton(),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 90.h, left: 75.h),
                          child: Text(
                            "* Indicates required",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CompanyNameTextFormField(
                          nameController: _nameController,
                          key: Key('createcompany_name_textfield'),
                        ),
                        SizedBox(height: 10.h),
                        CompanyjobLincUrlTextFormField(
                          key: Key('createcompany_jobLincUrl_textfield'),
                          jobLincUrlController: _jobLincUrlController,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          child: Hyperlink(
                            key: Key('createcompany_publicPageUrl_hyperlink'),
                            text: "Learn more about the Page Public URL",
                            color: Colors.grey.shade700,
                            size: 16,
                            url:
                                "https://www.linkedin.com/help/linkedin/answer/a564298/?lang=en",
                          ),
                        ),
                        CompanyWebsiteTextFormField(
                          key: Key('createcompany_website_textfield'),
                          websiteController: _websiteController,
                        ),
                        SizedBox(height: 20.h),
                        IndustryDropdown(
                          key: Key('createcompany_industry_dropdown'),
                          value: null,
                          onChanged: (value) {
                            _selectedIndustry = value!;
                          },
                        ),
                        SizedBox(height: 20.h),
                        OrganizationSizeDropdown(
                          key: Key('createcompany_orgSize_dropdown'),
                          value: null,
                          onChanged: (value) {
                            _orgSize = value!;
                          },
                        ),
                        SizedBox(height: 5.h),
                        OrganizationTypeDropdown(
                          key: Key('createcompany_orgType_dropdown'),
                          value: null,
                          onChanged: (value) {
                            _orgType = value!;
                          },
                        ),

                         SizedBox(height: 10.h),
                        OverviewTextFormField(
                          overviewController: _overviewController,
                          key: Key('createcompany_overview_textfield'),
                        ),
                        
                        SizedBox(height: 10.h),
                        TermsAndConditionsCheckBox(
                          key: _termsAndConditionsKey,
                        ),
                       
                        SizedBox(height: 10.h),
                        Hyperlink(
                          key: Key('createcompany_termsAndConditions_hyperlink'),
                          text: "Read the LinkedIn Pages Terms",
                          color: Colors.grey.shade700,
                          url:
                              "https://www.linkedin.com/legal/l/linkedin-pages-terms",
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}