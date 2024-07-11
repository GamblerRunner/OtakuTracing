import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfc/Firebase/Firebase_Manager.dart';
import 'package:tfc/miInfo/MyCommunities.dart';
import 'package:tfc/miInfo/myMangas.dart';

import 'ProfileImg.dart';
import '../help/help.dart';
import '../authenticator/login.dart';
import '../main/main.dart';
import '../miInfo/myAnimes.dart';

void main() {
  runApp(MaterialApp(
    home: ProfilePage(),
  ));
}

class ProfilePage extends StatefulWidget {
  @override
  Profile createState() => Profile();
}

class Profile extends State<ProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String urlImg;
  String? newUserName = '';
  String? userName = 'user name';
  late String uid = '';
  late FirebaseManager fm;
  int userAnimes = 0;
  int userMangas = 0;
  int userCommunities = 0;

  @override
  void initState() {
    super.initState();
    loadImage();
    fm = FirebaseManager();
    fetchUserData();
  }

  Future<void> loadImage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    //It loads the image you have from the start
    String? newImgProfile = preferences.getString("ImgProfile");

    setState(() {
      urlImg = newImgProfile!;
    });
  }

  Future<void> fetchUserData() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await Future.delayed(Duration(seconds: 1));

    await fm.getUser();
    //It gets the number of mangas, animes, and communities su saved in the database
    List<int> myAnimes = await fm.getMyAnimes(false);
    List<int> myMangas = await fm.getMyAnimes(true);
    List<String> myCommunities = await fm.getMyComunities();
    String fetchedUserName = preferences.getString("userName") ?? '';

    setState(() {
      userName = fetchedUserName;
      userAnimes = myAnimes.length;
      userMangas = myMangas.length;
      userCommunities = myCommunities.length;
    });
  }

  Future<void> changeUserData() async {
    _formKey.currentState!.save();
    if (newUserName == '') {
      newUserName = userName;
    }
    fm.changeUserName(newUserName!, urlImg);

    SharedPreferences preferences = await SharedPreferences.getInstance();

    await preferences.setString("userName", newUserName!);
  }

  Widget buildDivider() => Container(
    height: 24,
    child: VerticalDivider(
      color: Colors.black,
    ),
  );

  Widget buildButton(BuildContext context, String value, String text) => Material(
    color: Colors.transparent,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        SizedBox(height: 2),
        Text(
          text,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'PROFILE',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
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
                      userName!,
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
                          MaterialPageRoute(builder: (context) => HomePage(animeManga: false)),
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
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/img/fondoPantalla.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.transparent, // Cambio de azul a transparente
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => ProfileImgPage()),
                                );
                              },
                              child: ClipOval(
                                child: Image.network(
                                  urlImg, // Imagen del usuario
                                  width: 300,
                                  height: 300,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 35),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 150, // Ajusta el ancho del campo de entrada aquí
                              child: TextFormField(
                                style: TextStyle(fontSize: 14), // Tamaño del texto
                                decoration: InputDecoration(
                                  labelText: 'Username',
                                  labelStyle: TextStyle(color: Colors.black), // Cambia el color de la letra a negro
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10), // Padding interno del campo de entrada
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Not Changing user name';
                                  }
                                  return null;
                                },
                                onSaved: (value) => newUserName = value,
                              ),
                            ),
                            SizedBox(width: 40),
                            SizedBox(
                              width: 70,
                              height: 50,
                              child: FloatingActionButton(
                                onPressed: () {
                                  changeUserData();
                                },
                                child: Text('Save'),
                                backgroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(10), // Padding opcional
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      buildButton(context, '$userAnimes', 'Animes'),
                      buildDivider(),
                      buildButton(context, '$userCommunities', 'Communities'),
                      buildDivider(),
                      buildButton(context, '$userMangas', 'Mangas'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}