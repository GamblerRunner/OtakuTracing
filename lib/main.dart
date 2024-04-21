import 'package:flutter/material.dart';
import 'package:tfc/infoAnimeManga.dart';
import 'package:tfc/login.dart';
import 'register.dart';

void main() {
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
  List<InfoAnimeManga> AnimeManga = [
    InfoAnimeManga(
      titulo: "Nombre 1",
      imagenUrl: "assets/img/animeimg.jpg",
      anio: 2020,
      genero: "Acción",
    ),
    InfoAnimeManga(
      titulo: "Nombre 2",
      imagenUrl: "assets/img/animeimg.jpg",
      anio: 2019,
      genero: "Comedia",
    ),
    InfoAnimeManga(
      titulo: "Nombre 3",
      imagenUrl: "assets/img/animeimg.jpg",
      anio: 2021,
      genero: "Drama",
    ),
    InfoAnimeManga(
      titulo: "Nombre 1",
      imagenUrl: "assets/img/animeimg.jpg",
      anio: 2020,
      genero: "Acción",
    ),
    InfoAnimeManga(
      titulo: "Nombre 2",
      imagenUrl: "assets/img/animeimg.jpg",
      anio: 2019,
      genero: "Comedia",
    ),
    InfoAnimeManga(
      titulo: "Nombre 3",
      imagenUrl: "assets/img/animeimg.jpg",
      anio: 2021,
      genero: "Drama",
    ),
    InfoAnimeManga(
      titulo: "Nombre 3",
      imagenUrl: "assets/img/animeimg.jpg",
      anio: 2021,
      genero: "Drama",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    ClipOval(
                      child: Image.network(
                        'https://wallpapers.com/images/featured/best-anime-syxejmngysolix9m.jpg',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
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
                            MaterialPageRoute(builder: (context) => LoginPage()),
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
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 8),
              itemCount: (AnimeManga.length / 2).ceil(),
              itemBuilder: (context, index) {
                int firstIndex = index * 2;
                int secondIndex = firstIndex + 1;

                return Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildPeliculaCard(AnimeManga[firstIndex]),
                      ),
                      SizedBox(width: 8),
                      if (secondIndex < AnimeManga.length)
                        Expanded(
                          child:
                          _buildPeliculaCard(AnimeManga[secondIndex]),
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
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: 100,
            height: 50,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: Text('Registrarse'),
              backgroundColor: Colors.white,
            ),
          ),
          SizedBox(width: 10),
          SizedBox(
            width: 100,
            height: 50,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text('Iniciar Sesión'),
              backgroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeliculaCard(InfoAnimeManga pelicula) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          pelicula.imagenUrl,
          width: 150,
          height: 200,
          fit: BoxFit.cover,
        ),
        SizedBox(height: 8),
        Text(
          pelicula.titulo,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Año: ${pelicula.anio}',
          style: TextStyle(fontSize: 16),
        ),
        Text(
          'Género: ${pelicula.genero}',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
