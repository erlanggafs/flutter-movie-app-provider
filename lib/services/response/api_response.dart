// // movie_response.dart
// import 'package:flutter_movie_app/data/model/movie_model.dart';
// import 'package:json_annotation/json_annotation.dart';
//
// part 'api_response.g.dart';
//
// @JsonSerializable()
// class MovieResponse {
//   @JsonKey(name: 'page')
//   final int page;
//
//   @JsonKey(name: 'results')
//   final List<Movie> movies;
//
//   @JsonKey(name: 'total_pages')
//   final int totalPages;
//
//   @JsonKey(name: 'total_results')
//   final int totalResults;
//
//   MovieResponse({
//     required this.page,
//     required this.movies,
//     required this.totalPages,
//     required this.totalResults,
//   });
//
//   factory MovieResponse.fromJson(Map<String, dynamic> json) =>
//       _$MovieResponseFromJson(json);
//
//   Map<String, dynamic> toJson() => _$MovieResponseToJson(this);
// }
