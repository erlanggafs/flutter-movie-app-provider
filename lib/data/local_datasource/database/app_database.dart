import 'dart:async';

import 'package:floor/floor.dart';
import 'package:flutter_movie_app/data/local_datasource/DAO/movie_dao.dart';
import 'package:flutter_movie_app/data/local_datasource/DAO/user_dao.dart';
import 'package:flutter_movie_app/data/model/movie_model.dart';
import 'package:flutter_movie_app/data/model/user_profile_model.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'app_database.g.dart';

//membuat database local sqlite
@Database(version: 2, entities: [Movie, UserProfile])
abstract class AppDatabase extends FloorDatabase {
  static var instance;

  MovieDao get movieDao;
  UserProfileDao get userProfileDao; //membuat atribut dari data dao
}
