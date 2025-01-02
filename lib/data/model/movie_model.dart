import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';

import 'genre_map.dart';

// Type converter for List<int> to String
class IntListConverter extends TypeConverter<List<int>, String> {
  @override
  List<int> decode(String databaseValue) {
    if (databaseValue.isEmpty) return [];
    return databaseValue.split(',').map((e) => int.parse(e)).toList();
  }

  @override
  String encode(List<int> value) {
    return value.join(',');
  }
}

@JsonSerializable()
@Entity(tableName: 'Movie')
class Movie {
  @PrimaryKey(autoGenerate: true)
  final int id;
  final String title;
  final String originalName;
  final String backDropPath;
  final String overview;
  final double popularity;
  final String posterPath;
  final String originalLanguage;
  final String releaseDate;
  final String firstAirDate;
  final double voteAverage;
  final int voteCount;
  bool isSaved;
  final String category;

  @TypeConverters([IntListConverter])
  final String genreIdsStr; // Store as string in database

  @ignore
  List<int> get genreIds => IntListConverter().decode(genreIdsStr);

  Movie({
    required this.id,
    required this.title,
    required this.originalName,
    required this.backDropPath,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.originalLanguage,
    required this.releaseDate,
    required this.firstAirDate,
    required this.voteAverage,
    required this.voteCount,
    this.isSaved = false,
    required this.category,
    required List<int> genreIds,
  }) : genreIdsStr = IntListConverter().encode(genreIds);

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'] as int,
      title: map['title'] as String? ?? map['original_name'] as String? ?? '',
      originalName:
          map['original_name'] as String? ?? map['title'] as String? ?? '',
      backDropPath: map['backdrop_path'] as String? ?? '',
      overview: map['overview'] as String? ?? '',
      popularity: (map['popularity'] as num?)?.toDouble() ?? 0.0,
      posterPath: map['poster_path'] as String? ?? '',
      originalLanguage: map['original_language'] as String? ?? '',
      releaseDate: map['release_date'] as String? ?? '',
      firstAirDate: map['first_air_date'] as String? ?? '',
      voteAverage: (map['vote_average'] as num?)?.toDouble() ?? 0.0,
      voteCount: map['vote_count'] as int? ?? 0,
      isSaved: map['isSaved'] ?? false,
      genreIds: List<int>.from(map['genre_ids'] as List<dynamic>? ?? []),
      category: map['category'] as String? ?? 'Unknown',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'original_name': originalName,
      'backdrop_path': backDropPath,
      'overview': overview,
      'popularity': popularity,
      'poster_path': posterPath,
      'original_language': originalLanguage,
      'release_date': releaseDate,
      'first_air_date': firstAirDate,
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'isSaved': isSaved,
      'genre_ids': genreIdsStr,
      'category': category, // Store the encoded genreIds string
    };
  }

  Movie copyWith({
    int? id,
    String? title,
    String? originalName,
    String? backDropPath,
    String? overview,
    double? popularity,
    String? posterPath,
    String? originalLanguage,
    String? releaseDate,
    String? firstAirDate,
    double? voteAverage,
    int? voteCount,
    String? category,
    String? genreIdsStr,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      originalName: originalName ?? this.originalName,
      backDropPath: backDropPath ?? this.backDropPath,
      overview: overview ?? this.overview,
      popularity: popularity ?? this.popularity,
      posterPath: posterPath ?? this.posterPath,
      originalLanguage: originalLanguage ?? this.originalLanguage,
      releaseDate: releaseDate ?? this.releaseDate,
      firstAirDate: firstAirDate ?? this.firstAirDate,
      voteAverage: voteAverage ?? this.voteAverage,
      voteCount: voteCount ?? this.voteCount,
      category: category ?? this.category,
      genreIds: genreIds,
    );
  }

  List<String> get genreNames {
    return genreIds.map((id) => genreMap[id] ?? "Unknown").toList();
  }
}
