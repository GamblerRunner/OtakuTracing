import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfc/miInfo/MyCommunities.dart';
import 'package:tfc/communitieChat/chat_page.dart';
import '../Firebase/Firebase_Manager.dart';
import '../main/main.dart';
import '../Profile/Profile.dart';
import '../authenticator/login.dart';
import '../miInfo/myAnimes.dart';
import '../help/help.dart';
import '../miInfo/myMangas.dart';

void main() {
  runApp(CommmunityApp());
}

FirebaseManager fm = FirebaseManager();
FirebaseFirestore db = FirebaseFirestore.instance;
late String userName = "No Name";
late String comunityChat = "Community";
List<String> comunities = [];

class CommmunityApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CommunityPage(),
    );
  }
}

class CommunityPage extends StatefulWidget {
  @override
  _CommunityPageState createState() => _CommunityPageState();

}

class _CommunityPageState extends State<CommunityPage> {
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await Future.delayed(Duration(seconds: 1));
    await fm.getUser();
    String fetchedUserName = preferences.getString("userName") ?? '';
    setState(() {
      userName = fetchedUserName;
    });
  }

  //It takes to ChatPage where the chat is in the database saved with the anime or manga name
  void showComunitieChat(String communityName) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChatPage(
              community: communityName,
            )));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage(animeManga: false)));
        break;

      case 1:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatPage(
                  community: comunityChat,
                )));
        break;

      case 2:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage(animeManga: true)));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color :Colors.white),
        title: Text(
          'COMMUNITIES',
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
                      userName,
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
                      leading: Icon(Icons.home),
                      title: Text('Home'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage(animeManga: false,)),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.account_circle),
                      title: Text('Profile'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProfilePage()),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.tv),
                      title: Text('My Animes'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => myAnimes()),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.menu_book),
                      title: Text('My Mangas'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => myMangas()),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.message),
                      title: Text('My Communities'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyCommunityPage()),
                        );

                      },
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.help_outline),
                title: Text('Terms'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HelpPage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.account_balance_wallet),
                title: Text('Log out'),
                onTap: () async {
                  SharedPreferences preferences = await SharedPreferences.getInstance();
                  await preferences.setBool('rememberEmailPassword', false);
                  await preferences.remove("email");
                  await preferences.remove("contrasenia");
                  await preferences.remove("uid");
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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/fondoPantalla.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder<List<String>>(
          future: fm.getComunities(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No hay comunidades disponibles'));
            } else {
              List<String> comunities = snapshot.data!;
              return ListView.builder(
                itemCount: comunities.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      showComunitieChat(comunities[index]);
                    },
                    child: Container(
                      margin: EdgeInsets.all(8.0),
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        comunities[index],
                        style: TextStyle(color: Colors.white, fontSize: 18.0),
                      ),
                    ),
                  );
                },
              );
            }
          },
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
            label: 'Communities',
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
