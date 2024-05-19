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
          image: AssetImage('assets/img/backgroundTwo.jpg'), // Ruta de la imagen de fondo
      fit: BoxFit.cover, // Ajuste de la imagen de fondo
    ),
    ),
    ),
    Padding(

    ),

    ],
    ),
    );
    }




}