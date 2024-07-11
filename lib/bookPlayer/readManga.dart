import 'package:flutter/material.dart';
import '../Firebase/Firebase_Manager.dart';


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

  final PageController pageController = PageController();
  final ScrollController cascadaController = ScrollController();

  void initState() {
    super.initState();
    fm = FirebaseManager();
    fm.saveWatchingManga(widget.mangaName, widget.selectedChapter);
    fetchPageData();
  }

  Future<void> fetchPageData() async {
    String chapterName = ('Chapter${widget.selectedChapter+1}').toString();
    List<String> fetchedPages = await fm.getPages(chapterName); // Load the images from the database

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
          'CHAPTER ${widget.selectedChapter}', // Show the number of chapter selected
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
                    child: isCascada ? buildCascadaView() : buildPageView(),
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
                        cascadaController.jumpTo(0);
                      } else {
                        pageController.jumpTo(0);
                      }
                    }
                  });
                },
                child: Text('Previous'),
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
                        cascadaController.jumpTo(0);
                      } else {
                        pageController.jumpTo(0);
                      }
                    }
                  });
                },
                child: Text('Next'),
              ),
            ),
        ],
      ),
    );
  }

  /// Builds a ListView in a cascading (waterfall) layout.
  ///
  /// This widget uses a ListView.builder to create a scrollable list of images,
  /// each image is wrapped in a container and displayed with BoxFit.cover.
  Widget buildCascadaView() {
    return ListView.builder(
      controller: cascadaController, // Controller to manage scrolling in the ListView.
      itemCount: images.length, // Number of images to display.
      itemBuilder: (context, index) {
        return buildImageContainer(images[index], BoxFit.cover); // Builds each image container.
      },
    );
  }

  /// Builds a PageView for swiping between images.
  ///
  /// This widget uses a PageView.builder to create a swipeable list of images,
  /// and updates the current page index on page change.
  Widget buildPageView() {
    return PageView.builder(
      itemCount: images.length, // Number of images to display.
      controller: pageController, // Controller to manage the PageView.
      pageSnapping: true, // Enables page snapping.
      onPageChanged: (index) {
        setState(() {
          currentPage = index; // Updates the current page index.
        });
      },
      itemBuilder: (context, index) {
        return buildImageContainer(images[index], BoxFit.contain); // Builds each image container.
      },
    );
  }

  /// Builds a container for displaying an image.
  ///
  /// This helper widget creates a container with the specified image and fit.
  Widget buildImageContainer(String imagePath, BoxFit boxFit) {
    return Container(
      width: double.infinity, // Makes the container as wide as its parent.
      child: Image.network(imagePath, fit: boxFit), // Loads the image from the network.
    );
  }

}
