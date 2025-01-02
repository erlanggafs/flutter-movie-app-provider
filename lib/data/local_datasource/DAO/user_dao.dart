import 'package:floor/floor.dart';
import 'package:flutter_movie_app/data/model/user_profile_model.dart';

@dao
abstract class UserProfileDao {
  @Query('SELECT * FROM UserProfile WHERE uid = :uid')
  Future<UserProfile?> findUserById(String uid);

  @insert
  Future<void> insertUser(UserProfile user);

  @update
  Future<void> updateUser(UserProfile user);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updateUserProfile(UserProfile user);

  @delete
  Future<void> deleteUser(UserProfile user);
}
