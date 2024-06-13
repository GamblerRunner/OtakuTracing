import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfc/chat_page.dart';
import 'Firebase_Manager.dart';
import 'main.dart';
import 'message.dart';
import 'register.dart';
import 'settings.dart';
import 'mangas.dart';
import 'community.dart';
import 'Profile.dart';
import 'login.dart';
import 'animation.dart';
import 'myAnimes.dart';
import 'help.dart';
import 'myMangas.dart';

void main() {
  runApp(CommmunityApp());
}

FirebaseManager fm = FirebaseManager();
FirebaseFirestore db = FirebaseFirestore.instance;
late String userName = "Paco";
late String userUID = "12";
late String comunityChat = "One Piece";
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
  //Send Message
  Future<void> sendMessage(String communityId, String message, String senderName, String userImg) async {
    var user = await FirebaseAuth.instance.currentUser;
    if (user != null) {
      userUID= user.uid;
      await db.collection('communities').doc(communityId).collection('messages').add({
        'message': message,
        'senderId': userUID,
        'senderName': senderName ?? 'Anonymous',
        'senderImg': userImg ?? 'https://cdn.pixabay.com/photo/2022/09/01/14/18/white-background-7425603_1280.jpg',
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  Stream<QuerySnapshot> getMessages(String communityId) {
    return db.collection('communities').doc(communityId).collection('messages').orderBy('timestamp', descending: false).snapshots();
  }
}

class _CommunityPageState extends State<CommunityPage> {
  int _selectedIndex =
  1; // Índice seleccionado del elemento actual ('Comunidades')

  void init() async {
    super.initState();
    fm.getUser();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String fetchedUserName = sharedPreferences.getString("userName") ?? '';
    String fetchedUserId = sharedPreferences.getString("uid") ?? '';
    //List<String>fetchedComunities = fm.getComunities() as List<String>;

    setState(() {
      userName = fetchedUserName;
      userUID = fetchedUserId;
      //comunities=fetchedComunities;
    });
  }

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
            context, MaterialPageRoute(builder: (context) => HomePage()));
        break;

      case 1:
      // VICTOR LO HACE
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatPage(
                  community: comunityChat,
                )));
        break;

      case 2:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MangasPage()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'COMUNIDADES',
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
                      leading: Icon(Icons.home),
                      title: Text('Home'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      },
                    ),
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
                          MaterialPageRoute(builder: (context) => myMangas()),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.message),
                      title: Text('Mis Comunidades'),
                      onTap: () {
                        /* Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => myMangas()),
                        );
                         */
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
