import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/features/home/data/models/post_model.dart';
import 'package:joblinc/features/home/ui/widgets/post_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        elevation: 1,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search",
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.message, color: Colors.black),
            onPressed: () {
              Navigator.pushNamed(context, Routes.chatListScreen);  
              //Navigator.pushNamed(context, Routes.chatListScreen);  Sameh : who put this here :(
            },
          ),
          IconButton(
            icon: Icon(FontAwesomeIcons.crown, color: Colors.black),
            onPressed: () {
              Navigator.pushNamed(context, Routes.premiumScreen);  
              //Navigator.pushNamed(context, Routes.chatListScreen);  Sameh : who put this here :(
            },
          ),
        ],
      ),
      body: Center(
        child: ListView(
          children: [
            Post(data: mockData),
            Post(data: mockData),
            Post(data: mockData),
            Post(data: mockData),
            Post(data: mockData),
            Post(data: mockData),
            Post(data: mockData),
            Post(data: mockData),
            Post(data: mockData),
            Post(data: mockData),
            Post(data: mockData),
            Post(data: mockData),
            Post(data: mockData),
            Post(data: mockData),
            Post(data: mockData),
            Post(data: mockData),
            Post(data: mockData),
            Post(data: mockData),
            Post(data: mockData),
            Post(data: mockData),
            Post(data: mockData),
            Post(data: mockData),
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(
            thickness: 1,
            height: 0,
          ),
          BottomNavigationBar(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: ColorsManager.darkBurgundy,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.people), label: "My Network"),
              BottomNavigationBarItem(icon: Icon(Icons.add_box), label: "Post"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.notifications), label: "Notifications"),
              BottomNavigationBarItem(icon: Icon(Icons.work), label: "Jobs"),
            ],
          ),
        ],
      ),
    );
  }
}
