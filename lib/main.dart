import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfc/MyCommunities.dart';
import 'package:tfc/Profile.dart';
import 'package:tfc/interfaceAnime.dart';
import 'package:tfc/login.dart';
import 'AnimeData.dart';
import 'AnimeModel.dart';
import 'Firebase_Manager.dart';
import 'community.dart';
import 'animation.dart';
import 'myAnimes.dart';
import 'help.dart';
import 'InterfaceManga.dart';
import 'myMangas.dart';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';


Future<void> main() async {
  RenderErrorBox.backgroundColor = Colors.transparent;
  RenderErrorBox.textStyle = ui.TextStyle(color: Colors.transparent);
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(animeManga: false),
  ));
}

class HomePage extends StatelessWidget {
  final bool animeManga;

  const HomePage({Key? key, required this.animeManga}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HomePageStart(animeManga: animeManga);
  }
}

class HomePageStart extends StatefulWidget {
  final bool animeManga;

  const HomePageStart({required this.animeManga, Key? key}) : super(key: key);

  @override
  _HomePageStartState createState() => _HomePageStartState();
}

class _HomePageStartState extends State<HomePageStart> {
  late FirebaseManager fm;

  late String userName = 'user';
  late String userImg = 'https://cdn.pixabay.com/photo/2022/09/01/14/18/white-background-7425603_1280.jpg';

  int selectedIndex = 0;
  List<Media> fetchedData = [];
  final AnimeData data = AnimeData();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();

  String? search = '';
  String searchText = 'Search Anime';
  String appBarTitle = 'ANIMES';


  bool animemanga = false;
  bool searching = false;

  @override
  void initState() {
    super.initState();
    fm = FirebaseManager();
    animemanga = widget.animeManga;
    fetchData();
    fetchUserData();
  }

  Future<void> fetchData() async {
    fetchedData = await data.getPageData(animemanga);
  }

  Future<void> fetchUserData() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await Future.delayed(Duration(seconds: 1));

    await fm.getUser();

    String fetchedUserName = preferences.getString("userName") ?? '';
    String fetchedUserImg = preferences.getString("ImgProfile") ?? '';

    setState(() {
      userName = fetchedUserName;
      userImg = fetchedUserImg;
    });
  }

  Future<void> fetchSearchData() async {
    if (_formKey.currentState!.validate()) {
      searching = true;
      _formKey.currentState!.save();
      if (search!.isEmpty) {
        return;
      }
      fetchedData.clear();
      fetchedData = await data.getPageSearchData(search!, animemanga);
      print(fetchedData?[0].coverImageUrl.toString());
      if (fetchedData != null) {
        setState(() {});
      } else {
        print("ERROR, NO FETCHING DATA FROM THE DATABASE FOUND (error de consulta en grahpql)");
      }
    }else{
      searching = false;
    }
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
      searchText = (index == 2) ? 'Search Manga' : 'Search Anime';
      appBarTitle = (index == 2) ? 'MANGAS' : 'ANIMES';
      animemanga = (index == 2);
      fetchedData.clear();
      fetchData();
    });

    switch (index) {
      case 0:
        fetchedData.clear();
        animemanga = false;
        fetchData();
        break;

      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context) => CommunityPage()));
        break;

      case 2:
        fetchedData.clear();
        animemanga = true;
        fetchData();
        break;
    }
  }


  void scrollToTop() {
    _scrollController.animateTo(
      0.0,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> fetchNextPage(bool next) async {
    final data = await this.data.fetchNextPage(next, animemanga);
    setState(() {
      fetchedData = data!;
      scrollToTop();
    });
  }

  Future<void> saveID(int id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    await preferences.setInt("idMedia", id);

    if (animemanga) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => InterfaceMangaPage()));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => InterfaceAnimePage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: IconThemeData(color :Colors.white),
        title: Text(
          appBarTitle,
          style: TextStyle(
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
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        print('Image clicked!');
                        _scaffoldKey.currentState?.openDrawer();
                      },
                      child: ClipOval(
                        child: Image.network(
                          userImg,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          style: TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                            labelText: searchText,
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'This field is empty';
                            }
                            return null;
                          },
                          onSaved: (value) => search = value,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: FloatingActionButton(
                        onPressed: () async {
                          await fetchSearchData();
                        },
                        child: Text('Search'),
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 100),
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(vertical: 25, horizontal: 30),
              itemCount: (fetchedData!.length / 2).ceil(),
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
                            saveID(fetchedData![firstIndex].id);
                            print('Tapped on ${fetchedData![firstIndex].romajiTitle}');
                          },
                          child: buildAnimeCard(fetchedData![firstIndex]),
                        ),
                      ),
                      SizedBox(width: 8),
                      if (secondIndex < fetchedData!.length)
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              saveID(fetchedData![secondIndex].id);
                              print('Tapped on ${fetchedData![secondIndex].romajiTitle}');
                            },
                            child: buildAnimeCard(fetchedData![secondIndex]),
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
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 40,
              height: 30,
              child: FloatingActionButton(
                onPressed: () async {
                  if (searching) {
                    setState(() {
                      _formKey.currentState!.reset();
                      searchText = '';
                    });
                  }
                  await fetchNextPage(false);
                },
                child: Text('<'),
                backgroundColor: Colors.white,
              ),
            ),
            SizedBox(width: 50),
            SizedBox(
              width: 40,
              height: 30,
              child: FloatingActionButton(
                onPressed: () async {
                  if (searching) {
                    setState(() {
                      _formKey.currentState!.reset();
                      searchText = '';
                    });
                  }
                  await fetchNextPage(true);
                },
                child: Text('>'),
                backgroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
        currentIndex: selectedIndex,
        selectedItemColor: Colors.black,
        onTap: onItemTapped,
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
