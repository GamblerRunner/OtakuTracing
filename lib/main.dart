import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tfc/Profile.dart';
import 'package:tfc/login.dart';
import 'AnimeData.dart';
import 'AnimeModel.dart';
import 'firebase_options.dart';
import 'register.dart';

Future<void> main() async {
  runApp(MaterialApp(
    home: HomePage(),
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? search = '';

  @override
  void initState() {
    super.initState();
    fetchData(); // Llama a la función para obtener los datos al inicializar el widget
    obtenerFirebaseCloud();
  }

  //Borrar una vez funcione

  Future<void> obtenerFirebaseCloud() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseFirestore db = FirebaseFirestore.instance;

    final city = <String, String>{
      "name": "Los Angeles",
      "state": "CA",
      "country": "USA"
    };

    db
        .collection("cities")
        .doc("LA")
        .set(city)
        .onError((e, _) => print("Error writing document: $e"));


    final data = {"capital": true};

    db.collection("cities").doc("BJ").set(data, SetOptions(merge: true));

  }

  //Hasta aqui

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

  Future<void> fetchSearchData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Guardar los valores del formulario
      if(search!.isEmpty){
        return;
      }
      fetchedData.clear();
      fetchedData = await data.getPageSearchData(search!);
      print(fetchedData?[0].coverImageUrl.toString());
      if (fetchedData != null) {
        setState(() {
          //pageData = fetchedData as Map<String, dynamic>;
        });
      } else {
        print("ERROR, NO FETCHING DATA FROM THE DATABASE FOUND (error de consulta en grahpql)");
      }
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
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
