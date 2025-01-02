// models/user_model.dart
class UserModel {
  final String name;
  final String email;
  final String password;
  final String? alamat;

  UserModel(
      {required this.name,
      required this.email,
      required this.password,
      this.alamat});
}
