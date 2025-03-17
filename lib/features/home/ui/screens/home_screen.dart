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
          child: Semantics(
            container: true,
            label: 'home_topBar_container',
            child: Center(
                child: Semantics(
                  label: 'home_topBar_search',
                  child: TextField(
                     onTap: () {
                      Navigator.pushNamed(context, Routes.companyListScreen);
                    },
                    decoration: InputDecoration(
                        hintText: 'Search',
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        border: InputBorder.none),
                  ),
                ),
              ),
          ),
        ),
        actions: [
          Semantics(
            label: 'home_topBar_chatButton',
            child: IconButton(
              icon: Icon(Icons.message, color: Colors.black),
              onPressed: () {
                Navigator.pushNamed(context, Routes.chatListScreen);
              },
            ),
          ),
        ],
      ),
      body: Center(
        child: Semantics(
          container: true,
          label: 'home_body_postList',
          child: ListView.builder(
              itemCount: 30,
              itemBuilder: (context, index) => Post(data: mockData)),
        ),
      ),
      bottomNavigationBar: UniversalBottomBar(),
    );
  }
}
