import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfc/miInfo/MyCommunities.dart';
import '../graphiql/AnimeData.dart';
import '../graphiql/AnimeModel.dart';
import '../Firebase/Firebase_Manager.dart';
import '../Profile/Profile.dart';
import '../help/help.dart';
import '../InterfaceAnimeManga/interfaceAnime.dart';
import '../authenticator/login.dart';
import '../main/main.dart';
import 'myMangas.dart';

Future<void> main() async {
  runApp(MaterialApp(
    home: myAnimes(),
  ));
}

class myAnimes extends StatefulWidget {
  @override
  myAnimesPage createState() => myAnimesPage();
}

class myAnimesPage extends State<myAnimes> {//It works the same way in miMangasPage
  late FirebaseManager fm;

  late String userName = 'user name';
  late String userImg = 'https://cdn.pixabay.com/photo/2022/09/01/14/18/white-background-7425603_1280.jpg';
  List<int> medias = [];

  List<Media> fetchedData = [];
  final AnimeData data = AnimeData();
  // Controller used to manage and listen to the scrolling of a scrollable widget.
  final ScrollController scrollController = ScrollController();


  String? search = '';


  @override
  void initState() {
    super.initState();
    fm = FirebaseManager();
    fetchUserData();
  }

  Future<void> fetchData() async {
    await Future.delayed(Duration(seconds: 1));
    fetchedData = await data.getMyMedia(medias); //Gets all the animes you save in Firebase
    if (fetchedData != null) {
      setState(() {});
    } else {
      print("ERROR, NO FETCHING DATA FROM THE DATABASE FOUND (error de consulta en grahpql)");
    }
  }

  Future<void> fetchUserData() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    await fm.getUser();
    medias = await fm.getMyAnimes(false);

    //It gets the user name and image so it loads in the page
    String fetchedUserName = preferences.getString("userName") ?? '';
    String fetchedUserImg = preferences.getString("ImgProfile") ?? '';

    setState(() {
      userName = fetchedUserName;
      userImg = fetchedUserImg;
    });

    fetchData();
  }

  Future<void> saveID(int id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    //It saves the id of the anime, so that it can do a request to graphql
    await preferences.setInt("idMedia", id);

    Navigator.push(context, MaterialPageRoute(builder: (context) => InterfaceAnimePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color :Colors.white),
        title: Text(
          'MY ANIMES',
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
                  await preferences.remove('rememberEmailPassword');
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
            padding: EdgeInsets.only(top: 20), // Ajust the padding so that it starts from the top
            child: ListView.builder(
              controller: scrollController,
              padding: EdgeInsets.symmetric(vertical: 25, horizontal: 30),
              itemCount: (fetchedData.length / 2).ceil(),
              itemBuilder: (context, index) {
                int firstIndex = index * 2;
                int secondIndex = firstIndex + 1;

                return Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            saveID(fetchedData[firstIndex].id);
                          },
                          child: buildAnimeCard(fetchedData[firstIndex]),
                        ),
                      ),
                      SizedBox(width: 8),
                      if (secondIndex < fetchedData.length)
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              saveID(fetchedData[secondIndex].id);
                            },
                            child: buildAnimeCard(fetchedData[secondIndex]),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }


  Widget buildAnimeCard(Media AnimeManga) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 3 / 4,
          child: Image.network(
            AnimeManga.coverImageUrl ?? 'assets/img/animeimg.jpg',
            width: 150,
            height: 200,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 8),
        Container(
          width: 150, // Ancho fijo para limitar el tamaño del texto
          child: Text(
            AnimeManga.romajiTitle ?? 'Loading',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1, // Limita a una línea para que no afecte la altura de la imagen
            overflow: TextOverflow.ellipsis, // Añade puntos suspensivos si el texto es demasiado largo
          ),
        ),
        SizedBox(height: 4),
      ],
    );
  }
}
