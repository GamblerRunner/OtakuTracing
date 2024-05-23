import 'package:flutter/material.dart';

void main() {
  runApp(readMangaApp());
}

class readMangaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: readMangaPage(),
    );
  }
}

class readMangaPage extends StatefulWidget {
  @override
  _readMangaPageState createState() => _readMangaPageState();
}

class _readMangaPageState extends State<readMangaPage> {
  bool isCascada = true;
  int currentPage = 0;

  // CARGAMOS LAS IMAGENES AQUI
  final List<String> images = [
    'assets/img/jjk1.png',
    'assets/img/jjk2.png',
  ];

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CAPITULO 1',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Fondo de la imagen
          Positioned.fill(
            child: Image.asset(
              'assets/img/backgroundTwo.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        isCascada = true;
                      });
                    },
                    icon: Icon(
                      Icons.view_agenda_rounded,
                      color: Colors.black,
                    ),
                    label: Text(
                      'Cascada',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  SizedBox(width: 5),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        isCascada = false;
                      });
                    },
                    icon: Icon(
                      Icons.view_week,
                      color: Colors.black,
                    ),
                    label: Text(
                      'Paginada',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20),
                    /*
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1.5),
                    ),
                    */
                    child: isCascada ? _buildCascadaView() : _buildPageView(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCascadaView() {
    return ListView.builder(
      itemCount: images.length,
      itemBuilder: (context, index) {
        return _buildImageContainer(images[index], BoxFit.cover);
      },
    );
  }

  Widget _buildPageView() {
    return PageView.builder(
      itemCount: images.length,
      controller: _pageController,
      pageSnapping: true,
      onPageChanged: (index) {
        setState(() {
          currentPage = index;
        });
      },
      itemBuilder: (context, index) {
        return _buildImageContainer(images[index], BoxFit.contain);
      },
    );
  }

  Widget _buildImageContainer(String imagePath, BoxFit boxFit) {
    return Container(
      width: double.infinity,
      child: Image.asset(imagePath, fit: boxFit),
    );
  }
}
