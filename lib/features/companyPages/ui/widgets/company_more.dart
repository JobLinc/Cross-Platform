import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/features/companyPages/logic/cubit/create_company_cubit.dart';
import '../screens/create_company.dart';

class CompanyMoreButton extends StatelessWidget {
  const CompanyMoreButton({super.key});

  void _showMoreActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return const MoreActions();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _showMoreActions(context);
      },
      child: const Icon(Icons.more_horiz_outlined,
          color: Colors.black), // Add const
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(
          side: BorderSide(
            color: Colors.black,
            width: 0.5,
          ),
        ),
        padding: const EdgeInsets.all(5),
        backgroundColor: Color(0xFFFAFAFA),
        foregroundColor: Colors.black,
        fixedSize: Size(40.w, 40.h),
      ),
    );
  }
}

class MoreActions extends StatelessWidget {
  const MoreActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10, bottom: 2, left: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(Icons.ios_share),
                onPressed: () {},
              ),
              Text(
                'Share via',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 2, bottom: 2, left: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () {},
              ),
              Text(
                'Send in a message',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 2, bottom: 2, left: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(Icons.flag_rounded),
                onPressed: () {},
              ),
              Text(
                'Report abuse',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 2, bottom: 2, left: 5),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => CreateCompanyCubit(),
                    child: CreateCompanyPage(),
                  ),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {},
                ),
                Text(
                  'Create a LinkedIn Page',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
