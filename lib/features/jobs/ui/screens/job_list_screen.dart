import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/widgets/custom_search_bar.dart';
import 'package:joblinc/features/jobs/ui/widgets/job_card.dart';
import 'package:joblinc/features/jobs/data/models/job_model.dart';

class JobListScreen extends StatefulWidget {
  const JobListScreen({super.key});

  @override
  State<JobListScreen> createState() => _JobListScreenState();
}

class _JobListScreenState extends State<JobListScreen> {
  late List<Job> searchedJobs;
  bool? isSearching = false;
  final searchTextController = TextEditingController();
  @override
  void initState() {
    super.initState();
    searchedJobs = List.from(mockJobs);
  }

  Widget build(BuildContext context) {
    return Column(
          children: [
            SizedBox(height: 10.h),
            Expanded(
              child: JobList(
                key: ValueKey(searchedJobs.length),
                jobs: mockJobs,
              ),
            ),
          ],
        );
  }
}

