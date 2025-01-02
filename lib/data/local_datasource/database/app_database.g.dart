// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  MovieDao? _movieDaoInstance;

  UserProfileDao? _userProfileDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 2,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Movie` (`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, `title` TEXT NOT NULL, `originalName` TEXT NOT NULL, `backDropPath` TEXT NOT NULL, `overview` TEXT NOT NULL, `popularity` REAL NOT NULL, `posterPath` TEXT NOT NULL, `originalLanguage` TEXT NOT NULL, `releaseDate` TEXT NOT NULL, `firstAirDate` TEXT NOT NULL, `voteAverage` REAL NOT NULL, `voteCount` INTEGER NOT NULL, `isSaved` INTEGER NOT NULL, `category` TEXT NOT NULL, `genreIdsStr` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `UserProfile` (`uid` TEXT NOT NULL, `name` TEXT NOT NULL, `email` TEXT NOT NULL, `alamat` TEXT, `photoURL` TEXT, PRIMARY KEY (`uid`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  MovieDao get movieDao {
    return _movieDaoInstance ??= _$MovieDao(database, changeListener);
  }

  @override
  UserProfileDao get userProfileDao {
    return _userProfileDaoInstance ??=
        _$UserProfileDao(database, changeListener);
  }
}

class _$MovieDao extends MovieDao {
  _$MovieDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _movieInsertionAdapter = InsertionAdapter(
            database,
            'Movie',
            (Movie item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'originalName': item.originalName,
                  'backDropPath': item.backDropPath,
                  'overview': item.overview,
                  'popularity': item.popularity,
                  'posterPath': item.posterPath,
                  'originalLanguage': item.originalLanguage,
                  'releaseDate': item.releaseDate,
                  'firstAirDate': item.firstAirDate,
                  'voteAverage': item.voteAverage,
                  'voteCount': item.voteCount,
                  'isSaved': item.isSaved ? 1 : 0,
                  'category': item.category,
                  'genreIdsStr': item.genreIdsStr
                }),
        _movieUpdateAdapter = UpdateAdapter(
            database,
            'Movie',
            ['id'],
            (Movie item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'originalName': item.originalName,
                  'backDropPath': item.backDropPath,
                  'overview': item.overview,
                  'popularity': item.popularity,
                  'posterPath': item.posterPath,
                  'originalLanguage': item.originalLanguage,
                  'releaseDate': item.releaseDate,
                  'firstAirDate': item.firstAirDate,
                  'voteAverage': item.voteAverage,
                  'voteCount': item.voteCount,
                  'isSaved': item.isSaved ? 1 : 0,
                  'category': item.category,
                  'genreIdsStr': item.genreIdsStr
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Movie> _movieInsertionAdapter;

  final UpdateAdapter<Movie> _movieUpdateAdapter;

  @override
  Future<List<Movie>> getAllMovie() async {
    return _queryAdapter.queryList('SELECT * FROM Movie',
        mapper: (Map<String, Object?> row) => Movie(
            id: row['id'] as int,
            title: row['title'] as String,
            originalName: row['originalName'] as String,
            backDropPath: row['backDropPath'] as String,
            overview: row['overview'] as String,
            popularity: row['popularity'] as double,
            posterPath: row['posterPath'] as String,
            originalLanguage: row['originalLanguage'] as String,
            releaseDate: row['releaseDate'] as String,
            firstAirDate: row['firstAirDate'] as String,
            voteAverage: row['voteAverage'] as double,
            voteCount: row['voteCount'] as int,
            isSaved: (row['isSaved'] as int) != 0,
            category: row['category'] as String,
            genreIds: []));
  }

  @override
  Future<List<Movie>> getMoviesByCategory(String category) async {
    return _queryAdapter.queryList('SELECT * FROM Movie WHERE category = ?1',
        mapper: (Map<String, Object?> row) => Movie(
            id: row['id'] as int,
            title: row['title'] as String,
            originalName: row['originalName'] as String,
            backDropPath: row['backDropPath'] as String,
            overview: row['overview'] as String,
            popularity: row['popularity'] as double,
            posterPath: row['posterPath'] as String,
            originalLanguage: row['originalLanguage'] as String,
            releaseDate: row['releaseDate'] as String,
            firstAirDate: row['firstAirDate'] as String,
            voteAverage: row['voteAverage'] as double,
            voteCount: row['voteCount'] as int,
            isSaved: (row['isSaved'] as int) != 0,
            category: row['category'] as String,
            genreIds: []),
        arguments: [category]);
  }

  @override
  Future<Movie?> getMovieByUniqueIdentifier(String title) async {
    return _queryAdapter.query('SELECT * FROM Movie WHERE title = ?1 LIMIT 1',
        mapper: (Map<String, Object?> row) => Movie(
            id: row['id'] as int,
            title: row['title'] as String,
            originalName: row['originalName'] as String,
            backDropPath: row['backDropPath'] as String,
            overview: row['overview'] as String,
            popularity: row['popularity'] as double,
            posterPath: row['posterPath'] as String,
            originalLanguage: row['originalLanguage'] as String,
            releaseDate: row['releaseDate'] as String,
            firstAirDate: row['firstAirDate'] as String,
            voteAverage: row['voteAverage'] as double,
            voteCount: row['voteCount'] as int,
            isSaved: (row['isSaved'] as int) != 0,
            category: row['category'] as String,
            genreIds: []),
        arguments: [title]);
  }

  @override
  Future<void> deleteAllMovie() async {
    await _queryAdapter.queryNoReturn('DELETE FROM Movie');
  }

  @override
  Future<List<Movie>> getSavedMovie() async {
    return _queryAdapter.queryList('SELECT * FROM Movie WHERE isSaved = 1',
        mapper: (Map<String, Object?> row) => Movie(
            id: row['id'] as int,
            title: row['title'] as String,
            originalName: row['originalName'] as String,
            backDropPath: row['backDropPath'] as String,
            overview: row['overview'] as String,
            popularity: row['popularity'] as double,
            posterPath: row['posterPath'] as String,
            originalLanguage: row['originalLanguage'] as String,
            releaseDate: row['releaseDate'] as String,
            firstAirDate: row['firstAirDate'] as String,
            voteAverage: row['voteAverage'] as double,
            voteCount: row['voteCount'] as int,
            isSaved: (row['isSaved'] as int) != 0,
            category: row['category'] as String,
            genreIds: []));
  }

  @override
  Future<void> insertAllMovie(Movie movie) async {
    await _movieInsertionAdapter.insert(movie, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateMovie(Movie movie) async {
    await _movieUpdateAdapter.update(movie, OnConflictStrategy.replace);
  }
}

class _$UserProfileDao extends UserProfileDao {
  _$UserProfileDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _userProfileInsertionAdapter = InsertionAdapter(
            database,
            'UserProfile',
            (UserProfile item) => <String, Object?>{
                  'uid': item.uid,
                  'name': item.name,
                  'email': item.email,
                  'alamat': item.alamat,
                  'photoURL': item.photoURL
                }),
        _userProfileUpdateAdapter = UpdateAdapter(
            database,
            'UserProfile',
            ['uid'],
            (UserProfile item) => <String, Object?>{
                  'uid': item.uid,
                  'name': item.name,
                  'email': item.email,
                  'alamat': item.alamat,
                  'photoURL': item.photoURL
                }),
        _userProfileDeletionAdapter = DeletionAdapter(
            database,
            'UserProfile',
            ['uid'],
            (UserProfile item) => <String, Object?>{
                  'uid': item.uid,
                  'name': item.name,
                  'email': item.email,
                  'alamat': item.alamat,
                  'photoURL': item.photoURL
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<UserProfile> _userProfileInsertionAdapter;

  final UpdateAdapter<UserProfile> _userProfileUpdateAdapter;

  final DeletionAdapter<UserProfile> _userProfileDeletionAdapter;

  @override
  Future<UserProfile?> findUserById(String uid) async {
    return _queryAdapter.query('SELECT * FROM UserProfile WHERE uid = ?1',
        mapper: (Map<String, Object?> row) => UserProfile(
            uid: row['uid'] as String,
            name: row['name'] as String,
            email: row['email'] as String,
            alamat: row['alamat'] as String?,
            photoURL: row['photoURL'] as String?),
        arguments: [uid]);
  }

  @override
  Future<void> insertUser(UserProfile user) async {
    await _userProfileInsertionAdapter.insert(user, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateUser(UserProfile user) async {
    await _userProfileUpdateAdapter.update(user, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateUserProfile(UserProfile user) async {
    await _userProfileUpdateAdapter.update(user, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteUser(UserProfile user) async {
    await _userProfileDeletionAdapter.delete(user);
  }
}

// ignore_for_file: unused_element
final _intListConverter = IntListConverter();
