import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfc/communitieChat/chat_page.dart';
import '../Firebase/Firebase_Manager.dart';
import '../main/main.dart';
import '../Profile/Profile.dart';
import '../authenticator/login.dart';
import 'myAnimes.dart';
import '../help/help.dart';
import 'myMangas.dart';

void main() {
  runApp(MyCommmunityApp());
}

FirebaseManager fm = FirebaseManager();
FirebaseFirestore db = FirebaseFirestore.instance;
String userName = "noName";
String userUID = "0";
String comunityChat = "No Title";
List<String> comunities = [];

class MyCommmunityApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyCommunityPage(),
    );
  }
}

class MyCommunityPage extends StatefulWidget {
  @override
  MyCommunityPageState createState() => MyCommunityPageState();

  /// Retrieves a stream of messages for a specific community.
  ///
  /// This method queries the 'messages' collection within a specified 'community' document,
  /// ordering the messages by timestamp in ascending order, and returns a stream of
  /// [QuerySnapshot] objects which can be listened to for real-time updates.
  Stream<QuerySnapshot> getMessages(String communityId) {
    return db.collection('communities')
        .doc(communityId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

}

class MyCommunityPageState extends State<MyCommunityPage> {

  void init() async {
    super.initState();
    fm.getUser();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String fetchedUserName = sharedPreferences.getString("userName") ?? '';
    String fetchedUserId = sharedPreferences.getString("uid") ?? '';

    setState(() {
      userName = fetchedUserName;
      userUID = fetchedUserId;
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color :Colors.white),
        title: Text(
          'MY COMMUNITIES',
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
          future: fm.getMyComunities(),
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
    );
  }
}
