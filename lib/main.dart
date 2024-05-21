import 'package:flutter/material.dart';
import 'package:tfc/Profile.dart';
import 'package:tfc/login.dart';
import 'AnimeData.dart';
import 'AnimeModel.dart';
import 'register.dart';
import 'settings.dart';

void main() {
  runApp(MaterialApp(
    home: LoginPage(),
  ));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showOptions = false;

  List<Media> fetchedData=[];
  final AnimeData data = AnimeData();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    fetchData(); // Llama a la función para obtener los datos al inicializar el widget
  }

  Future<void> fetchData() async {
  fetchedData = await data.getPageData();
  print(fetchedData?[0].coverImageUrl.toString());
  if (fetchedData != null) {
  setState(() {
  //pageData = fetchedData as Map<String, dynamic>;
  });
  } else {
    print("ERROR, NO FETCHING DATA FROM THE DATABASE FOUND (error de consulta en grahpql)");
  }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'OTAKU TRACING',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(//Parte del menu Lateral
              decoration: BoxDecoration(
                color: Colors.redAccent,
              ),
              child: Text(
                'User Name',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Perfil'),
              onTap: () {
                print('Messages clicked');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.account_balance_outlined),
              title: Text('Siguiendo'),
            ),
            ListTile(
              leading: Icon(Icons.message),
              title: Text('Foros'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
            ),
            ListTile(
              leading: Icon(Icons.account_balance_wallet),
              title: Text('Log out'),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/img/backgroundTwo.jpg'), // Ruta de la imagen de fondo
                fit: BoxFit.cover, // Ajuste de la imagen de fondo
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
                      child: TextFormField(
                        style: TextStyle(fontSize: 14), // Tamaño del texto
                        decoration: InputDecoration(
                          labelText: 'search',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10), // Padding interno del campo de entrada
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SettingsPage()),
                          );
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
