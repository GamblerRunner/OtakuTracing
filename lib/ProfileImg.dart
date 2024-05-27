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

   List<String> imagePaths = [
    /*'https://wallpapers.com/images/featured/best-anime-syxejmngysolix9m.jpg',
    'https://cdn.pixabay.com/photo/2024/05/01/15/50/anime-8732561_1280.png',
    'https://cdn.pixabay.com/photo/2023/06/29/19/08/dragonball-8096947_1280.jpg',
    'https://cdn.pixabay.com/photo/2023/06/29/19/08/dragonball-8096948_1280.jpg',
    'https://cdn.pixabay.com/photo/2023/10/09/11/30/ai-generated-8303928_1280.png',
    'https://cdn.pixabay.com/photo/2023/01/27/11/09/anime-7748411_1280.jpg',
    'https://cdn.pixabay.com/photo/2022/04/13/03/53/manga-7129357_1280.png',
    'https://cdn.pixabay.com/photo/2022/07/13/05/25/ninja-7318576_1280.png',*/
  ];

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

    print('nooooo saleeeee $imagePaths');

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
        title: Text(
          'Seleccine una Imagen',
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
      body: ProfileImage(imageCloud: imagePaths),
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
      print('Tapped on ${imageCloud![index]}');
      SharedPreferences preferences = await SharedPreferences.getInstance();

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