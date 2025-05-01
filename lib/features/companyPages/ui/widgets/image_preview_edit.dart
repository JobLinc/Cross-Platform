// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/core/widgets/custom_snackbar.dart';
import 'package:joblinc/features/companypages/data/data/company.dart';
import 'package:joblinc/features/companypages/logic/cubit/edit_company_cubit.dart';
import 'package:joblinc/features/userprofile/data/service/file_pick_service.dart';

class CompanyImages extends StatelessWidget {
  final Company company;
  final bool iscover;
  final bool isadmin;
  const CompanyImages({
    Key? key,
    required this.company,
    required this.iscover,
    required this.isadmin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditCompanyCubit, EditCompanyState>(
      listener: (context, state) {
        if (state is EditCompanyFailed) {
        } else if (state is EditCompanySuccess) {
          CustomSnackBar.show(
              context: context,
              message: 'COPANY UPDAAATED',
              type: SnackBarType.success);
        } else if (state is EditCompanyFailure) {
          CustomSnackBar.show(
              context: context,
              message: 'COPANY UPDAAATED',
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
              // context.read<EditCompanyCubit>().getUserProfile();
              //BlocProvider.of<EditCompanyCubit>(context).getUserProfile();
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
                    "${company.logoUrl}",
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
                              // final EditCompanyCubit EditCompanyCubit = context.read<EditCompanyCubit>();

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
                                            context
                                                .read<EditCompanyCubit>()
                                                .uploadCompanyLogo(image);
                                          }

                                          Navigator.pop(
                                              bottomSheetContext); // Close the bottom sheet
                                          int count = 0;
                                          company.logoUrl = image.path;
                                          Navigator.of(context)
                                              .pushNamedAndRemoveUntil(
                                            Routes.profileScreen,
                                            (route) => count++ >= 2,
                                          );
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
                                          // Do something when Tile 2 is tapped
                                          print("Tile 2 tapped");
                                          if (image == null) {
                                            return;
                                          }
                                          if (iscover) {
                                          } else {
                                            context
                                                .read<EditCompanyCubit>()
                                                .uploadCompanyLogo(image);
                                          }
                                          // Response response = await getIt<UserProfileRepository>()
                                          //     .uploadProfilePicture(image!);
                                          // print(response.statusCode);
                                          Navigator.pop(
                                              bottomSheetContext); // Close the bottom sheet
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
                            onTap: () {
                              // Button 2 action
                            },
                            child: IconButton(
                                onPressed: () {
                                  //context.read<EditCompanyCubit>().deleteCoverPicture();
                                },
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
