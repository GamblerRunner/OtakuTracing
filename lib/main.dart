import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfc/Profile.dart';
import 'package:tfc/ProfileImg.dart';
import 'package:tfc/login.dart';
import 'AnimeData.dart';
import 'AnimeModel.dart';
import 'firebase_options.dart';
import 'settings.dart';
import 'mangas.dart';
import 'community.dart';
import 'myMangas.dart';
import 'myAnimes.dart';
import 'help.dart';
import 'readManga.dart';

Future<void> main() async {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ProfileImgPage(),
  ));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showOptions = false;
  int _selectedIndex = 0;

  List<Media> fetchedData = [];
  final AnimeData data = AnimeData();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? search = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    fetchedData = await data.getPageData();
    print(fetchedData?[0].coverImageUrl.toString());
    if (fetchedData != null) {
      setState(() {
        // pageData = fetchedData as Map<String, dynamic>;
      });
    } else {
      print("ERROR, NO FETCHING DATA FROM THE DATABASE FOUND (error de consulta en grahpql)");
    }
  }

  Future<void> fetchSearchData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (search!.isEmpty) {
        return;
      }
      fetchedData.clear();
      fetchedData = await data.getPageSearchData(search!);
      print(fetchedData?[0].coverImageUrl.toString());
      if (fetchedData != null) {
        setState(() {
          // pageData = fetchedData as Map<String, dynamic>;
        });
      } else {
        print("ERROR, NO FETCHING DATA FROM THE DATABASE FOUND (error de consulta en grahpql)");
      }
    }
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
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'ANIMES',
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
                          MaterialPageRoute(builder: (context) => myAnimesPage()),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.menu_book),
                      title: Text('Mis Mangas'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => myMangasPage()),
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
                image: AssetImage('assets/img/backgroundTwo.jpg'),
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
                          'https://wallpapers.com/images/featured/best-anime-syxejmngysolix9m.jpg',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    SizedBox(
                      width: 150, // Ajusta el ancho del campo de entrada aquí
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          style: TextStyle(fontSize: 14), // Tamaño del texto
                          decoration: InputDecoration(
                            labelText: 'search',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10), // Padding interno del campo de entrada
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'El campo Buscar está vacío';
                            }
                            return null;
                          },
                          onSaved: (value) => search = value,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    SizedBox(
                      width: 80,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _showOptions = !_showOptions;
                          });
                        },
                        child: Text('filtro'),
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: FloatingActionButton(
                        onPressed: () {
                          setState(() async {
                            print("jddddd");
                            await fetchSearchData();
                            print(search);
                            print("Pues xd no");
                          });
                        },
                        child: Text('Buscar'),
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                if (_showOptions)
                  ExpansionTile(
                    title: Text('Opciones de filtro'),
                    children: <Widget>[
                      CheckboxListTile(
                        title: Text('Filtrar por año de publicación'),
                        value: false,
                        onChanged: (value) {
                          // Implementa la lógica para filtrar por año de publicación
                        },
                      ),
                      CheckboxListTile(
                        title: Text('Filtrar por si se está emitiendo'),
                        value: false,
                        onChanged: (value) {
                          // Implementa la lógica para filtrar por si se está emitiendo
                        },
                      ),
                      CheckboxListTile(
                        title: Text('Filtrar por género'),
                        value: false,
                        onChanged: (value) {
                          // Implementa la lógica para filtrar por género
                        },
                      ),
                    ],
                  ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 100),
            child: ListView.builder(
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
                            print('Tapped on ${fetchedData![firstIndex].romajiTitle}');
                            Navigator.push(context, MaterialPageRoute(builder: (context) => readMangaPage()));

                          },
                          child: buildAnimeCard(fetchedData![firstIndex]),
                        ),
                      ),
                      SizedBox(width: 8),
                      if (secondIndex < fetchedData!.length)
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              // Manejar el evento onTap aquí para el segundo elemento
                              print('Tapped on ${fetchedData![secondIndex].romajiTitle}');
                              Navigator.push(context, MaterialPageRoute(builder: (context) => readMangaPage()));
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
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 40,
            height: 30,
            child: FloatingActionButton(
              onPressed: () async {
                setState(() async {
                  fetchedData = (await data.fetchNextPage(false))!;
                });
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
                setState(() async {
                  fetchedData = (await data.fetchNextPage(true))!;
                });
              },
              child: Text('>'),
              backgroundColor: Colors.white,
            ),
          ),
        ],
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

  Widget buildAnimeCard(Media AnimeManga) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.network(
          AnimeManga.coverImageUrl ?? 'assets/img/animeimg.jpg',
          width: 150,
          height: 200,
          fit: BoxFit.cover,
        ),
        SizedBox(height: 8),
        Text(
          AnimeManga.romajiTitle ?? 'Loading',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
      ],
    );
  }
}