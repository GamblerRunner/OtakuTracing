import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfc/Firebase_Manager.dart';
import 'package:tfc/video_player.dart';
import 'AnimeData.dart';
import 'AnimeModel.dart';
import 'chat_page.dart';
import 'animation.dart';

Future<void> main() async {
  runApp(MaterialApp(
    home: InterfaceAnimePage(),
  ));
}

class InterfaceAnimePage extends StatefulWidget {
  @override
  InterfaceAnime createState() => InterfaceAnime();
}

class InterfaceAnime extends State<InterfaceAnimePage> {
  late FirebaseManager fm;

  List<Anime> fetchedAnimeData = [];
  List<String> fetchedEpisodes = [];

  final AnimeData data = AnimeData();

  bool following = false;

  List<int> fetchedEpisodesSeen= [];
  List<int> fetchedEpisodesWatching= [];

  @override
  void initState() {
    super.initState();
    fm = FirebaseManager();
    fetchMangaData();
  }

  Future<void> fetchMangaData() async {
    List<Anime> fetchedAnimeData2 = await data.getIdAnime();
    bool following2 = await fm.getUserFavourite(fetchedAnimeData2[0].id, false);
    List<int> getEpisodes= await fm.getSeenMedia(fetchedAnimeData2[0].romajiTitle ?? 'no', false);
    List<int> getEpisodesWatching=await fm.getEpisodeWatching(fetchedAnimeData2[0].romajiTitle ?? 'no');
    List<String> getEpisodesFirebase = await fm.getEpisodes(fetchedAnimeData2[0].romajiTitle ?? 'no');
    print(getEpisodes);
    print(getEpisodesWatching);
    print(fetchedAnimeData2?[0].coverImageUrl.toString());
    if (fetchedAnimeData != null) {
      print("aaaaaaaaaaaaaaaaaaaaaah $following2");
      setState(() {
        fetchedAnimeData = fetchedAnimeData2;
        following = following2;
        fetchedEpisodesSeen = getEpisodes;
        fetchedEpisodesWatching = getEpisodesWatching;
        fetchedEpisodes = getEpisodesFirebase;
      });
    } else {
      print("ERROR, NO FETCHING DATA FROM THE DATABASE FOUND (error de consulta en grahpql)");
    }
  }

  String getFormattedDate() {
    if (fetchedAnimeData[0].startDate == null || fetchedAnimeData[0].startDate == 0) return 'Unknown';
    final year = (fetchedAnimeData[0].startDate! ~/ 10000).toString().padLeft(4, '0');
    final month = ((fetchedAnimeData[0].startDate! % 10000) ~/ 100).toString().padLeft(2, '0');
    final day = (fetchedAnimeData[0].startDate! % 100).toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          fetchedAnimeData[0].romajiTitle ?? 'Loading...',
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    child: Image.network(
                      fetchedAnimeData[0].imageUrlTitle ?? fetchedAnimeData[0].coverImageUrl ?? 'https://cdn.pixabay.com/photo/2022/09/01/14/18/white-background-7425603_1280.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 16),
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
                    cambiosSinopsis(fetchedAnimeData[0].description ?? 'Loading...'),
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),

                  SizedBox(height: 16),
                  Text(
                    'Accede:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AnimatedFavouriteButton(
                        onPressed: () {
                          following = !following;
                          fm.addRemoveFavourite(fetchedAnimeData[0].id, true, following);
                        },
                        isInitiallyFavoured: following, // puedes ajustar este valor basado en tu lógica
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatPage(
                                    community: fetchedAnimeData[0].englishTitle!.toString(),
                                  )));
                        },
                        child: Text('Ir a comunidad(foro)'),
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
                    cambiosEstado(fetchedAnimeData[0].status?.toString()),
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
                    fetchedAnimeData[0].genres.toString().substring(1, fetchedAnimeData[0].genres.toString().length - 1),
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
                      itemCount: fetchedEpisodes.length,
                      itemBuilder: (context, index) {
                        bool watched = fetchedEpisodesSeen.contains(index + 1);
                        bool watching = fetchedEpisodesWatching.contains(index + 1);
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
                              'Capítulo ${index + 1}',
                              style: TextStyle(
                                color: watched
                                    ? Colors.red : (watching ? Colors.green : Colors.white),
                              ),

                            ),
                            onTap: () async {
                              SharedPreferences preferences = await SharedPreferences.getInstance();
                              await preferences.setString("videoId", fetchedEpisodes[index] ?? '1');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PlayerAnime(
                                    totalEpisodes: fetchedEpisodes.length ?? 0,
                                    currentEpisode: index + 1,
                                    AnimeName: fetchedAnimeData[0].romajiTitle ?? "no title",
                                    getEpisodes: fetchedEpisodes,
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