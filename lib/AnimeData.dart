import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AnimeModel.dart';
import 'GrahpqlData.dart';

class AnimeData {
  late final GrahpqlData client=GrahpqlData();

  static const String _animeQuery = r'''
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

  static const String _animeSearchQuery = r'''
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

  static const String _mangaQuery = r'''
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
  static const String _mangaSearchQuery = r'''
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

  static const int _perPage = 20;
  List<Media> _animeList = [];
  List<Manga> manga = [];
  List<Anime> anime = [];
  var _currentPage = 1;
  var _totalPages = 250;

  Future<List<Media>> getPageData(bool animemanga) async {
    if(!animemanga){
      try {
        final result = await client.query(
          _animeQuery, // Use the static query string
          variables: {'page': _currentPage, 'perPage': _perPage},
        );
        //print(result);
        if (result.hasException) {
          throw Exception("Error cogiendo los datos");
        }

        final MediaModel animeData =
        MediaModel.fromJson(result.data?['Page'] ?? {});
        _totalPages = animeData.pageInfo.total;
        _animeList.addAll(animeData.media);
        //print(_currentPage);
        //print(_animeList[0].romajiTitle);
        return _animeList;
      } catch (e) {
        throw Exception("Error cogiendo los datos");
      }
    }
      try {
        final result = await client.query(
          _mangaQuery, // Use the static query string
          variables: {'page': _currentPage, 'perPage': _perPage},
        );
        //print(result);
        if (result.hasException) {
          throw Exception("Error cogiendo los datos");
        }

        final MediaModel animeData =
        MediaModel.fromJson(result.data?['Page'] ?? {});
        _totalPages = animeData.pageInfo.total;
        _animeList.addAll(animeData.media);
        //print(_currentPage);
        //print(_animeList[0].romajiTitle);
        return _animeList;
      } catch (e) {
        throw Exception("Error cogiendo los datos");
      }


  }

  Future<List<Media>> getPageSearchData(String search) async {
    try {
      final result = await client.query(
        _animeSearchQuery, // Use the static query string
        variables: {'page': _currentPage, 'perPage': _perPage, 'search': search},
      );
      //print(result);
      if (result.hasException) {
        throw Exception("Error cogiendo los datos");
      }

      final MediaModel animeData =
      MediaModel.fromJson(result.data?['Page'] ?? {});
      _totalPages = animeData.pageInfo.total;
      _animeList.addAll(animeData.media);
      //print(_currentPage);
      //print(_animeList[0].romajiTitle);
      return _animeList;
    } catch (e) {
      throw Exception("Error cogiendo los datos");
    }

  }

  Future<List<Media>?> fetchNextPage(bool afterBefore) async {
    try{
      if(afterBefore){
        if (_currentPage < _totalPages) {
          _animeList=[];
          _currentPage++;
          return await getPageData(false);
        }
      }else{
        if (_currentPage > 1) {
          _animeList=[];
          _currentPage--;
          return await getPageData(false);
        }
      }
    } catch (e) {
      throw Exception("Error cogiendo los datos de la siguiente pagina");
    }
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
      //print(result);
      if (result.hasException) {
        throw Exception("Error cogiendo los datos");
      }

      final MangaModel animeData =
      MangaModel.fromJson(result.data?['Page'] ?? {});
      _totalPages = animeData.pageInfo.total;
      manga.addAll(animeData.media);
      //print(_currentPage);
      //print(_animeList[0].romajiTitle);
      print('patata');
      print(manga[0]);
      return manga;
    } catch (e) {
      throw Exception("Error cogiendo los datos");
    }

  }

  Future<List<Anime>> getIdAnime() async {
    try {
      SharedPreferences preferences= await SharedPreferences.getInstance();
      int? id=await preferences.getInt("idMedia") ?? 1;

      print(id);
      await Future.delayed(Duration(seconds: 1));

      final result = await client.query(
        idAnimeSearchQuery, // Use the static query string
        variables: {'id': id},
      );
      //print(result);
      if (result.hasException) {
        throw Exception("Error cogiendo los datos");
      }

      final AnimeModel animeData =
      AnimeModel.fromJson(result.data?['Page'] ?? {});
      _totalPages = animeData.pageInfo.total;
      anime.addAll(animeData.media);
      //print(_currentPage);
      //print(_animeList[0].romajiTitle);
      print('patata');
      print(anime[0]);
      return anime;
    } catch (e) {
      throw Exception("Error cogiendo los datos");
    }
  }

  Future<List<Media>> getMyMedia(List<int> medias) async {
      try {
        final result = await client.query(
          myMediaQuery, // Use the static query string
          variables: {'page': _currentPage, 'perPage': _perPage, 'id_in': medias},
        );
        //print(result);
        if (result.hasException) {
          throw Exception("Error cogiendo los datos");
        }

        final MediaModel animeData =
        MediaModel.fromJson(result.data?['Page'] ?? {});
        _totalPages = animeData.pageInfo.total;
        _animeList.addAll(animeData.media);
        //print(_currentPage);
        //print(_animeList[0].romajiTitle);
        return _animeList;
      } catch (e) {
        throw Exception("Error cogiendo los datos");
      }
    }

}
