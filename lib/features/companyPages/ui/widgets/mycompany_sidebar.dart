// widgets/company_list_tile.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/features/companyPages/data/data/models/getmycompany_response.dart';
import 'package:joblinc/features/companyPages/ui/widgets/square_avatar.dart';

class CompanyListTile extends StatelessWidget {
  final CompanyResponse company;
  final VoidCallback? onTap;

  const CompanyListTile({
    super.key,
    required this.company,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SquareAvatar(
        imageUrl: company.logo ??
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTfphRB8Syzj7jIYXedFOeVZwicec0QaUv2cBwPc0l7NnXdjBKpoL9nDSeX46Tich1Razk&usqp=CAU",
        size: 20.h,
      ),
      title: Text(
        company.name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
