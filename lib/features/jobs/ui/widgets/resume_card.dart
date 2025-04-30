import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/features/jobs/data/models/job_applicants.dart';

// class ResumeCard extends StatelessWidget {
//   final Resume resume;
//   final bool isSelected;
//   final VoidCallback onToggleSelect;
//   final void Function(String, String) onOpenResume; // Pass function from JobApplicationScreen

//   const ResumeCard({
//     Key? key,
//     required this.resume,
//     required this.isSelected,
//     required this.onToggleSelect,
//     required this.onOpenResume, // Added
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final double sizeInKB = resume.size / 1024.0;
//     final String formattedDate = DateFormat('M/d/yyyy').format(resume.date);

//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 4.0),
//       decoration: BoxDecoration(
//         border: Border.all(
//           color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade300,
//           width: isSelected ? 1.0 : 1.0,
//         ),
//         borderRadius: BorderRadius.circular(8.0),
//       ),
//       child: Row(
//         children: [
//           // Extension badge (left side) - Now opens resume
//           GestureDetector(
//             onTap: () => onOpenResume(resume.url, resume.name),
//             child: Container(
//               width: 60,
//               height: 60,
//               decoration: BoxDecoration(
//                 color: ColorsManager.getPrimaryColor(context),
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(8.0),
//                   bottomLeft: Radius.circular(8.0),
//                 ),
//               ),
//               alignment: Alignment.center,
//               child: Text(
//                 resume.extension.replaceAll('.', '').toUpperCase(), // e.g. "PDF"
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),

//           SizedBox(width: 8.w),

//           // Middle column: file name, size, date - Now opens resume
//           Expanded(
//             child: GestureDetector(
//               onTap: () => onOpenResume(resume.url, resume.name),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       resume.name,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.w600,
//                       ),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     SizedBox(height: 4.0),
//                     Text(
//                       "${sizeInKB.toStringAsFixed(1)} kB - Last used on $formattedDate",
//                       style: TextStyle(
//                         color: Colors.grey.shade600,
//                         fontSize: 13.0,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),

//           // SELECT / UNSELECT button (No open resume here)
//           TextButton(
//             onPressed: onToggleSelect,
//             child: Text(
//               isSelected ? "UNSELECT" : "SELECT",
//               style: TextStyle(
//                 color: isSelected ? Colors.blue : ColorsManager.getPrimaryColor(context),
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



class ResumeCard extends StatelessWidget {
  final Resume resume;
  final bool isSelected;
  final VoidCallback onToggleSelect;
  final void Function(String, String) onOpenResume;

  const ResumeCard({
    Key? key,
    required this.resume,
    required this.isSelected,
    required this.onToggleSelect,
    required this.onOpenResume,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double sizeInKB = resume.size.toDouble(); // already in kB

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade300,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          // File type badge
          GestureDetector(
            onTap: () => onOpenResume(resume.file, resume.name),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: ColorsManager.getPrimaryColor(context),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  bottomLeft: Radius.circular(8.0),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                resume.name.split('.').last.toUpperCase(), // e.g. "PDF"
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          SizedBox(width: 8.w),

          // File info
          Expanded(
            child: GestureDetector(
              onTap: () => onOpenResume(resume.file, resume.name),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      resume.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      "${sizeInKB.toStringAsFixed(1)} kB",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Select/Unselect Button
          TextButton(
            onPressed: onToggleSelect,
            child: Text(
              isSelected ? "UNSELECT" : "SELECT",
              style: TextStyle(
                color: isSelected ? Colors.blue : ColorsManager.getPrimaryColor(context),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class ResumeList extends StatelessWidget {
  final List<Resume> resumes;
  final String? selectedResumeId;
  final ValueChanged<String?> onResumeSelected;
  final void Function(String, String) onOpenResume; // Pass function

  const ResumeList({
    Key? key,
    required this.resumes,
    required this.selectedResumeId,
    required this.onResumeSelected,
    required this.onOpenResume, // Added
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: resumes.length,
      itemBuilder: (context, index) {
        final resume = resumes[index];
        final bool isSelected = (resume.id == selectedResumeId);

        return ResumeCard(
          resume: resume,
          isSelected: isSelected,
          onToggleSelect: () {
            if (isSelected) {
              onResumeSelected(null);
            } else {
              onResumeSelected(resume.id);
            }
          },
          onOpenResume: onOpenResume, // Pass `_openResume` function
        );
      },
    );
  }
}



