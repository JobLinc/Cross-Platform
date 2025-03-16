import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/features/companyPages/ui/widgets/edit_button.dart';
import 'package:joblinc/features/companyPages/ui/widgets/form/industry_comboBox.dart';
import 'package:joblinc/features/companyPages/ui/widgets/form/organizationType_comboBox.dart';
import '../../../../core/widgets/hyperlink.dart';
import '../widgets/square_avatar.dart';
import '../widgets/form/name_textField.dart';
import '../widgets/form/jobLincUrl_textField.dart';
import '../widgets/form/website_textField.dart';
import '../widgets/form/organizationSize_comboBox.dart';

class CreateCompanyPage extends StatelessWidget {
  CreateCompanyPage({super.key});
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _jobLincUrlController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color(0xFFFAFAFA),
          centerTitle: true, // Center the title
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: Colors.grey.shade600), // Custom back icon
            onPressed: () {
              Navigator.pop(context); // Navigate back
            },
          ),
          title: Text(
            "Create page",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
              color: Colors.grey.shade800,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Stack(
              children: [
                Image(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                      "https://thingscareerrelated.com/wp-content/uploads/2021/10/default-background-image.png"), // Company Cover goes here
                  width: double.infinity,
                  height: 90.h,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 50.h, left: 17.w),
                  child: SquareAvatar(
                      imageUrl:
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTfphRB8Syzj7jIYXedFOeVZwicec0QaUv2cBwPc0l7NnXdjBKpoL9nDSeX46Tich1Razk&usqp=CAU",
                      size: 80),
                ),
                Row(
                  children: [
                    Padding(
                        padding: EdgeInsets.only(top: 85.h, left: 60.h),
                        child: EditButton()),
                    Padding(
                        padding: EdgeInsets.only(top: 90.h, left: 75.h),
                        child: Text(
                          "* Indicates required",
                          style: TextStyle(
                              color: Colors.grey.shade700, fontSize: 16.sp),
                        )),
                  ],
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CompanyNameTextFormField(nameController: _nameController),
                  SizedBox(height: 10.h), // Add spacing between fields
                  // Add more form fields here as needed
                  CompanyjobLincUrlTextFormField(
                      jobLincUrlController: _jobLincUrlController),

                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Hyperlink(
                          text: "Learn more about the Page Public URL",
                          color: Colors.grey.shade700,
                          size: 16,
                          url:
                              "https://www.linkedin.com/help/linkedin/answer/a564298/?lang=en")),

                  CompanyWebsiteTextFormField(
                      websiteController: _websiteController),
                  SizedBox(height: 20.h),

                  IndustryDropdown(value: null, onChanged: (value) {}),

                  SizedBox(height: 20.h),

                  OrganizationSizeDropdown(value: null, onChanged: (value) {}),

                  SizedBox(height: 5.h),

                  OrganizationTypeDropdown(value: null, onChanged: (value) {}),

                  SizedBox(height: 10.h),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: false,
                        onChanged: (value) {
                          if (value == false) {
                            value = true;
                          } else {
                            value = false;
                          }
                        },
                      ),
                      Expanded(
                        child: Text(
                          "I verify that I am an authorized representative of this organization and I have the right to act on its behalf in the creation and management of this page. The organization and I agree to the additional terms for Pages.",
                          style: TextStyle(
                            fontSize: 15.sp,
                          ),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10.h),

                  Hyperlink(
                      text: "Read the LinkedIn Pages Terms",
                      color: Colors.grey.shade700,
                      url:
                          "https://www.linkedin.com/legal/l/linkedin-pages-terms",
                      size: 16),
                ],
              ),
            ),
          ]),
        ));
  }
}
