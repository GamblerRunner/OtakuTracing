import 'package:flutter/material.dart';
import 'package:tfc/Firebase_Manager.dart';
import 'AnimeData.dart';
import 'AnimeModel.dart';
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

  @override
  void initState() {
    super.initState();
    fm = FirebaseManager();
    fetchMangaData();
  }

  Future<void> fetchMangaData() async {
    List<Manga> fetchedMangaData2 = await data.getIdManga();
    print(fetchedMangaData2?[0].coverImageUrl.toString());
    if (fetchedMangaData != null) {
      setState(() {
        fetchedMangaData = fetchedMangaData2;
      });
    } else {
      print("ERROR, NO FETCHING DATA FROM THE DATABASE FOUND (error de consulta en grahpql)");
    }
  }

  String getFormattedDate() {
    if (fetchedMangaData[0].startDate == null || fetchedMangaData[0].startDate == 0) return 'Unknown';
    final year = (fetchedMangaData[0].startDate! ~/ 10000).toString().padLeft(4, '0');
    final month = ((fetchedMangaData[0].startDate! % 10000) ~/ 100).toString().padLeft(2, '0');
    final day = (fetchedMangaData[0].startDate! % 100).toString().padLeft(2, '0');
    return '$year-$month-$day';
  }


  @override
  Widget build(BuildContext context) {
    //String title = 'Mushoku Tensei II: Isekai Ittara Honki Dasu Part 2';
    //String formattedTitle = formatTitle(title);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          fetchedMangaData[0].romajiTitle ?? 'Loading...',
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
                  Center(
                    child: Image.network(
                      fetchedMangaData[0].coverImageUrl ?? 'assets/img/MushokuIndice1.jpg',
                      height: 300,
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
                    fetchedMangaData[0].description ?? 'Loading...',
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
                      ElevatedButton(
                        onPressed: () {
                          fm.addFavourite(fetchedMangaData[0].id , false);
                        },
                        child: Text('Seguir'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          print('hola');
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
                    fetchedMangaData[0].status.toString() ?? 'FINISHED',
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
                    fetchedMangaData[0].genres.toString().substring(1, fetchedMangaData[0].genres.toString().length-1),
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
                      itemCount: fetchedMangaData[0].chapters,
                      itemBuilder: (context, index) {
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
                              style: TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => readMangaPage(),
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
}
