import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/features/jobs/data/models/job_model.dart';
import 'package:joblinc/features/jobs/data/models/search_filter_request_DTO.dart';
import 'package:joblinc/features/jobs/logic/cubit/job_list_cubit.dart';
import 'package:joblinc/features/jobs/ui/widgets/job_card.dart';

class JobSearchScreen extends StatefulWidget {
  const JobSearchScreen({super.key});

  @override
  State<JobSearchScreen> createState() => _JobSearchScreenState();
}

class _JobSearchScreenState extends State<JobSearchScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  List<Map<String, dynamic>>? companies;
  Map<String, dynamic>? searchFilterParams;
  //final parentContext= context;

  SearchFilter searchFilter = SearchFilter();

  List<Job>? searchedJobs;

  @override
  void initState() {
    super.initState();
    context.read<JobListCubit>().emitJobSearchInitial();
    context.read<JobListCubit>().getCompanyNames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Column(
        children: [
          //Expanded(child: LinkedInProfileWidget()),
          Expanded(
            child: BlocBuilder<JobListCubit, JobListState>(
              builder: (context, state) {
                if (state is JobSearchLoading && searchedJobs == null) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is JobSearchLoaded) {
                  searchedJobs = state.searchedJobs;
                  return JobList(
                      key: ValueKey(searchedJobs!.length), jobs: searchedJobs!);
                } else if (state is JobSearchEmpty) {
                  return Center(child: Text("No jobs found."));
                } else if (state is JobSearchErrorLoading &&
                    searchedJobs == null) {
                  return Center(child: Text("Error: ${state.errorMessage}"));
                } else if (state is JobSearchInitial) {
                  return Center(
                    child:
                        Text("Start Searching to find countless opportunities"),
                  );
                } else {
                  if (searchedJobs != null) {
                    return JobList(
                        key: ValueKey(searchedJobs!.length),
                        jobs: searchedJobs!);
                  } else {
                    return Center(
                      child: Text("Something went Wrong"),
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget buildAppBar(BuildContext context) {
    final parentContext = context;
    return PreferredSize(
      preferredSize: Size.fromHeight(130.h),
      child: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back,
                          color: Colors.black, size: 24.sp),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.h),
                          child: buildSearchField(
                            keyName: "jobSearch_searchByTitle_textField",
                            controller: titleController,
                            hintText: "Search by title, skill, or Industry",
                            icon: Icons.search,
                            onChanged: (value) {
                              if (titleController.text.isNotEmpty) {
                                searchFilter.search = titleController.text;
                                parentContext.read<JobListCubit>().getAllJobs(
                                    isSearch: true,
                                    queryParams: searchFilter.toQueryParameters(
                                        fields: ["location"]));
                              } else {
                                context
                                    .read<JobListCubit>()
                                    .emitJobSearchInitial();
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.h),
                          child: buildSearchField(
                            keyName: "jobSearch_searchByLocation_textField",
                            controller: locationController,
                            hintText: "City, state, or zip code",
                            icon: Icons.location_on,
                            onChanged: (value) {
                              if (titleController.text.isNotEmpty) {
                                searchFilter.location = locationController.text;
                                parentContext.read<JobListCubit>().getAllJobs(
                                    isSearch: true,
                                    queryParams: searchFilter.toQueryParameters(
                                        fields: [
                                          "location"
                                        ])); //queryyParams: );
                              } else {
                                context
                                    .read<JobListCubit>()
                                    .emitJobSearchInitial();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10.w),
                  IconButton(
                    icon: Icon(Icons.filter_list),
                    onPressed: () async {
                      await context.read<JobListCubit>().getCompanyNames();
                      setState(() {
                        companies = context.read<JobListCubit>().companyNames;
                      });
                      buildFilterModalSheet(searchFilter, parentContext);
                      // final fetchedCompanies =
                      //     context.read<JobListCubit>().companyNames;
                      // if (fetchedCompanies != null &&
                      //     fetchedCompanies.isNotEmpty) {
                      //   setState(() {
                      //     companies = fetchedCompanies;
                      //   });
                      //   buildFilterModalSheet(searchFilter, parentContext);
                      // } else {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     SnackBar(content: Text('Could not load companies')),
                      //   );
                      // }
                    },
                  ),
                  SizedBox(width: 10.w),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSearchField({
    required String keyName,
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required ValueChanged<String> onChanged,
  }) {
    return TextField(
      key: Key(keyName),
      onChanged: onChanged,
      cursorColor: Colors.red[400],
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, size: 20.sp),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide.none),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      style: TextStyle(fontSize: 14.sp),
    );
  }

  Widget buildSearchSuggestion(String suggestion) {
    return ListTile(
      leading: Icon(Icons.search),
      title: Text(suggestion, style: TextStyle(fontWeight: FontWeight.bold)),
      onTap: () {
        titleController.text = suggestion;
      },
    );
  }

  buildFilterModalSheet(SearchFilter searchFilter, BuildContext parentContext) {
    List<String> experienceLevels = [
      'Freshman',
      'Junior',
      'MidLevel',
      'Senior'
    ];
    // Initialize checkboxes based on filter.experienceFilter contents:
    Map<String, bool> expSelected = {
      for (var level in experienceLevels)
        level: searchFilter.experienceFilter?.contains(level) ?? false,
    };

    // List<String> companyOptions = [
    //   'Google',
    //   'Microsoft',
    //   'Apple',
    //   'Amazon',
    //   'Meta',
    //   'Egyptian Co.',
    //   'TechnoCorp'
    // ];

    // Initialize checkboxes based on filter.companyFilter:
    Map<String, bool> companySelected = {
      for (var company in companies!)
        company['id']: searchFilter.companyFilter?.contains(company['id']) ?? false,
    };

    // Initialize salary controllers with filter values (or empty)
    TextEditingController minSalaryController = TextEditingController(
        text: searchFilter.minSalary != null
            ? searchFilter.minSalary.toString()
            : "");
    TextEditingController maxSalaryController = TextEditingController(
        text: searchFilter.maxSalary != null
            ? searchFilter.maxSalary.toString()
            : "");

    bool isCompanyDropdownOpen = false;

    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      enableDrag: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.6,
              padding: EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title row with Reset button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Filters",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        TextButton(
                          onPressed: () {
                            setModalState(() {
                              // Reset experience filter selections
                              expSelected.updateAll((key, value) => false);
                              searchFilter.experienceFilter = [];
                              // Reset company filter selections
                              companySelected.updateAll((key, value) => false);
                              searchFilter.companyFilter = [];
                              // Clear salary controllers and values
                              minSalaryController.clear();
                              maxSalaryController.clear();
                              searchFilter.minSalary = null;
                              searchFilter.maxSalary = null;
                              isCompanyDropdownOpen = false;
                            });
                          },
                          child: Text("Reset",
                              style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    // Experience Level Filter
                    Text("Experience Level",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: experienceLevels.map((level) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                value: expSelected[level],
                                onChanged: (bool? value) {
                                  setModalState(() {
                                    expSelected[level] = value ?? false;
                                    // Update filter.experienceFilter accordingly
                                    if (value == true) {
                                      searchFilter.experienceFilter ??= [];
                                      if (!searchFilter.experienceFilter!
                                          .contains(level)) {
                                        searchFilter.experienceFilter!
                                            .add(level);
                                      }
                                    } else {
                                      searchFilter.experienceFilter
                                          ?.remove(level);
                                    }
                                  });
                                },
                              ),
                              Text(level),
                              SizedBox(width: 4.w),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    // Salary Range Filter
                    Text("Salary Range",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 5.h,),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: minSalaryController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Min Salary",
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              setModalState(() {
                                searchFilter.minSalary =
                                    int.tryParse(value) ?? 0;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: maxSalaryController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Max Salary",
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              setModalState(() {
                                searchFilter.maxSalary =
                                    int.tryParse(value) ?? 0;
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10.h),
                    // Company Filter Dropdown with checkboxes
                    Text("Company",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    GestureDetector(
                      onTap: () {
                        setModalState(() {
                          isCompanyDropdownOpen = !isCompanyDropdownOpen;
                        });
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Text(
                            //   companySelected.values.any((selected) => selected)
                            //       ? companySelected.entries
                            //           .where((entry) => entry.value)
                            //           .map((entry) => entry.key)
                            //           .join(", ")
                            //       : "Select Companies",
                            //   style: TextStyle(color: Colors.black),
                            // ),

                            Expanded(
                              child: Text(
                                companySelected.values.any((selected) => selected)
                                    ? companies!
                                        .where((company) =>
                                            companySelected[company['id']] ==
                                            true)
                                        .map((company) => company['name'])
                                        .join(", ")
                                    : "Select Companies",
                                style: TextStyle(color: Colors.black),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(isCompanyDropdownOpen
                                ? Icons.arrow_drop_up
                                : Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                    ),
                    if (isCompanyDropdownOpen)
                      Column(
                        children: companies!.map((company) {
                          return CheckboxListTile(
                            title: Text(company['name']),
                            value: companySelected[company['id']],
                            onChanged: (bool? value) {
                              setModalState(() {
                                companySelected[company['id']] = value ?? false;
                                // Update filter.companyFilter accordingly
                                if (value == true) {
                                  searchFilter.companyFilter ??= [];
                                  if (!searchFilter.companyFilter!
                                      .contains(company['id'])) {
                                    searchFilter.companyFilter!
                                        .add(company['id']);
                                  }
                                } else {
                                  searchFilter.companyFilter
                                      ?.remove(company['id']);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    
                    SizedBox(height: 20.h),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          //if (titleController.text.isNotEmpty) {
                          parentContext.read<JobListCubit>().getAllJobs(
                              isSearch: true,
                              queryParams: searchFilter
                                  .toQueryParameters(fields: ["location"]));
                          //    }
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        child: Text("Apply Filters",
                            style: TextStyle(color: Colors.red)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}


// //import 'package:flutter/material.dart';

// class LinkedInProfileWidget extends StatelessWidget {
//   final String name;
//   final String headline;
//   final String location;
//   final String connections;
//   final String companyName;
//   final String companyDuration;
//   final String? profileImageUrl;
//   final String? companyLogoUrl;
//   final VoidCallback? onConnectPressed;
//   final VoidCallback? onMessagePressed;

//   const LinkedInProfileWidget({
//     Key? key,
//     this.name = 'Sarah Johnson',
//     this.headline = 'Senior Product Manager at Acme Tech | Ex-Google | MBA, Stanford',
//     this.location = 'San Francisco Bay Area',
//     this.connections = '500+ connections',
//     this.companyName = 'Acme Technology Inc.',
//     this.companyDuration = 'Full-time · 3 yrs 2 mos',
//     this.profileImageUrl,
//     this.companyLogoUrl,
//     this.onConnectPressed,
//     this.onMessagePressed,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 360,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 12,
//             offset: const Offset(0, 2),
//           ),
//         ],
//         border: Border.all(color: Colors.grey.shade300),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // Cover image with LinkedIn logo
//           Stack(
//             clipBehavior: Clip.none,
//             children: [
//               Container(
//                 height: 80,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       const Color(0xFF0077B5),
//                       const Color(0xFF00A0DC),
//                     ],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(8),
//                     topRight: Radius.circular(8),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 top: 10,
//                 right: 10,
//                 child: Icon(
//                   Icons.filter,
//                   color: Colors.white,
//                   size: 24,
//                 ),
//               ),
//               Positioned(
//                 top: 30,
//                 left: 20,
//                 child: Container(
//                   width: 90,
//                   height: 90,
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade200,
//                     shape: BoxShape.circle,
//                     border: Border.all(color: Colors.white, width: 4),
//                   ),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(45),
//                     child: profileImageUrl != null
//                         ? Image.network(
//                             profileImageUrl!,
//                             fit: BoxFit.cover,
//                             errorBuilder: (context, error, stackTrace) {
//                               return _buildProfilePlaceholder();
//                             },
//                           )
//                         : _buildProfilePlaceholder(),
//                   ),
//                 ),
//               ),
//             ],
//           ),
          
//           // Profile info
//           Container(
//             padding: const EdgeInsets.fromLTRB(20, 52, 20, 20),
//             alignment: Alignment.centerLeft,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   name,
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.black,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   headline,
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey.shade700,
//                     height: 1.4,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Row(
//                   children: [
//                     Icon(
//                       Icons.location_on,
//                       size: 16,
//                       color: Colors.grey.shade600,
//                     ),
//                     const SizedBox(width: 4),
//                     Text(
//                       location,
//                       style: TextStyle(
//                         fontSize: 13,
//                         color: Colors.grey.shade600,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//                 Text(
//                   connections,
//                   style: TextStyle(
//                     fontSize: 13,
//                     color: Color(0xFF0077B5),
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           ),
          
//           // Divider
//           Divider(
//             height: 1,
//             thickness: 1,
//             color: Colors.grey.shade300,
//             indent: 20,
//             endIndent: 20,
//           ),
          
//           // Current company
//           Padding(
//             padding: const EdgeInsets.all(15),
//             child: Row(
//               children: [
//                 Container(
//                   width: 42,
//                   height: 42,
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade200,
//                     borderRadius: BorderRadius.circular(6),
//                     border: Border.all(color: Colors.grey.shade300),
//                   ),
//                   child: companyLogoUrl != null
//                       ? ClipRRect(
//                           borderRadius: BorderRadius.circular(6),
//                           child: Image.network(
//                             companyLogoUrl!,
//                             fit: BoxFit.cover,
//                             errorBuilder: (context, error, stackTrace) {
//                               return _buildCompanyPlaceholder();
//                             },
//                           ),
//                         )
//                       : _buildCompanyPlaceholder(),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         companyName,
//                         style: TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       const SizedBox(height: 3),
//                       Text(
//                         companyDuration,
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: Colors.grey.shade600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
          
//           // Footer with action buttons
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//             decoration: BoxDecoration(
//               color: Colors.grey.shade100,
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(8),
//                 bottomRight: Radius.circular(8),
//               ),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 ElevatedButton(
//                   onPressed: onConnectPressed,
//                   style: ElevatedButton.styleFrom(
//                     //primary: Color(0xFF0077B5),
//                     //onPrimary: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
//                     minimumSize: Size(0, 32),
//                   ),
//                   child: Text(
//                     'Connect',
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//                 OutlinedButton(
//                   onPressed: onMessagePressed,
//                   style: OutlinedButton.styleFrom(
//                     //primary: Colors.black.withOpacity(0.6),
//                     side: BorderSide(color: Colors.black.withOpacity(0.3)),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
//                     minimumSize: Size(0, 32),
//                   ),
//                   child: Text(
//                     'Message',
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildProfilePlaceholder() {
//     return Center(
//       child: Icon(
//         Icons.person,
//         size: 45,
//         color: Colors.grey.shade400,
//       ),
//     );
//   }

//   Widget _buildCompanyPlaceholder() {
//     return Center(
//       child: Text(
//         companyName.isNotEmpty ? companyName[0] : 'A',
//         style: TextStyle(
//           fontSize: 20,
//           fontWeight: FontWeight.bold,
//           color: Colors.grey.shade700,
//         ),
//       ),
//     );
//   }
// }



// // void _showFilterBottomSheet(Filter filter,BuildContext context) {
// //   // final Filter filter = Filter(
// //   //   experienceFilter: [],
// //   //   companyFilter: [],
// //   //   minSalary: null,
// //   //   maxSalary: null,
// //   // );

// //   // Experience level options
// //   final experienceLevels = ['Entry', 'Mid', 'Senior'];
  
// //   // Company options (example companies - replace with your actual list)
// //   final companies = ['Google', 'Apple', 'Microsoft', 'Amazon', 'Meta', 'Netflix', 'IBM', 'Oracle'];
  
// //   // Initialize selected experience levels
// //   Map<String, bool> experienceSelected = {};
// //   for (var level in experienceLevels) {
// //     experienceSelected[level] = filter.experienceFilter != null && 
// //                                 filter.experienceFilter!.contains(level);
// //   }
  
// //   // Initialize selected companies
// //   Map<String, bool> companySelected = {};
// //   for (var company in companies) {
// //     companySelected[company] = filter.companyFilter != null && 
// //                                filter.companyFilter!.contains(company);
// //   }
  
// //   // TextEditingControllers for salary inputs
// //   final minSalaryController = TextEditingController(
// //     text: filter.minSalary != null ? filter.minSalary.toString() : ''
// //   );
// //   final maxSalaryController = TextEditingController(
// //     text: filter.maxSalary != null ? filter.maxSalary.toString() : ''
// //   );
  
// //   showModalBottomSheet(
// //     context: context,
// //     isScrollControlled: true,
// //     isDismissible: true,
// //     shape: const RoundedRectangleBorder(
// //       borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
// //     ),
// //     builder: (context) {
// //       return StatefulBuilder(
// //         builder: (BuildContext context, StateSetter setState) {
// //           return Container(
// //             padding: const EdgeInsets.all(16),
// //             height: MediaQuery.of(context).size.height * 0.6, // Fixed height
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                   children: [
// //                     Text(
// //                       'Filters',
// //                       style: TextStyle(
// //                         fontSize: 18,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //                     TextButton(
// //                       onPressed: () {
// //                         setState(() {
// //                           // Reset all filters
// //                           for (var level in experienceLevels) {
// //                             experienceSelected[level] = false;
// //                           }
// //                           for (var company in companies) {
// //                             companySelected[company] = false;
// //                           }
// //                           minSalaryController.clear();
// //                           maxSalaryController.clear();
// //                         });
// //                       },
// //                       child: Text(
// //                         'Reset',
// //                         style: TextStyle(color: Colors.red),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 const SizedBox(height: 16),
                
// //                 // Make the content scrollable
// //                 Expanded(
// //                   child: SingleChildScrollView(
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         // Experience Level Filter
// //                         const Text(
// //                           'Experience Level',
// //                           style: TextStyle(
// //                             fontSize: 16,
// //                             fontWeight: FontWeight.bold,
// //                           ),
// //                         ),
// //                         const SizedBox(height: 8),
// //                         Row(
// //                           children: experienceLevels.map((level) {
// //                             return Row(
// //                               mainAxisSize: MainAxisSize.min,
// //                               children: [
// //                                 Text(level),
// //                                 Checkbox(
// //                                   value: experienceSelected[level],
// //                                   onChanged: (bool? value) {
// //                                     setState(() {
// //                                       experienceSelected[level] = value!;
// //                                     });
// //                                   },
// //                                 ),
// //                                 const SizedBox(width: 10),
// //                               ],
// //                             );
// //                           }).toList(),
// //                         ),
// //                         const SizedBox(height: 16),
                        
// //                         // Company Filter
// //                         const Text(
// //                           'Company',
// //                           style: TextStyle(
// //                             fontSize: 16,
// //                             fontWeight: FontWeight.bold,
// //                           ),
// //                         ),
// //                         const SizedBox(height: 8),
// //                         Container(
// //                           padding: const EdgeInsets.symmetric(horizontal: 12),
// //                           decoration: BoxDecoration(
// //                             border: Border.all(color: Colors.grey),
// //                             borderRadius: BorderRadius.circular(8),
// //                           ),
// //                           child: DropdownButton<String>(
// //                             isExpanded: true,
// //                             underline: const SizedBox(),
// //                             hint: const Text('Select Companies'),
// //                             onChanged: (_) {}, // Dropdown doesn't actually change selection
// //                             items: [
// //                               DropdownMenuItem<String>(
// //                                 value: '',
// //                                 child: Column(
// //                                   children: companies.map((company) {
// //                                     return CheckboxListTile(
// //                                       title: Text(company),
// //                                       value: companySelected[company],
// //                                       onChanged: (bool? value) {
// //                                         setState(() {
// //                                           companySelected[company] = value!;
// //                                         });
// //                                       },
// //                                     );
// //                                   }).toList(),
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                         const SizedBox(height: 16),
                        
// //                         // Salary Range Filter
// //                         const Text(
// //                           'Salary Range',
// //                           style: TextStyle(
// //                             fontSize: 16,
// //                             fontWeight: FontWeight.bold,
// //                           ),
// //                         ),
// //                         const SizedBox(height: 8),
// //                         Row(
// //                           children: [
// //                             Expanded(
// //                               child: TextField(
// //                                 controller: minSalaryController,
// //                                 decoration: const InputDecoration(
// //                                   labelText: 'Min Salary',
// //                                   border: OutlineInputBorder(),
// //                                 ),
// //                                 keyboardType: TextInputType.number,
// //                                 inputFormatters: [
// //                                   FilteringTextInputFormatter.digitsOnly,
// //                                 ],
// //                               ),
// //                             ),
// //                             const SizedBox(width: 16),
// //                             Expanded(
// //                               child: TextField(
// //                                 controller: maxSalaryController,
// //                                 decoration: const InputDecoration(
// //                                   labelText: 'Max Salary',
// //                                   border: OutlineInputBorder(),
// //                                 ),
// //                                 keyboardType: TextInputType.number,
// //                                 inputFormatters: [
// //                                   FilteringTextInputFormatter.digitsOnly,
// //                                 ],
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
                
// //                 const SizedBox(height: 16),
// //                 SizedBox(
// //                   width: double.infinity,
// //                   child: ElevatedButton(
// //                     onPressed: () {
// //                       // Update filter values based on selections
// //                       filter.experienceFilter = experienceLevels
// //                           .where((level) => experienceSelected[level] == true)
// //                           .toList();
                      
// //                       filter.companyFilter = companies
// //                           .where((company) => companySelected[company] == true)
// //                           .toList();
                      
// //                       if (minSalaryController.text.isNotEmpty) {
// //                         filter.minSalary = int.parse(minSalaryController.text);
// //                       }
                      
// //                       if (maxSalaryController.text.isNotEmpty) {
// //                         filter.maxSalary = int.parse(maxSalaryController.text);
// //                       }
                      
// //                       // You can now use the updated filter object
// //                       // For example, you might want to pass it back to the parent widget
// //                       Navigator.pop(context, filter);
// //                     },
// //                     style: ElevatedButton.styleFrom(
// //                       backgroundColor: Colors.blue,
// //                     ),
// //                     child: Text(
// //                       'Apply',
// //                       style: TextStyle(color: Colors.red),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           );
// //         },
// //       );
// //     },
// //   ).then((value) {
// //     // Handle the returned filter if needed
// //     if (value != null) {
// //       // Apply the filter to your data
// //       print('Experience Filters: ${value.experienceFilter}');
// //       print('Company Filters: ${value.companyFilter}');
// //       print('Min Salary: ${value.minSalary}');
// //       print('Max Salary: ${value.maxSalary}');
// //     }
// //   });
// // }