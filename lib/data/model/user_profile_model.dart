import 'package:floor/floor.dart';

@Entity(tableName: 'UserProfile')
class UserProfile {
  @primaryKey
  final String uid;
  final String name;
  final String email;
  final String? alamat;
  final String? photoURL;

  UserProfile({
    required this.uid,
    required this.name,
    required this.email,
    this.alamat,
    this.photoURL,
  });
}
