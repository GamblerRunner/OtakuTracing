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

void main() {
  runApp(CommmunityApp());
}
FirebaseManager fm = FirebaseManager();
FirebaseFirestore db = FirebaseFirestore.instance;
late String userName ="Paco";
late String userId ="BACNUaEwrHNhsd7HV3eDHRt8s6s2";
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
  Future<void>sendMessage(String receiverId, String message) async{
    //get cuurrent info
    final String currentUserId = fm.uid;
    final String currentUserName = fm.userName;
    final Timestamp timestamp = Timestamp.now();

    //create the message
    Message newMessage = Message(
      senderId: currentUserId,
      senderName: currentUserName,
      receiverId: receiverId,
      timestamp: timestamp,
      message: message,
    );

    //chat room
    List<String> ids = [currentUserId,receiverId];
    ids.sort();
    String chatRoomId = ids.join(
        "_"
    );

    //add it to database
    await db.collection('chat_rooms').doc(chatRoomId).collection('messages').add(newMessage.toMap());
  }
  //Get Messages
  Stream<QuerySnapshot> getMessage(String userId, String otherUserId){
    //construct chat room id
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    return db.collection('chat_rooms').doc(chatRoomId).collection('messages').orderBy('timestamp', descending: false).snapshots();
  }
}

class _CommunityPageState extends State<CommunityPage> {
  int _selectedIndex = 1; // Índice seleccionado del elemento actual ('Comunidades')

  void init() async{
    super.initState();
    fm.getUser();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String fetchedUserName = sharedPreferences.getString("userName") ?? '';
    String fetchedUserId = sharedPreferences.getString("uid") ?? '';

    setState(() {
      userName = fetchedUserName;
      userId = fetchedUserId;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
        break;

      case 1:
      // VICTOR LO HACE
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(receiverUserName: userName,receiverUserId: userId,)));
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

      body: Center(
        child: Text('COMUNIDADES'),
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
