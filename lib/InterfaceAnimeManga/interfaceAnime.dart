import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfc/Firebase/Firebase_Manager.dart';
import 'package:tfc/mediaPlayer/video_player.dart';
import '../graphiql/AnimeData.dart';
import '../graphiql/AnimeModel.dart';
import '../communitieChat/chat_page.dart';
import '../animation/animation.dart';

Future<void> main() async {
  runApp(MaterialApp(
    home: InterfaceAnimePage(),
  ));
}

class InterfaceAnimePage extends StatefulWidget { //This interface works the same way as the MangaInterface
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
    List<Anime> fetchedAnimeData2 = await data.getIdAnime(); //We get all the anime information from the graphql 'anilist'
    bool following2 = await fm.getUserFavourite(fetchedAnimeData2[0].id, false);// this boolean says if its currently followed or not
    List<int> getEpisodes= await fm.getSeenMedia(fetchedAnimeData2[0].romajiTitle ?? 'no', false);// this list get the episodes are already fully watched
    List<int> getEpisodesWatching=await fm.getEpisodeWatching(fetchedAnimeData2[0].romajiTitle ?? 'no');//this list get the episodes that are curently watching
    List<String> getEpisodesFirebase = [];
    getEpisodesFirebase = await fm.getEpisodes(fetchedAnimeData2[0].romajiTitle ?? 'no');//It get the total number of episodes in the Collecion Firebase
    getEpisodesFirebase.insert(0, fetchedAnimeData2[0].mediaPlay ?? 'no');

    if (fetchedAnimeData != null) {
      setState(() {//Once every method here finish, it will update the page with that information
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
        iconTheme: IconThemeData(color :Colors.white),
        title: Text(
          formatTitle(fetchedAnimeData.isNotEmpty ? fetchedAnimeData[0].romajiTitle ?? 'Loading...' : 'Loading...'),
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
              child: fetchedAnimeData.isNotEmpty ? Column(
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
                    'Synopsis:',
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
                      IconButton(
                        icon: Icon(Icons.forum, color: Colors.white, size:30),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatPage(
                                community: fetchedAnimeData[0].englishTitle!.toString(),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Status:',
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
                    'Gender:',
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
                    'Publication date:',
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
                    'Episodes:',
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
                        if (index == 0) {
                          return Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              title: Text(
                                'Trailer',
                                style: TextStyle(color: Colors.white),
                              ),
                              onTap: () async {
                                if (fetchedAnimeData.isNotEmpty) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PlayerAnime(//To pass to the page with mediaPlayer, you must pass the total number, the trailer, the number of the episode and the name
                                            totalEpisodes: fetchedAnimeData[0].episodes ?? 0,
                                            currentEpisode: 0,
                                            AnimeName: fetchedAnimeData[0].romajiTitle ?? 'No Title',
                                            getEpisodes: fetchedEpisodes,
                                            getTrailer: fetchedAnimeData[0].mediaPlay ?? '1',
                                          ),
                                    ),
                                  );
                                }
                              },
                            ),
                          );
                        } else {
                          bool watched = fetchedEpisodesSeen.contains(index);
                          bool watching = fetchedEpisodesWatching.contains(index);
                          return Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              title: Text(
                                'Episode ${index}',
                                style: TextStyle(//In case a number of wpisode is been watched, it will be the text color in green, if its watched red and if it's none then white
                                  color: watched
                                      ? Colors.red : (watching
                                      ? Colors.green
                                      : Colors.white),
                                ),

                              ),
                              onTap: () async {
                                SharedPreferences preferences = await SharedPreferences
                                    .getInstance();
                                await preferences.setString(
                                    "videoId", fetchedEpisodes[index] ?? '1');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PlayerAnime(
                                          totalEpisodes: fetchedEpisodes.length ?? 0,
                                          currentEpisode: index ,
                                          AnimeName: fetchedAnimeData[0].romajiTitle ?? "no title",
                                          getEpisodes: fetchedEpisodes,
                                          getTrailer: fetchedAnimeData[0].mediaPlay ?? '1',
                                        ),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      }
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
        return 'Ended';
      case 'Status.REALISING':
        return 'In broadcast';
      default:
        return 'Hiatus';
    }
  }
}