import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movie_app/data/local_datasource/DAO/user_dao.dart';
import 'package:flutter_movie_app/data/model/user_profile_model.dart';

class UserProfileViewModel with ChangeNotifier {
  UserProfile? _userProfile;
  bool _isLoading = false;

  final UserProfileDao _userProfileDao; // Menyimpan instance UserProfileDao

  UserProfileViewModel(UserProfileDao userProfileDao)
      : _userProfileDao = userProfileDao;

  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;

  // Fungsi untuk memuat profil pengguna dari Firestore dan menyimpan ke database lokal
  Future<void> loadUserProfile(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Cek apakah ada data pengguna di database lokal terlebih dahulu
      _userProfile = await _userProfileDao.findUserById(userId);

      if (_userProfile == null) {
        // Jika tidak ada di database lokal, ambil dari Firestore
        final userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();

        if (userData.exists) {
          _userProfile = UserProfile(
            uid: userId,
            name: userData['name'] ?? '',
            email: userData['email'] ?? '',
            alamat: userData['alamat'] ?? '',
            photoURL: userData['photoURL'],
          );
        } else {
          // Jika profil belum ada di Firestore, kita gunakan data dari FirebaseAuth
          final currentUser = FirebaseAuth.instance.currentUser;
          _userProfile = UserProfile(
            uid: currentUser!.uid,
            name: currentUser.displayName ?? '',
            email: currentUser.email ?? '',
            alamat: '',
            photoURL: currentUser.photoURL,
          );
        }

        // Setelah mendapatkan data, simpan ke database lokal
        if (_userProfile != null) {
          await saveUserProfileToLocal(_userProfile!);
        }
      }
    } catch (error) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fungsi untuk menyimpan atau memperbarui profil pengguna di Firebase dan lokal
  Future<void> saveUserProfile(UserProfile userProfile) async {
    _userProfile = userProfile; // Update data di local state

    try {
      // Simpan ke Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userProfile.uid)
          .set({
        'name': userProfile.name,
        'email': userProfile.email,
        'alamat': userProfile.alamat,
        'photoURL': userProfile.photoURL,
      }, SetOptions(merge: true));

      // Simpan ke database lokal
      await saveUserProfileToLocal(userProfile);

      // Setelah berhasil menyimpan, update state
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  // Fungsi untuk memperbarui profil pengguna
  Future<void> updateUserProfile(UserProfile updatedProfile) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Memperbarui data di FirebaseAuth
      await FirebaseAuth.instance.currentUser
          ?.updateDisplayName(updatedProfile.name);

      // Memperbarui data di Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(updatedProfile.uid)
          .set({
        'name': updatedProfile.name,
        'email': updatedProfile.email,
        'alamat': updatedProfile.alamat,
        'photoURL': updatedProfile.photoURL,
      }, SetOptions(merge: true));

      // Memperbarui data di database lokal
      await updateUserProfileInLocal(updatedProfile);

      // Setelah berhasil memperbarui, kita simpan di state lokal
      _userProfile = updatedProfile;
    } catch (error) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Menyimpan profil pengguna ke database lokal
  Future<void> saveUserProfileToLocal(UserProfile newProfile) async {
    try {
      await _userProfileDao.insertUser(newProfile);
    } catch (error) {
      rethrow;
    }
  }

  // Memperbarui profil pengguna di database lokal
  Future<void> updateUserProfileInLocal(UserProfile updatedProfile) async {
    try {
      await _userProfileDao.updateUserProfile(updatedProfile);
    } catch (error) {
      rethrow;
    }
  }
}
