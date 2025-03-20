import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class JobSearchScreen extends StatefulWidget {
  const JobSearchScreen({super.key});

  @override
  State<JobSearchScreen> createState() => _JobSearchScreenState();
}

class _JobSearchScreenState extends State<JobSearchScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  final List<String> searchSuggestions = [
    "remote",
    "marketing manager",
    "hr",
    "legal",
    "sales"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),

      body:Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Try searching for",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
              ),
              SizedBox(height: 10.h,),
              Flexible(
                child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                  itemCount: searchSuggestions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Icon(Icons.search),
                      title: Text(searchSuggestions[index]),
                      onTap: () {
                        titleController.text = searchSuggestions[index];
                        // Handle search logic here
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
  }


  PreferredSizeWidget buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(130.h),
      child: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top), // Safe area padding
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
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.h),
                          child: buildSearchField(
                            keyName: "jobSearch_searchByLocation_textField",
                            controller: locationController,
                            hintText: "City, state, or zip code",
                            icon: Icons.location_on,
                          ),
                        ),    
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 30.w,
                  ) // Small spacing
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
    required IconData icon
  }){
    return TextField(
      key: Key(keyName),
      cursorColor: Colors.red[400],
      controller:controller,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, size: 20.sp),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide.none
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      style: TextStyle(fontSize: 14.sp),
    );
  }


    Widget buildSearchSuggestion(String suggestion) {
    return ListTile(
      leading: Icon(Icons.search),
      title:Text(suggestion, style: TextStyle(fontWeight: FontWeight.bold)),
      onTap:(){
        titleController.text = suggestion;
      }
    );
  }

}


