import 'package:flutter/material.dart';
import 'package:joblinc/core/routing/app_router.dart';
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
      bottomNavigationBar: BottomBar(),
    );
  }
}

class BottomBar extends StatefulWidget {
  const BottomBar({
    super.key,
  });

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(
          thickness: 1,
          height: 0,
        ),
        BottomNavigationBar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          currentIndex: _selectedIndex,
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
          onTap: (value) {
            setState(() {
              _selectedIndex = value;
            });
            switch (value) {
              case 0:
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              case 1:
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Placeholder()));
              case 2:
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Placeholder()));
              case 3:
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Placeholder()));
              case 4:
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Placeholder()));
              default:
                throw UnimplementedError();
            }
          },
        ),
      ],
    );
  }
}
