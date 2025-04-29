import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/features/companypages/ui/widgets/form/custom_text_field.dart';
import 'package:joblinc/features/userprofile/data/models/skill_model.dart';
import 'package:joblinc/features/userprofile/logic/cubit/profile_cubit.dart';

class UserAddSkillScreen extends StatefulWidget {
  @override
  _UserAddSkillScreenState createState() => _UserAddSkillScreenState();
}

class _UserAddSkillScreenState extends State<UserAddSkillScreen> {
  // Form controllers
  late TextEditingController skillNameController;

  final _formKey = GlobalKey<FormState>();

  // Skill levels and selected level
  final List<String> skillLevels = [
    "Novice",
    "Apprentice",
    "Competent",
    "Proficient",
    "Master"
  ];
  String? selectedSkillLevel;

  @override
  void initState() {
    super.initState();
    // Initialize controllers
    skillNameController = TextEditingController();
  }

  @override
  void dispose() {
    skillNameController.dispose();
    super.dispose();
  }

  void saveSkill() {
    if (_formKey.currentState!.validate()) {
      if (selectedSkillLevel == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select a skill level.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Map skill level to integer
      final level = skillLevels.indexOf(selectedSkillLevel!) + 1;

      // Create skill model
      final Skill skillToAdd =
          Skill(name: skillNameController.text, level: level, id: "");

      print('Saving skill with: ${skillToAdd.toJson()}');

      context.read<ProfileCubit>().addSkill(skillToAdd);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Add Skill'),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: saveSkill,
            tooltip: 'Save Skill',
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
          } else if (state is SkillAdded) {
            int count = 0;
            Navigator.of(context).pushNamedAndRemoveUntil(
              Routes.profileScreen,
              (route) => count++ >= 2,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Skill added successfully!'),
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
                      Text('Add skill',
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

                  // Skill Name
                  CustomRectangularTextFormField(
                    key: Key('profileAddSkill_skillName_textField'),
                    controller: skillNameController,
                    labelText: 'Skill Name*',
                    hintText: 'Ex: Project Management',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Skill is required.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 25.h),

                  // Skill Level Combo Box
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Skill Level*',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 8.h),
                      DropdownButtonFormField<String>(
                        key: Key('profileAddSkill_skillLevel_dropdown'),
                        value: selectedSkillLevel,
                        items: skillLevels
                            .map((level) => DropdownMenuItem(
                                  value: level,
                                  child: Text(level),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedSkillLevel = value;
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey[500]!, // Always gray[500]
                              width: 1.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey[500]!, // Always gray[500]
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey[500]!, // Always gray[500]
                              width: 1.0,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 12.0,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Skill level is required.';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: 25.h),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 40.h,
                    child: ElevatedButton(
                      key: Key('profileAddSkill_save_button'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsManager.crimsonRed,
                      ),
                      onPressed: saveSkill,
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
