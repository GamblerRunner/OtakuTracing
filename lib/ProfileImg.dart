import 'package:flutter/material.dart';

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
  final List<String> imagePaths = [
    'https://wallpapers.com/images/featured/best-anime-syxejmngysolix9m.jpg',
    'https://wallpapers.com/images/featured/best-anime-syxejmngysolix9m.jpg',
    'https://wallpapers.com/images/featured/best-anime-syxejmngysolix9m.jpg',
    'https://wallpapers.com/images/featured/best-anime-syxejmngysolix9m.jpg',
    'https://wallpapers.com/images/featured/best-anime-syxejmngysolix9m.jpg',
    'https://wallpapers.com/images/featured/best-anime-syxejmngysolix9m.jpg',
    'https://wallpapers.com/images/featured/best-anime-syxejmngysolix9m.jpg',
    'https://wallpapers.com/images/featured/best-anime-syxejmngysolix9m.jpg',
    // Añade más imágenes según sea necesario
  ];

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
    onTap: () {
      print('Tapped on ${imageCloud![index]}');
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