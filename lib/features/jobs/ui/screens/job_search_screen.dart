import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/features/jobs/data/models/job_model.dart';
import 'package:joblinc/features/jobs/logic/cubit/job_list_cubit.dart';
import 'package:joblinc/features/jobs/ui/widgets/job_card.dart';

class Filter {
  List<String>? experienceFilter;
  List<String>? companyFilter;
  int? minSalary;
  int? maxSalary;

  Filter({
    this.experienceFilter,
    this.companyFilter,
    this.minSalary,
    this.maxSalary,
  });
}

class JobSearchScreen extends StatefulWidget {
  const JobSearchScreen({super.key});

  @override
  State<JobSearchScreen> createState() => _JobSearchScreenState();
}

class _JobSearchScreenState extends State<JobSearchScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  //final parentContext= context;

  Filter filter = Filter(
    experienceFilter: [],
    companyFilter: [],
  );

  List<Job>? searchedJobs;

  @override
  void initState() {
    super.initState();
    context.read<JobListCubit>().emitJobSearchInitial();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Column(
        children: [
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
                } else if (state is JobSearchErrorLoading && searchedJobs == null) {
                  return Center(child: Text("Error: ${state.errorMessage}"));
                } else if (state is JobSearchInitial) {
                  return Center(
                    child: Text("Start Searching to find countless opportunities"),
                  );
                } else {
                  if (searchedJobs != null) {
                    return JobList(
                        key: ValueKey(searchedJobs!.length), jobs: searchedJobs!);
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
                      icon: Icon(Icons.arrow_back, color: Colors.black, size: 24.sp),
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
                            hintText: "Search by title, skill, or company",
                            icon: Icons.search,
                            onChanged: (value) {
                              //if (value.isNotEmpty) {
                                parentContext.read<JobListCubit>().getSearchedFilteredJobs(
                                    titleController.text, locationController.text,filter);
                              //}
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
                              //if (titleController.text.isNotEmpty) {
                                parentContext.read<JobListCubit>().getSearchedFilteredJobs(
                                    titleController.text, locationController.text,filter);
                              //}
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10.w),
                  IconButton(
                    icon: Icon(Icons.filter_list),
                    onPressed: () => buildFilterModalSheet(filter,parentContext),
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

  buildFilterModalSheet(Filter filter,BuildContext parentContext) {
    List<String> experienceLevels = ['Entry', 'Mid', 'Senior'];
    // Initialize checkboxes based on filter.experienceFilter contents:
    Map<String, bool> expSelected = {
      for (var level in experienceLevels)
        level: filter.experienceFilter?.contains(level) ?? false,
    };

    List<String> companyOptions = [
      'Google',
      'Microsoft',
      'Apple',
      'Amazon',
      'Meta',
      'Egyptian Co.',
      'TechnoCorp'
    ];
    // Initialize checkboxes based on filter.companyFilter:
    Map<String, bool> companySelected = {
      for (var company in companyOptions)
        company: filter.companyFilter?.contains(company) ?? false,
    };

    // Initialize salary controllers with filter values (or empty)
    TextEditingController minSalaryController = TextEditingController(
        text: filter.minSalary != null ? filter.minSalary.toString() : "");
    TextEditingController maxSalaryController = TextEditingController(
        text: filter.maxSalary != null ? filter.maxSalary.toString() : "");

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
                              filter.experienceFilter = [];
                              // Reset company filter selections
                              companySelected.updateAll((key, value) => false);
                              filter.companyFilter = [];
                              // Clear salary controllers and values
                              minSalaryController.clear();
                              maxSalaryController.clear();
                              filter.minSalary = null;
                              filter.maxSalary = null;
                              isCompanyDropdownOpen = false;
                            });
                          },
                          child: Text("Reset",
                              style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    // Experience Level Filter
                    Text("Experience Level",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Row(
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
                                    filter.experienceFilter ??= [];
                                    if (!filter.experienceFilter!.contains(level)) {
                                      filter.experienceFilter!.add(level);
                                    }
                                  } else {
                                    filter.experienceFilter?.remove(level);
                                  }
                                });
                              },
                            ),
                            Text(level),
                            SizedBox(width: 10),
                          ],
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 10),
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
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              companySelected.values.any((selected) => selected)
                                  ? companySelected.entries
                                      .where((entry) => entry.value)
                                      .map((entry) => entry.key)
                                      .join(", ")
                                  : "Select Companies",
                              style: TextStyle(color: Colors.black),
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
                        children: companyOptions.map((company) {
                          return CheckboxListTile(
                            title: Text(company),
                            value: companySelected[company],
                            onChanged: (bool? value) {
                              setModalState(() {
                                companySelected[company] = value ?? false;
                                // Update filter.companyFilter accordingly
                                if (value == true) {
                                  filter.companyFilter ??= [];
                                  if (!filter.companyFilter!.contains(company)) {
                                    filter.companyFilter!.add(company);
                                  }
                                } else {
                                  filter.companyFilter?.remove(company);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    SizedBox(height: 10),
                    // Salary Range Filter
                    Text("Salary Range",
                        style: TextStyle(fontWeight: FontWeight.bold)),
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
                                filter.minSalary = int.tryParse(value) ?? 0;
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
                                filter.maxSalary = int.tryParse(value) ?? 0;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          //if (titleController.text.isNotEmpty) {
                                parentContext.read<JobListCubit>().getSearchedFilteredJobs(
                                    titleController.text, locationController.text,filter);
                          //    }
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        child: Text("Apply Filters", style: TextStyle(color: Colors.red)),

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
