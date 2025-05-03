import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/helpers/auth_helpers/auth_service.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/core/widgets/custom_snackbar.dart';
import 'package:joblinc/features/companypages/data/data/company.dart';
import 'package:joblinc/features/companypages/logic/cubit/edit_company_cubit.dart';
import 'package:joblinc/features/userprofile/data/service/file_pick_service.dart';

class CompanyImages extends StatelessWidget {
  final Company company;
  final AuthService authService = getIt<AuthService>();
  final bool iscover;
  final bool isadmin;
  CompanyImages({
    Key? key,
    required this.company,
    required this.iscover,
    required this.isadmin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    authService.refreshToken(companyId: company.id);
    return BlocListener<EditCompanyCubit, EditCompanyState>(
      listener: (context, state) {
        if (state is EditCompanyFailed) {
        } else if (state is EditCompanySuccess) {
          CustomSnackBar.show(
              context: context,
              message: 'Company updated successfully',
              type: SnackBarType.success);
        } else if (state is EditCompanyFailure) {
          CustomSnackBar.show(
              context: context,
              message: 'Failed to update company: ${state.error}',
              type: SnackBarType.error);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            iscover ? 'Cover Photo' : 'Profile Photo',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ),
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            children: [
              // Expanded Image Viewer
              Expanded(
                child: Center(
                  child: Image.network(
                    iscover ? "${company.coverUrl}" : "${company.logoUrl}",
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.person,
                        size: 80,
                        color: Colors.grey.shade400,
                      );
                    },
                  ),
                ),
              ),

              // Footer with 2 Image Buttons
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    isadmin
                        ? GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (bottomSheetContext) => Container(
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        leading: Icon(Icons.camera_alt),
                                        title: Text("Take a photo"),
                                        onTap: () async {
                                          File? image =
                                              await pickImage("camera");
                                          // Do something when Tile 1 is tapped
                                          print("Tile 1 tapped");

                                          if (image == null) {
                                            return;
                                          }

                                          if (iscover) {
                                          } else {
                                            Company? apiCompany = await context
                                                .read<EditCompanyCubit>()
                                                .uploadCompanyLogo(image);

                                            Navigator.pop(
                                                bottomSheetContext); // Close the bottom sheet
                                            int count = 0;
                                            if (apiCompany != null) {
                                              Navigator.pushNamedAndRemoveUntil(
                                                  context,
                                                  Routes.homeScreen,
                                                  (Route<dynamic> route) =>
                                                      false);
                                            } else {
                                              CustomSnackBar.show(
                                                  context: context,
                                                  message:
                                                      'Error uploading image',
                                                  type: SnackBarType.error);
                                            }
                                          }

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content:
                                                  Text("Updated succefully"),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                        },
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.photo_library),
                                        title: Text("Upload from photos"),
                                        onTap: () async {
                                          File? image =
                                              await pickImage("gallery");
                                          print("Tile 2 tapped");
                                          if (image == null) {
                                            return;
                                          }
                                          final loadingSnackBar = SnackBar(
                                            content: Row(
                                              children: [
                                                SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: Colors.white,
                                                    strokeWidth: 2,
                                                  ),
                                                ),
                                                SizedBox(width: 16),
                                                Text("Uploading image..."),
                                              ],
                                            ),
                                            backgroundColor: Colors.black87,
                                            duration: Duration(minutes: 1),
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(loadingSnackBar);
                                          // Close the bottom sheet after showing the snackbar
                                          Navigator.pop(bottomSheetContext);
                                          if (iscover) {
                                            Company? apiCompany = await context
                                                .read<EditCompanyCubit>()
                                                .uploadCompanyCover(image);

                                            ScaffoldMessenger.of(context)
                                                .hideCurrentSnackBar();

                                            if (apiCompany != null) {
                                              Navigator.pushNamedAndRemoveUntil(
                                                  context,
                                                  Routes.homeScreen,
                                                  (Route<dynamic> route) =>
                                                      false);
                                            } else {
                                              CustomSnackBar.show(
                                                  context: context,
                                                  message:
                                                      'Error uploading image',
                                                  type: SnackBarType.error);
                                            }
                                          } else {
                                            Company? apiCompany = await context
                                                .read<EditCompanyCubit>()
                                                .uploadCompanyLogo(image);

                                            ScaffoldMessenger.of(context)
                                                .hideCurrentSnackBar();

                                            if (apiCompany != null) {
                                              Navigator.pushNamedAndRemoveUntil(
                                                context, Routes.homeScreen, 
                                                (Route <dynamic> route) => false
                                              );
                                            } else {
                                              CustomSnackBar.show(
                                                  context: context,
                                                  message:
                                                      'Error uploading image',
                                                  type: SnackBarType.error);
                                            }
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: Icon(Icons.upload,
                                color: ColorsManager.warmWhite))
                        : SizedBox.shrink(),
                    isadmin
                        ? GestureDetector(
                            onTap: () async {
                              // Show loading snackbar
                              final loadingSnackBar = SnackBar(
                                content: Row(
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Text("Deleting image..."),
                                  ],
                                ),
                                backgroundColor: Colors.black87,
                                duration: Duration(minutes: 1),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(loadingSnackBar);

                              Company? apiCompany;
                              if (iscover) {
                                apiCompany = await context
                                    .read<EditCompanyCubit>()
                                    .removeCompanyCover();
                              } else {
                                apiCompany = await context
                                    .read<EditCompanyCubit>()
                                    .removeCompanyLogo();
                              }

                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();

                              if (apiCompany != null) {
                                Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    Routes.homeScreen,
                                    (Route<dynamic> route) => false);
                              } else {
                                CustomSnackBar.show(
                                  context: context,
                                  message: 'Error deleting image',
                                  type: SnackBarType.error,
                                );
                                Navigator.of(context).pop();
                              }
                            },
                            child: IconButton(
                                onPressed: null,
                                icon: Icon(
                                  Icons.delete,
                                  color: ColorsManager.darkBurgundy,
                                )),
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
