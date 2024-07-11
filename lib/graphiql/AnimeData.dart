import 'package:shared_preferences/shared_preferences.dart';
import 'AnimeModel.dart';
import 'GrahpqlData.dart';

class AnimeData {
  late final GrahpqlData client=GrahpqlData();


  //Every variable from here is used for every different type of query
  static const String animeQuery = r'''
    query ($page: Int, $perPage: Int) {
      Page (page: $page, perPage: $perPage) {
        pageInfo {
          total
          currentPage
          lastPage
          hasNextPage
          perPage
        }
        media (type: ANIME){
          id
          coverImage{
            extraLarge
          }
          title {
            english
            romaji
          }
          description
        }
      }
    }
  ''';

  static const String animeSearchQuery = r'''
    query ($page: Int, $perPage: Int, $search: String) {
      Page (page: $page, perPage: $perPage) {
        pageInfo {
          total
          currentPage
          lastPage
          hasNextPage
          perPage
        }
        media (type:ANIME , search: $search){
          id
          coverImage{
            extraLarge
          }
          title {
            english
            romaji
          }
          description
        }
      }
    }
  ''';

  static const String mangaQuery = r'''
    query ($page: Int, $perPage: Int) {
      Page (page: $page, perPage: $perPage) {
        pageInfo {
          total
          currentPage
          lastPage
          hasNextPage
          perPage
        }
        media (type: MANGA){
          id
          coverImage{
            extraLarge
          }
          title {
            english
            romaji
          }
          description
        }
      }
    }
  ''';
  static const String mangaSearchQuery = r'''
    query ($page: Int, $perPage: Int, $search: String) {
      Page (page: $page, perPage: $perPage) {
        pageInfo {
          total
          currentPage
          lastPage
          hasNextPage
          perPage
        }
        media (type:MANGA , search: $search){
          id
          coverImage{
            extraLarge
          }
          title {
            english
            romaji
          }
          description
        }
      }
    }
  ''';


  static const String idMangaSearchQuery = r'''
    query ($id: Int) {
      Page (page: 1, perPage: 1) {
        pageInfo {
          total
          currentPage
          lastPage
          hasNextPage
          perPage
        }
        media (id: $id){
          id
          coverImage{
            extraLarge
          }
          bannerImage
          title {
            userPreferred
            romaji
          }
          description
          startDate{
            year
            month
            day
          }
          status
          volumes
          chapters
          genres
        }
      }
    }
  ''';

  static const String idAnimeSearchQuery = r'''
    query ($id: Int) {
      Page (page: 1, perPage: 1) {
        pageInfo {
          total
          currentPage
          lastPage
          hasNextPage
          perPage
        }
        media (id: $id){
          id
          coverImage{
            extraLarge
          }
          bannerImage
          title {
            userPreferred
            romaji
          }
          description
          startDate{
            year
            month
            day
          }
          status
          episodes
          trailer{
            id
          }
          genres
        }
      }
    }
  ''';

  static const String idAnimeSearchQueryAlter = r'''
    query ($id: Int) {
      Page (page: 1, perPage: 1) {
        pageInfo {
          total
          currentPage
          lastPage
          hasNextPage
          perPage
        }
        media (id: $id){
          id
          coverImage{
            extraLarge
          }
          bannerImage
          title {
            userPreferred
            romaji
          }
          description
          startDate{
            year
            month
            day
          }
          status
          episodes
          relations{
            nodes{
              trailer{
                id
              }
            }
          }
          genres
        }
      }
    }
  ''';

  static const String myMediaQuery = r'''
    query ($page: Int, $perPage: Int, $id_in: [Int!]) {
      Page (page: $page, perPage: $perPage) {
        pageInfo {
          total
          currentPage
          lastPage
          hasNextPage
          perPage
        }
        media (id_in:$id_in){
          id
          coverImage{
            extraLarge
          }
          title {
            userPreferred
            romaji
          }
          description
        }
      }
    }
  ''';

  static const int perPage = 20;
  List<Media> animeList = [];
  List<Manga> manga = [];
  List<Anime> anime = [];
  var currentPage = 1;
  var totalPages = 250;

