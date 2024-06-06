class MediaModel {
  final PageInfo pageInfo;
  final List<Media> media;

  MediaModel({required this.pageInfo, required this.media});

  factory MediaModel.fromJson(Map<String, dynamic> json) {
    return MediaModel(
      pageInfo: PageInfo.fromJson(json['pageInfo']),
      media: Media.fromListJson(json['media']),
    );
  }
}

class AnimeModel {
  final PageInfo pageInfo;
  final List<Anime> media;

  AnimeModel({required this.pageInfo, required this.media});

  factory AnimeModel.fromJson(Map<String, dynamic> json) {
    return AnimeModel(
      pageInfo: PageInfo.fromJson(json['pageInfo']),
      media: Anime.fromListJson(json['media']),
    );
  }
}

class MangaModel {
  final PageInfo pageInfo;
  final List<Manga> media;

  MangaModel({required this.pageInfo, required this.media});

  factory MangaModel.fromJson(Map<String, dynamic> json) {
    return MangaModel(
      pageInfo: PageInfo.fromJson(json['pageInfo']),
      media: Manga.fromListJson(json['media']),
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

class Anime {
  Anime({
    required this.id,
    this.coverImageUrl,
    this.romajiTitle,
    this.description,
    this.startDate,
    this.englishTitle,
    this.status,
    this.imageUrlTitle,
    this.episodes,
    this.mediaPlay,
    this.genres,
  });

  static List<Anime> fromListJson(List<Object?> jsonList) {
    return jsonList
        .map((item) => Anime.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
      id: json['id'] as int,
      coverImageUrl: json['coverImage']?['extraLarge'] as String? ?? 'https://cdn.pixabay.com/photo/2022/09/01/14/18/white-background-7425603_1280.jpg',
      imageUrlTitle: json['bannerImage'] as String? ?? 'https://cdn.pixabay.com/photo/2022/09/01/14/18/white-background-7425603_1280.jpg',
      englishTitle: json['title']?['english'] as String? ?? 'No title',
      romajiTitle: json['title']?['romaji'] as String? ?? 'No title',
      startDate: _parseStartDate(json['startDate']),
      description: json['description'] as String? ?? 'No description available',
      status: _statusFromString(json['status'] as String?),
      episodes: json['episodes'] as int? ?? 0,
      mediaPlay: json['trailer']?['id'] as String? ?? 'Mr7QgUfjdvQ',
      genres: (json['genres'] as List<dynamic>?)?.map((e) => e as String).toList() ?? ['Unknown Genre'],
    );
  }


  final int id;
  final String? coverImageUrl;
  final String? imageUrlTitle;
  final String? romajiTitle;
  final String? description;
  final String? englishTitle;
  final int? startDate;
  final Status? status;
  final int? episodes;
  final String? mediaPlay;
  final List<String>? genres;
  //final String? suggestions;

  // Método helper para convertir String a MangaStatus
  static Status? _statusFromString(String? status) {
    switch (status?.toLowerCase()) {
      case 'releasing':
        return Status.RELEASING;
      case 'finished':
        return Status.FINISHED;
      case 'hiatus':
        return Status.HIATUS;
      case 'cancelled':
        return Status.CANCELLED;
      case 'not_yet_released':
        return Status.NOT_YET_RELEASING;
      default:
        return null;
    }
  }
  static int? _parseStartDate(Map<String, dynamic>? startDate) {
    if (startDate == null) return null;
    final int year = startDate['year'] ?? 0;
    final int month = startDate['month'] ?? 0;
    final int day = startDate['day'] ?? 0;
    return year * 10000 + month * 100 + day;
  }
}

class Manga {
  Manga({
    required this.id,
    this.coverImageUrl,
    this.romajiTitle,
    this.description,
    this.startDate,
    this.englishTitle,
    this.status,
    this.imageUrlTitle,
    this.volumes,
    this.chapters,
    this.genres,
  });

  static List<Manga> fromListJson(List<Object?> jsonList) {
    return jsonList
        .map((item) => Manga.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  factory Manga.fromJson(Map<String, dynamic> json) {
    return Manga(
      id: json['id'] as int,
      coverImageUrl: json['coverImage']?['extraLarge'] as String? ?? 'https://cdn.pixabay.com/photo/2022/09/01/14/18/white-background-7425603_1280.jpg',
      imageUrlTitle: json['bannerImage'] as String? ?? 'https://cdn.pixabay.com/photo/2022/09/01/14/18/white-background-7425603_1280.jpg',
      englishTitle: json['title']?['english'] as String? ?? 'No title',
      romajiTitle: json['title']?['romaji'] as String? ?? 'No title',
      startDate: _parseStartDate(json['startDate']),
      description: json['description'] as String? ?? 'No description available',
      status: _statusFromString(json['status'] as String?),
      volumes: json['volumes'] as int? ?? 0,
      chapters: json['chapters'] as int? ?? 0,
      genres: (json['genres'] as List<dynamic>?)?.map((e) => e as String).toList() ?? ['Unknown Genre'],
    );
  }


  final int id;
  final String? coverImageUrl;
  final String? imageUrlTitle;
  final String? romajiTitle;
  final String? description;
  final String? englishTitle;
  final int? startDate;
  final Status? status;
  final int? volumes;
  final int? chapters;
  final List<String>? genres;
  //final String? suggestions;

  // Método helper para convertir String a MangaStatus
  static Status? _statusFromString(String? status) {
    switch (status?.toLowerCase()) {
      case 'releasing':
        return Status.RELEASING;
      case 'finished':
        return Status.FINISHED;
      case 'hiatus':
        return Status.HIATUS;
      case 'cancelled':
        return Status.CANCELLED;
      case 'not_yet_released':
        return Status.NOT_YET_RELEASING;
      default:
        return Status.HIATUS;
    }
  }
  static int? _parseStartDate(Map<String, dynamic>? startDate) {
    if (startDate == null) return null;
    final int year = startDate['year'] ?? 0;
    final int month = startDate['month'] ?? 0;
    final int day = startDate['day'] ?? 0;
    return year * 10000 + month * 100 + day;
  }
}

enum Status {
  RELEASING,
  FINISHED,
  HIATUS,
  CANCELLED,
  NOT_YET_RELEASING;
  String get status {
    switch (this) {
      case Status.RELEASING:
        return 'RELEASING';
      case Status.FINISHED:
        return 'FINISHED';
      case Status.HIATUS:
        return 'HIATUS';
      case Status.CANCELLED:
        return 'CANCELLED';
      case Status.NOT_YET_RELEASING:
        return 'NOT_YET_RELEASING';
      default:
        return '';
    }
  }
}

