import 'package:flutter/material.dart';

import 'Firebase_Manager.dart';


class ReadMangaApp extends StatelessWidget {
  final int totalChapters;
  final int currentChapter;
  final String MangaName;

  const ReadMangaApp({Key? key, required this.totalChapters, required this.currentChapter, required this.MangaName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ReadMangaPage(totalChapters: totalChapters, selectedChapter: currentChapter, mangaName:  MangaName),
    );
  }
}

class ReadMangaPage extends StatefulWidget {
  final int totalChapters;
  int selectedChapter;
  String mangaName;

  ReadMangaPage({required this.totalChapters, required this.selectedChapter, required this.mangaName}); // Modificar el constructor

  @override
  _ReadMangaPageState createState() => _ReadMangaPageState();
}

class _ReadMangaPageState extends State<ReadMangaPage> {
  late FirebaseManager fm;
  bool isCascada = true;
  int currentPage = 0;

  late List<String> images = [
    'https://cdn.pixabay.com/photo/2015/02/22/17/56/loading-645268_1280.jpg',
  ];

  final PageController _pageController = PageController();
  final ScrollController _cascadaController = ScrollController();

  void initState() {
    super.initState();
    fm = FirebaseManager();
    fm.saveWatchingManga(widget.mangaName, widget.selectedChapter);
    fetchPageData();
  }

  Future<void> fetchPageData() async {
    String chapterName = ('Chapter${widget.selectedChapter+1}').toString();
    List<String> fetchedPages = await fm.getPages(chapterName);

    setState(() {
      images = fetchedPages;
    });
  }

  Future<void> updateWatchedEpisode() async {
    fm.saveEndDuration(widget.mangaName, widget.selectedChapter, true);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color :Colors.white),
        title: Text(
          'EPISODE ${widget.selectedChapter}', // Mostrar el número del capítulo seleccionado
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
          if (widget.selectedChapter > 0) // Verifica si el capítulo actual es mayor que 1
            Positioned(
              left: 10,
              bottom: 80,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (widget.selectedChapter > 0) {
                      widget.selectedChapter--;
                      fetchPageData();
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
                  updateWatchedEpisode();
                  setState(() {
                    if (widget.selectedChapter < widget.totalChapters) {
                      widget.selectedChapter++;
                      fetchPageData();
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
      child: Image.network(imagePath, fit: boxFit),
    );
  }
}
