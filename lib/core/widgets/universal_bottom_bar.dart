import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/features/connections/logic/cubit/connections_cubit.dart';
import 'package:joblinc/features/connections/logic/cubit/invitations_cubit.dart';
import 'package:joblinc/features/connections/ui/screens/InvitationPage.dart';
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
                      MaterialPageRoute(builder: (context) => HomeScreen()));
                case 1:
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BlocProvider(
                              create: (context) => getIt<InvitationsCubit>(),
                              child: InvitationPage(
                                key: Key("connections home screen"),
                              ),
                            )),
                  );
                  break;
                case 2:
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Scaffold(
                        appBar: AppBar(
                          title: Text("Post"),
                        ),
                        body: Center(
                          child: Text("Post"),
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
                        appBar: AppBar(
                          title: Text("Notifications"),
                        ),
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
                        appBar: AppBar(
                          title: Text("Jobs"),
                        ),
                        body: Center(
                          child: Text("Jobs"),
                        ),
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
