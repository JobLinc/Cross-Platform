import 'package:flutter/material.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/features/home/ui/screens/home_screen.dart';

class UniversalBottomBar extends StatefulWidget {
  static final UniversalBottomBar _bar = UniversalBottomBar._constructor();
  const UniversalBottomBar._constructor();

  factory UniversalBottomBar() {
    return _bar;
  }

  @override
  State<UniversalBottomBar> createState() => _UniversalBottomBarState();
}

class _UniversalBottomBarState extends State<UniversalBottomBar> {
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
            if (value == _selectedIndex) return;
            setState(() {
              _selectedIndex = value;
            });
            //TODO: Replace PlaceHolders with screens when they are done and uncomment
            //! Make sure your the scaffold in these screens uses the universal_bottom_bar in core
            switch (value) {
              case 0:
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              // case 1:
              //   Navigator.push(context,
              //       MaterialPageRoute(builder: (context) => Placeholder()));
              // case 2:
              //   Navigator.push(context,
              //       MaterialPageRoute(builder: (context) => Placeholder()));
              // case 3:
              //   Navigator.push(context,
              //       MaterialPageRoute(builder: (context) => Placeholder()));
              // case 4:
              //   Navigator.push(context,
              //       MaterialPageRoute(builder: (context) => Placeholder()));
              default:
                throw UnimplementedError();
            }
          },
        ),
      ],
    );
  }
}
