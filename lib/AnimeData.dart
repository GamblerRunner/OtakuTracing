import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

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
        media (search: $search){
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

  static const int _perPage = 20;
  List<Media> _animeList = [];
  var _currentPage = 1;
  var _totalPages = 250;

  Future<List<Media>> getPageData() async {
    try {
      final result = await client.query(
        _animeQuery, // Use the static query string
        variables: {'page': _currentPage, 'perPage': _perPage},
      );
      //print(result);
      if (result.hasException) {
        throw Exception("Error cogiendo los datos");
      }

      final AnimeModel animeData =
      AnimeModel.fromJson(result.data?['Page'] ?? {});
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

      final AnimeModel animeData =
      AnimeModel.fromJson(result.data?['Page'] ?? {});
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
          return await getPageData();
        }
      }else{
        if (_currentPage > 1) {
          _animeList=[];
          _currentPage--;
          return await getPageData();
        }
      }
    } catch (e) {
      throw Exception("Error cogiendo los datos de la siguiente pagina");
    }
  }
}
