import 'package:flutter/material.dart';
import 'main.dart';
import 'register.dart';
import 'settings.dart';
import 'mangas.dart';
import 'community.dart';
import 'Profile.dart';
import 'login.dart';
import 'animation.dart';
import 'myAnimes.dart';
import 'help.dart';

void main() {
  runApp(MangasApp());
}

class MangasApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MangasPage(),
    );
  }
}

class MangasPage extends StatefulWidget {
  @override
  _MangasPageState createState() => _MangasPageState();
}

class _MangasPageState extends State<MangasPage> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
      break;

      case 1:
      Navigator.push(context, MaterialPageRoute(builder: (context) => CommunityPage()));
      break;

      case 2:
      Navigator.push(context, MaterialPageRoute(builder: (context) => MangasPage()));
      break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color :Colors.white),
        title: Text(
          'MANGAS',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),

      drawer: SizedBox(
        width: 225,
        child: Drawer(
          child: Column(
            children: <Widget>[
              Container(
                height: 125,
                decoration: BoxDecoration(
                  color: Colors.black,
                ),
                child: DrawerHeader(
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  child: Center(
                    child: Text(
                      'User Name',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.account_circle),
                      title: Text('Perfil'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProfilePage()),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.tv),
                      title: Text('Mis Animes'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => myAnimes()),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.menu_book),
                      title: Text('Mis Mangas'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => myAnimes()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Ajustes'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsPage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.help_outline),
                title: Text('Ayuda'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HelpPage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.account_balance_wallet),
                title: Text('Cerrar Sesión'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.tv_rounded, color: Colors.white),
            label: 'Animes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message, color: Colors.white),
            label: 'Comunidades',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book, color: Colors.white),
            label: 'Mangas',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
