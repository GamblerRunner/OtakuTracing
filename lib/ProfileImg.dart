import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfc/Profile.dart';

import 'Firebase_Manager.dart';

void main() {
  runApp(MaterialApp(
    home: ProfileImgPage(),
  ));
}

class ProfileImgPage extends StatefulWidget {
  @override
  ProfileImg createState() => ProfileImg();
}

class ProfileImg extends State<ProfileImgPage> {
  late FirebaseManager fm;

  List<String> imagePaths = [];

  @override
  void initState() {
    super.initState();
    fm = FirebaseManager();

    getImgs();
  }

  void getImgs() async {
    await Future.delayed(Duration(seconds: 3));

    List<String> newImagePaths = await fm.changeImgProfile();

    setState(() {
      imagePaths = newImagePaths;
    });

    print('Imagenes obtenidas: $imagePaths');
  }

  Future<void> setImg(String url) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    await preferences.setString("newImgProfile", url);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ProfilePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color :Colors.white),
        title: Text(
          'Select profile photo',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/fondoPantalla.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: ProfileImage(imageCloud: imagePaths),
      ),
    );
  }
}

class ProfileImage extends StatelessWidget {
  final List<String> imageCloud;

  ProfileImage({required this.imageCloud});

  @override
  Widget build(BuildContext context) {
    // Obtener el ancho de la pantalla
    final screenWidth = MediaQuery.of(context).size.width;
    // Definir el tamaño de las imágenes
    final itemSize = screenWidth / 3; // 3 imágenes por fila

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Número de columnas
        crossAxisSpacing: 4.0, // Espacio horizontal entre las imágenes
        mainAxisSpacing: 4.0, // Espacio vertical entre las imágenes
      ),
      itemCount: imageCloud.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () async {
            SharedPreferences preferences =
            await SharedPreferences.getInstance();

            await preferences.setString("ImgProfile", imageCloud[index]);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          },
          child: Card(
            child: SizedBox(
              width: itemSize,
              height: itemSize,
              child: Image.network(
                imageCloud[index],
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
}
