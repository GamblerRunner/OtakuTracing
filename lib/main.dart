import 'package:flutter/material.dart';
import 'package:tfc/login.dart';
import 'register.dart';
//Reproductor video
import 'dart:async';
import 'package:video_player/video_player.dart';
//Firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:tfc/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

//void main() {runApp(MaterialApp(home: HomePage(),));}
//void main() => runApp(const HomePage());
void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}
VideoPlayerController _videoController = VideoPlayerController.network('https://www.yourupload.com/watch/MlK7Jm0oo1S6');

class HomePage extends StatelessWidget {
  //const  HomePage({super.key});//Borrar mas tarde

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

      body: Center(
        child: Text('Bienvenido'),
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
          SizedBox(

            width: 100,
            height: 50,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VideoPlayer(_videoController)),
                );
              },
              child: Text('Reproducir Video'),
              backgroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

}
