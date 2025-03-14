import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/widgets/custom_search_bar.dart';
import 'package:joblinc/features/chat/ui/widgets/chat_card.dart';
import 'package:joblinc/features/chat/ui/widgets/chat_list_more_options_button.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.h),
        child: ChatListAppBar(context),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Expanded(
              child: ChatList(),
            ),
          ],
        ),
      ),
    );
  }
}

AppBar ChatListAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: const Color.fromARGB(255, 255, 0, 0),
    elevation: 0,
    automaticallyImplyLeading: false, // Prevents automatic back button
    flexibleSpace: SafeArea(
      // Ensures proper spacing from status bar
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w), // Adds spacing
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon:
                      Icon(Icons.arrow_back, size: 24.sp, color: Colors.white),
                ),
                CustomSearchBar(
                  text: "Microsoft", //Company Name goes here
                  onPress: () {},
                  onTextChange: (searched) {},
                  controller: TextEditingController(),
                ),
                MoreOptionsButton(),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recent Conversations",
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "View All",
                    style: TextStyle(fontSize: 12.sp, color: Colors.white70),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}



