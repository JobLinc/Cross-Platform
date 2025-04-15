import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/features/companypages/ui/widgets/form/custom_text_field.dart';
import 'package:joblinc/features/signup/ui/widgets/city_text_field.dart';
import 'package:joblinc/features/signup/ui/widgets/country_text_field.dart';
import 'package:joblinc/features/userprofile/logic/cubit/profile_cubit.dart';
import 'package:joblinc/features/userprofile/data/models/update_user_profile_model.dart';

class EditUserProfileScreen extends StatefulWidget {
  @override
  _EditUserProfileScreenState createState() => _EditUserProfileScreenState();
}

class _EditUserProfileScreenState extends State<EditUserProfileScreen> {
  // Form controllers
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController headlineController;
  late TextEditingController addressController;
  late TextEditingController cityController;
  late TextEditingController countryController;
  late TextEditingController phoneController;
  late TextEditingController biographyController;

  final _formKey = GlobalKey<FormState>();
  bool _formInitialized = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    headlineController = TextEditingController();
    addressController = TextEditingController();
    cityController = TextEditingController();
    countryController = TextEditingController();
    phoneController = TextEditingController();
    biographyController = TextEditingController();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    headlineController.dispose();
    addressController.dispose();
    cityController.dispose();
    countryController.dispose();
    phoneController.dispose();
    biographyController.dispose();
    super.dispose();
  }

  // Initialize form with existing profile data
  void _initializeForm(profile) {
    if (!_formInitialized) {
      firstNameController.text = profile.firstname;
      lastNameController.text = profile.lastname;
      headlineController.text = profile.headline;
      // addressController.text = profile.address ?? '';
      cityController.text = profile.city ?? '';
      countryController.text = profile.country ?? '';
      phoneController.text = profile.phoneNumber ?? '';
      biographyController.text = profile.biography ?? '';
      _formInitialized = true;
    }
  }

  void updateProfileData() {
    if (_formKey.currentState!.validate()) {
      // Create update model with only the fields that are active in the form
      final updateData = UserProfileUpdateModel(
        firstName: firstNameController.text.isNotEmpty
            ? firstNameController.text
            : null,
        lastName:
            lastNameController.text.isNotEmpty ? lastNameController.text : null,
        headline:
            headlineController.text.isNotEmpty ? headlineController.text : null,
        address:
            addressController.text.isNotEmpty ? addressController.text : null,
        city: cityController.text.isNotEmpty ? cityController.text : null,
        country:
            countryController.text.isNotEmpty ? countryController.text : null,
        phoneNo: phoneController.text.isNotEmpty ? phoneController.text : null,
        biography: biographyController.text.isNotEmpty
            ? biographyController.text
            : null,
      );

      print('Updating profile with: ${updateData.toJson()}');

      context.read<ProfileCubit>().updateUserProfile(updateData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit intro'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, Routes.profileScreen);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: updateProfileData,
            tooltip: 'Save Changes',
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
          } else if (state is ProfileUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            context.read<ProfileCubit>().getUserProfile();
            Navigator.pushReplacementNamed(context, Routes.profileScreen);
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is ProfileUpdating) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Updating ${state.operation}...'),
                ],
              ),
            );
          }

          if (state is ProfileLoaded) {
            final profile = state.profile;
            // Initialize form with profile data
            _initializeForm(profile);

            return Stack(
              children: [
                // Main content with extra bottom padding for the save button
                Container(
                  color: Colors.white,
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(
                        left: 16.0,
                        right: 16.0,
                        top: 16.0,
                        bottom: 80.0, // Extra padding at bottom for button
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Personal Information',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          SizedBox(height: 16),

                          // First Name
                          CustomRectangularTextFormField(
                            key: Key('firstName_updateProfile_textField'),
                            controller: firstNameController,
                            labelText: 'First name*',
                            maxLength: 50,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'First Name is a required field.';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 15.h),

                          // Last Name
                          CustomRectangularTextFormField(
                            key: Key('lastName_updateProfile_textField'),
                            controller: lastNameController,
                            labelText: 'Last name*',
                            maxLength: 50,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Last name is a required field.';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 15.h),

                          // Headline
                          CustomRectangularTextFormField(
                            key: Key('headline_updateProfile_textField'),
                            controller: headlineController,
                            labelText: 'Headline*',
                            maxLength: 220,
                            maxLines: 3,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Headline is a required field.';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 30.h),

                          // Contact Information Section
                          Text(
                            'Contact Information',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          SizedBox(height: 16),

                          // Phone
                          CustomRectangularTextFormField(
                            controller: phoneController,
                            labelText: 'Phone Number',
                            hintText: 'e.g. 01123456789',
                            maxLength: 25,
                            prefixIcon: Icon(Icons.phone),
                          ),

                          SizedBox(height: 16.h),

                          //Address
                          CustomRectangularTextFormField(
                            key: Key('address_updateProfile_textField'),
                            controller: addressController,
                            labelText: 'Address',
                            prefixIcon: Icon(Icons.location_on),
                            hintText: "Enter your address",
                            maxLength: 220,
                            maxLines: 3,
                          ),
                          SizedBox(height: 16.h),

                          // Country
                          CountryTextFormField(
                              key: Key('editUserProfile_country_textfield'),
                              countryController: countryController),
                          SizedBox(height: 15.h),

                          // City
                          CityTextFormField(
                            key: Key('editUserProfile_city_textfield'),
                            cityController: cityController,
                            selectedCity: cityController.text.isNotEmpty
                                ? cityController.text
                                : profile.city,
                          ),

                          SizedBox(height: 15.h),

                          // Biography Section
                          Text(
                            'Edit about',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          SizedBox(height: 16),

                          // Biography
                          CustomRectangularTextFormField(
                            key: Key('biography_updateProfile_textField'),
                            controller: biographyController,
                            labelText:
                                'You can write about your years of experience, industry, or skills. People also talk about their achievements or previous job experiences.',
                            hintText: 'Tell us about yourself',
                            maxLines: 20,
                            maxLength: 2600,
                          ),
                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),
                  ),
                ),

                // Persistent save button at bottom
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, -2),
                        ),
                      ],
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorsManager.crimsonRed,
                        ),
                        onPressed: updateProfileData,
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
                ),
              ],
            );
          }

          // Default state - should rarely be seen
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('No profile data available'),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () =>
                      context.read<ProfileCubit>().getUserProfile(),
                  child: Text('Load Profile'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
