import 'package:flutter/material.dart';

void main() {
  runApp(ReadMangaApp());
}

class ReadMangaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ReadMangaPage(totalChapters: 5, selectedChapter: 1),
    );
  }
}

class ReadMangaPage extends StatefulWidget {
  final int totalChapters;
  int selectedChapter; // Número del capítulo seleccionado

  ReadMangaPage({required this.totalChapters, required this.selectedChapter}); // Modificar el constructor

  @override
  _ReadMangaPageState createState() => _ReadMangaPageState();
}

class _ReadMangaPageState extends State<ReadMangaPage> {
  bool isCascada = true;
  int currentPage = 0;

  // CARGAMOS LAS IMAGENES AQUI
  final List<String> images = [
    'assets/img/fotoMangaStock1.png',
    'assets/img/fotoMangaStock2.png',
    'assets/img/fotoMangaStock3.png',
    'assets/img/fotoMangaStock4.png',
    'assets/img/fotoMangaStock5.png',
  ];

  final PageController _pageController = PageController();
  final ScrollController _cascadaController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CAPITULO ${widget.selectedChapter}', // Mostrar el número del capítulo seleccionado
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
              'assets/img/fondoPantalla.jpg',
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
                    child: isCascada ? _buildCascadaView() : _buildPageView(),
                  ),
                ),
              ),
            ],
          ),
          // Botones de flecha
          if (widget.selectedChapter > 1) // Verifica si el capítulo actual es mayor que 1
            Positioned(
              left: 10,
              bottom: 80,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (widget.selectedChapter > 1) {
                      widget.selectedChapter--;
                      if (isCascada) {
                        _cascadaController.jumpTo(0);
                      } else {
                        _pageController.jumpTo(0);
                      }
                    }
                  });
                },
                child: Text('Anterior'),
              ),
            ),
          if (widget.selectedChapter < widget.totalChapters)
            Positioned(
              right: 10,
              bottom: 80,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (widget.selectedChapter < widget.totalChapters) {
                      widget.selectedChapter++;
                      if (isCascada) {
                        _cascadaController.jumpTo(0);
                      } else {
                        _pageController.jumpTo(0);
                      }
                    }
                  });
                },
                child: Text('Siguiente'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCascadaView() {
    return ListView.builder(
      controller: _cascadaController, // Controlador de desplazamiento para la vista en cascada
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
