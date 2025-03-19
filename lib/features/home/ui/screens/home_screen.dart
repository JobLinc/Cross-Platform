import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/widgets/custom_search_bar.dart';
import 'package:joblinc/features/posts/data/models/post_model.dart';
import 'package:joblinc/core/widgets/universal_bottom_bar.dart';
import 'package:joblinc/features/posts/ui/widgets/post_widget.dart';
import 'package:joblinc/features/jobs/ui/screens/job_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();
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
                child: CustomSearchBar(
                    keyName: 'home_topBar_search',
                    text: 'Search',
                    onPress: () {
                      Navigator.pushNamed(context, Routes.companyListScreen);
                    },
                    onTextChange: () {},
                    controller: searchController),
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
          IconButton(
            icon: Icon(FontAwesomeIcons.crown, color: Colors.black),
            onPressed: () {
              Navigator.pushNamed(context, Routes.premiumScreen);
            },
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
