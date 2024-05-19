import 'package:flutter/material.dart';

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
                image: AssetImage(
                    'assets/img/backgroundTwo.jpg'), // Ruta de la imagen de fondo
                fit: BoxFit.cover, // Ajuste de la imagen de fondo
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
                    color: Color.fromARGB(128, 0, 0, 255),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              print('Image clicked!');
                            },
                            child: ClipOval(
                              child: Image.network(
                                'https://wallpapers.com/images/featured/best-anime-syxejmngysolix9m.jpg', //Imagen del usuario
                                width: 300,
                                height: 300,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 35,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 150, // Ajusta el ancho del campo de entrada aquí
                            child: TextFormField(
                              style: TextStyle(fontSize: 14), // Tamaño del texto
                              decoration: InputDecoration(
                                labelText: 'User Name',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10), // Padding interno del campo de entrada
                              ),
                            ),
                          ),
                          SizedBox(width: 40),
                          SizedBox(
                            width: 70,
                            height: 50,
                            child: FloatingActionButton(
                              onPressed: () {},
                              child: Text('Guardar'),
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
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
                    children: [
                      Material(
                        color: Colors.transparent, // Hace que el Material sea transparente
                        child: InkWell(
                          onTap: () {
                            print('Favorite icon clicked!');
                          },
                          child: Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 150,
                            shadows: [
                              BoxShadow(
                                color: Colors.black,
                                offset: Offset(8, 8),
                                spreadRadius: 10,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Material(
                        color: Colors.transparent, // Hace que el Material sea transparente
                        child: InkWell(
                          onTap: () {
                            print('People icon clicked!');
                          },
                          child: Icon(
                            Icons.people,
                            color: Colors.blueAccent,
                            size: 150,
                            shadows: [
                              BoxShadow(
                                color: Colors.black,
                                offset: Offset(8, 8),
                                spreadRadius: 10,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
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
