import 'package:flutter/material.dart';
import 'package:flutter_todo_app/Cours.dart';
import 'package:flutter_todo_app/Matiere.dart';
import 'package:flutter_todo_app/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cours_periode.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(token: prefs.getString('token'),));
}
class MyApp extends StatefulWidget {

  final token;
  const MyApp({
    @required this.token,
    Key? key,
  }): super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    Profs(),
    // Types(),
    Cours(),
    Matieres(),
    CoursPeriode(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primaryColor: Colors.black,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.lightGreen,
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.groups_sharp),
                title: Text('Profs'),
                onTap: () {
                  _onItemTapped(0);
                },
              ),
              ListTile(
                leading: Icon(Icons.newspaper),
                title: Text('Cours'),
                onTap: () {
                  _onItemTapped(1);
                },
              ),
              ListTile(
                leading: Icon(Icons.subject),
                title: Text('Matieres'),
                onTap: () {
                  _onItemTapped(2);
                },
              ),
              ListTile(
                leading: Icon(Icons.view_timeline_outlined),
                title: Text('CoursPeriode'),
                onTap: () {
                  _onItemTapped(3);
                },
              ),
            ],
          ),
        ),
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(unselectedItemColor: Colors.green,
          showUnselectedLabels: true,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.groups_sharp),
              label: 'Profs',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.newspaper),
              label: 'Cours',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.subject),
              label: 'Matieres',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.edit_calendar_rounded),
              label: 'CoursPeriode',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