  Future<List<Media>> getPageData(bool animemanga) async {
    if(!animemanga){
      try {
        //Calls the method query in GrahpqlData class
        final result = await client.query(
          animeQuery, // Use the static query string
          variables: {'page': currentPage, 'perPage': perPage},
        );
        if (result.hasException) {
          throw Exception("Error getting the data");
        }

        final MediaModel animeData =
        MediaModel.fromJson(result.data?['Page'] ?? {});
        totalPages = animeData.pageInfo.total;
        animeList.addAll(animeData.media);
        return animeList;
      } catch (e) {
        throw Exception("Error getting the data");
      }
    }
      try {
        final result = await client.query(
          mangaQuery, // Use the static query string
          variables: {'page': currentPage, 'perPage': perPage},
        );
        if (result.hasException) {
          throw Exception("Error getting the data");
        }

        final MediaModel animeData =
        MediaModel.fromJson(result.data?['Page'] ?? {});
        totalPages = animeData.pageInfo.total;
        animeList.addAll(animeData.media);
        return animeList;
      } catch (e) {
        throw Exception("Error getting the data");
      }

  }

  Future<List<Media>> getPageSearchData(String search, bool am) async {
    try {
      String media = animeSearchQuery;
      if(am){
        media = mangaSearchQuery;
      }
      final result = await client.query(
        media,
        variables: {'page': currentPage, 'perPage': perPage, 'search': search},
      );
      if (result.hasException) {
        throw Exception("Error getting the data");
      }

      final MediaModel animeData =
      MediaModel.fromJson(result.data?['Page'] ?? {});
      totalPages = animeData.pageInfo.total;
      animeList.addAll(animeData.media);
      return animeList;
    } catch (e) {
      throw Exception("Error getting the data");
    }

  }

  Future<List<Media>?> fetchNextPage(bool afterBefore, bool media) async {
    try{
      if(afterBefore){
        if (currentPage < totalPages) {
          animeList=[];
          currentPage++;
          return await getPageData(media);
        }
      }else{
        if (currentPage > 1) {
          animeList=[];
          currentPage--;
          return await getPageData(media);
        }
      }
    } catch (e) {
      throw Exception("Error getting the data");
    }
    return null;
  }

  Future<List<Manga>> getIdManga() async {
    try {
      SharedPreferences preferences= await SharedPreferences.getInstance();
      int? id=await preferences.getInt("idMedia") ?? 1;
      await Future.delayed(Duration(seconds: 1));

      final result = await client.query(
        idMangaSearchQuery, // Use the static query string
        variables: {'id': id},
      );
      if (result.hasException) {
        throw Exception("Error getting the data");
      }

      final MangaModel animeData =
      MangaModel.fromJson(result.data?['Page'] ?? {});
      totalPages = animeData.pageInfo.total;
      manga.addAll(animeData.media);
      return manga;
    } catch (e) {
      throw Exception("Error getting the data");
    }

  }

  Future<List<Anime>> getIdAnime() async {
    try {
      SharedPreferences preferences= await SharedPreferences.getInstance();
      int? id=await preferences.getInt("idMedia") ?? 1;

      await Future.delayed(Duration(seconds: 1));

      final result = await client.query(
        idAnimeSearchQuery, // Use the static query string
        variables: {'id': id},
      );
      if (result.hasException) {
        throw Exception("Error getting the data");
      }

      final AnimeModel animeData =
      AnimeModel.fromJson(result.data?['Page'] ?? {});
      totalPages = animeData.pageInfo.total;
      anime.addAll(animeData.media);
      return anime;
    } catch (e) {
      throw Exception("Error getting the data");
    }
  }

  Future<List<Media>> getMyMedia(List<int> medias) async {
      try {
        final result = await client.query(
          myMediaQuery, // Use the static query string
          variables: {'page': currentPage, 'perPage': perPage, 'id_in': medias},
        );
        if (result.hasException) {
          throw Exception("Error getting the data");
        }

        final MediaModel animeData =
        MediaModel.fromJson(result.data?['Page'] ?? {});
        totalPages = animeData.pageInfo.total;
        animeList.addAll(animeData.media);
        return animeList;
      } catch (e) {
        throw Exception("Error getting the data");
      }
    }

}
