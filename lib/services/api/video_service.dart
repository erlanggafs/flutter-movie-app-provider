import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';

part 'video_service.g.dart';

final String apiKey = dotenv.env['API_KEY'] ?? '';

@JsonSerializable()
class Video {
  final String id;
  final String name;

  Video({required this.id, required this.name});

  factory Video.fromJson(Map<String, dynamic> json) => _$VideoFromJson(json);
  Map<String, dynamic> toJson() => _$VideoToJson(this);
}

@RestApi(baseUrl: "https://api.themoviedb.org/3")
abstract class VideoApiService {
  factory VideoApiService(Dio dio, {String baseUrl}) = _VideoApiService;

  @GET("/movie/{movieId}/videos")
  Future<Video> fetchVideo(
    @Path("movieId") String movieId,
    @Query("language") String language,
    @Query("api_key") String apiKey,
  );
}

Future<void> main() async {
  final dio = Dio();
  final videoApiService = VideoApiService(dio);

  try {
    final video = await videoApiService.fetchVideo("movieId", "en-US", apiKey);
    print("Video ID: ${video.id}, Name: ${video.name}");
  } catch (e) {
    print("Failed to load video: $e");
  }
}
