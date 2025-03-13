import 'package:flutter/material.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/features/home/data/models/post_model.dart';
import 'package:joblinc/core/widgets/universal_bottom_bar.dart';
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
      bottomNavigationBar: UniversalBottomBar(),
    );
  }
}
