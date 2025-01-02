class Video {
  final int id;
  final List<Result> results;

  Video({
    required this.id,
    required this.results,
  });

  // Factory constructor untuk membuat objek Video dari JSON
  factory Video.fromJson(Map<String, dynamic> json) {
    var list = json['results'] as List;
    List<Result> resultsList = list.map((i) => Result.fromJson(i)).toList();

    return Video(
      id: json['id'],
      results: resultsList,
    );
  }
}

class Result {
  final String iso6391;
  final String iso31661;
  final String name;
  final String key;
  final String site;
  final int size;
  final String type;
  final bool official;
  final String publishedAt;
  final String id;

  Result({
    required this.iso6391,
    required this.iso31661,
    required this.name,
    required this.key,
    required this.site,
    required this.size,
    required this.type,
    required this.official,
    required this.publishedAt,
    required this.id,
  });

  // Factory constructor untuk membuat objek Result dari JSON
  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      iso6391: json['iso_639_1'],
      iso31661: json['iso_3166_1'],
      name: json['name'],
      key: json['key'],
      site: json['site'],
      size: json['size'],
      type: json['type'],
      official: json['official'],
      publishedAt: json['published_at'],
      id: json['id'],
    );
  }
}
