import 'package:flutter/material.dart';
import 'package:tfc/Firebase_Manager.dart';
import 'AnimeData.dart';
import 'AnimeModel.dart';
import 'animation.dart';
import 'chat_page.dart';
import 'readManga.dart';

Future<void> main() async {
  runApp(MaterialApp(
    home: InterfaceMangaPage(),
  ));
}

class InterfaceMangaPage extends StatefulWidget {
  @override
  InterfaceManga createState() => InterfaceManga();
}

class InterfaceManga extends State<InterfaceMangaPage> {
  late FirebaseManager fm;

  List<Manga> fetchedMangaData = [];

  final AnimeData data = AnimeData();

  bool following = false;

  List<int> fetchedChaptersSeen= [];
  List<int> fetchedChaptersWatching= [];

  int numberChapters = 0;

  @override
  void initState() {
    super.initState();
    fm = FirebaseManager();
    fetchMangaData();
  }

  Future<void> fetchMangaData() async {
    List<Manga> fetchedMangaData2 = await data.getIdManga();

    // Asegurarse de que el ID no sea nulo y sea del tipo correcto
    var mangaId = fetchedMangaData2[0].id;
    if (mangaId is int) {
      bool following2 = await fm.getUserFavourite(mangaId, true);
      List<int> getChapters= await fm.getSeenMedia(fetchedMangaData2[0].romajiTitle ?? 'no', true);
      List<int> getChaptersWatching=await fm.getChapterWatching(fetchedMangaData2[0].romajiTitle ?? 'no');
      int numberChapters2 = await fm.getChapters(fetchedMangaData2[0].romajiTitle ?? 'no', fetchedMangaData2[0].chapters ?? 0);
      print('TREMENDOOOOOO');
      print(getChaptersWatching);
      setState(() {
        fetchedMangaData = fetchedMangaData2;
        following = following2;
        fetchedChaptersSeen = getChapters;
        fetchedChaptersWatching = getChaptersWatching;
        numberChapters = numberChapters2;
      });
    } else {
      print("Error: El ID del manga no es un entero.");
    }
  }

  String getFormattedDate() {
    if (fetchedMangaData.isEmpty || fetchedMangaData[0].startDate == null || fetchedMangaData[0].startDate == 0) return 'Unknown';
    final startDate = fetchedMangaData[0].startDate!;
    if (startDate is int) {
      final year = (startDate ~/ 10000).toString().padLeft(4, '0');
      final month = ((startDate % 10000) ~/ 100).toString().padLeft(2, '0');
      final day = (startDate % 100).toString().padLeft(2, '0');
      return '$year-$month-$day';
    }
    return 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color :Colors.white),
        title: Text(
          formatTitle(fetchedMangaData.isNotEmpty ? fetchedMangaData[0].romajiTitle ?? 'Loading...' : 'Loading...'),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          maxLines: 2,
          overflow: TextOverflow.visible,
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/img/fondoPantalla.jpg',
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: fetchedMangaData.isNotEmpty ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Portada del manga
                  Container(
                    width: double.infinity,
                    height: 300, // Ajustar la altura según sea necesario
                    child: Image.network(
                      fetchedMangaData[0].imageUrlTitle ??
                          fetchedMangaData[0].coverImageUrl ??
                          'https://cdn.pixabay.com/photo/2022/09/01/14/18/white-background-7425603_1280.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 16),
                  // Resto de la información del manga
                  Text(
                    'Sinopsis:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    cambiosSinopsis(fetchedMangaData[0].description ?? 'Loading...'),
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AnimatedFavouriteButton(
                        onPressed: () {
                          setState(() {
                            following = !following;
                          });
                          var mangaId = fetchedMangaData[0].id;
                          if (mangaId is int) {
                            fm.addRemoveFavourite(mangaId, false, following);
                          }
                        },
                        isInitiallyFavoured: following,
                      ),
                      Column(
                        children: [
                          SizedBox(height: 8),
                          IconButton(
                            icon: Icon(Icons.forum, color: Colors.white, size: 30),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatPage(
                                    community: fetchedMangaData[0].englishTitle ?? '',
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Estado:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    cambiosEstado(fetchedMangaData[0].status?.toString() ?? 'Unknown'),
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Género:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    fetchedMangaData[0].genres?.toString().substring(1, fetchedMangaData[0].genres!.toString().length - 1) ?? 'Unknown',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Fecha de Publicación:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    getFormattedDate(),
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Capítulos:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: (numberChapters ?? 0) + 1, // Adding one for the "COVER" item
                      itemBuilder: (context, index) {
                        // Adjust the chapter index if the "COVER" is at index 0
                        int chapterNumber = index == 0 ? 0 : index;

                        // Check if the current chapter number is in the seen or watching lists
                        bool watched = fetchedChaptersSeen.contains(chapterNumber);
                        bool watching = fetchedChaptersWatching.contains(chapterNumber);

                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            title: Text(
                              index == 0 ? 'COVER' : 'Capítulo $index',
                              style: TextStyle(
                                color: watched
                                    ? Colors.red
                                    : (watching ? Colors.green : Colors.white),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReadMangaPage(
                                    totalChapters: numberChapters ?? 0,
                                    selectedChapter: index,
                                    mangaName: fetchedMangaData[0].romajiTitle ?? 'No Title',
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),

                  ),
                ],
              ) : Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String formatTitle(String title) {
    int maxLength = 30;
    if (title.length > maxLength) {
      int middle = (title.length / 2).round();
      int spaceIndex = title.indexOf(' ', middle);
      if (spaceIndex != -1 && spaceIndex < title.length - 1) {
        return title.substring(0, spaceIndex) + '\n' + title.substring(spaceIndex + 1);
      } else {
        return title.substring(0, middle) + '\n' + title.substring(middle);
      }
    } else {
      return title;
    }
  }

  String cambiosSinopsis(String text) {
    return text.replaceAll('<br>', '');
  }

  String cambiosEstado(String? status) {
    switch (status) {
      case 'Status.FINISHED':
        return 'Finalizado';
      case 'Status.REALISING':
        return 'En emisión';
      default:
        return 'Hiatus';
    }
  }
}
