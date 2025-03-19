import 'package:flutter/material.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/core/widgets/universal_app_bar_widget.dart';
import 'package:joblinc/features/home/ui/screens/home_screen.dart';
import 'package:joblinc/features/jobs/ui/screens/job_list_screen.dart';

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
  static int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: 'core_bottombar_container',
      child: Column(
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
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.people), label: 'My Network'),
              BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'Post'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.notifications), label: 'Notifications'),
              BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Jobs'),
            ],
            onTap: (value) {
              if (value == _selectedIndex) return;
              setState(() {
                _selectedIndex = value;
              });
              //TODO: Replace these routes with the actual screens routes when they are done and uncomment
         switch (value) {
                case 0:
                  Navigator.pushReplacement(context,
                  MaterialPageRoute(builder:(context)=>HomeScreen()));
                      // MaterialPageRoute(builder:(context)=> Scaffold(
                      //   appBar: universalAppBar(context, _selectedIndex),
                      //   body: HomeScreen(),
                      //   bottomNavigationBar: UniversalBottomBar(),
                      // )));
                case 1:
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Scaffold(
                        appBar: universalAppBar(context, _selectedIndex),
                        body: Center(
                          child: Text("My Network"),
                        ),
                        bottomNavigationBar: UniversalBottomBar(),
                      ),
                    ),
                  );
                  break;
                case 2:
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Scaffold(
                        appBar: universalAppBar(context, _selectedIndex),
                        body:Center(
                          child: Text("My Posts"),
                        ), 
                        bottomNavigationBar: UniversalBottomBar(),
                      ),
                    ),
                  );
                  break;
                case 3:
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Scaffold(
                        appBar: universalAppBar(context, _selectedIndex),
                        body: Center(
                          child: Text("Notifications"),
                        ),
                        bottomNavigationBar: UniversalBottomBar(),
                      ),
                    ),
                  );
                  break;
                case 4:
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Scaffold(
                        appBar: universalAppBar(context, _selectedIndex),
                        body: JobListScreen(),
                        bottomNavigationBar: UniversalBottomBar(),
                      ),
                    ),
                  );
                  break;
                default:
                  throw UnimplementedError();
              }
            },
          ),
        ],
      ),
    );
  }
}
