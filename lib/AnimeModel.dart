class AnimeModel {
  final PageInfo pageInfo;
  final List<Media> media;

  AnimeModel({required this.pageInfo, required this.media});

  factory AnimeModel.fromJson(Map<String, dynamic> json) {
    return AnimeModel(
      pageInfo: PageInfo.fromJson(json['pageInfo']),
      media: Media.fromListJson(json['media']),
    );
  }
}

class PageInfo {
  PageInfo({
    required this.total,
    required this.currentPage,
    required this.lastPage,
    required this.hasNextPage,
    required this.perPage,
  });

  factory PageInfo.fromJson(Map<String, dynamic> json) {
    return PageInfo(
      total: json['total'] as int,
      currentPage: json['currentPage'] as int,
      lastPage: json['lastPage'] as int,
      hasNextPage: json['hasNextPage'] as bool,
      perPage: json['perPage'] as int,
    );
  }

  final int total;
  final int currentPage;
  final int lastPage;
  final bool hasNextPage;
  final int perPage;
}

class Media {
  Media({
    required this.id,
    this.coverImageUrl,
    this.englishTitle,
    this.romajiTitle,
    this.description,
  });

  static List<Media> fromListJson(List<Object?> jsonList) {
    return jsonList
        .map((item) => Media.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      id: json['id'] as int,
      coverImageUrl: json['coverImage']['extraLarge'] as String?,
      englishTitle: json['title']['english'] as String?,
      romajiTitle: json['title']['romaji'] as String?,
      description: json['description'] as String?,
    );
  }

  final int id;
  final String? coverImageUrl;
  final String? englishTitle;
  final String? romajiTitle;
  final String? description;
}