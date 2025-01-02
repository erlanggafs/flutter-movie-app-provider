import 'package:floor/floor.dart';

import '../../model/movie_model.dart';

@dao
abstract class MovieDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAllMovie(Movie movie);

  @Query('SELECT * FROM Movie')
  Future<List<Movie>> getAllMovie();

  @Query('SELECT * FROM Movie WHERE category = :category')
  Future<List<Movie>> getMoviesByCategory(String category);

  @Query('SELECT * FROM Movie WHERE title = :title LIMIT 1 ')
  Future<Movie?> getMovieByUniqueIdentifier(String title);

  @Query('DELETE FROM Movie') // Perbaiki query DELETE
  Future<void> deleteAllMovie();

  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updateMovie(Movie movie);

  @Query(
      'SELECT * FROM Movie WHERE isSaved = 1') // Pastikan isLiked adalah boolean
  Future<List<Movie>> getSavedMovie();
}
