import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_movie_app/data/model/user_profile_model.dart';
import 'package:flutter_movie_app/presentation/view_model/user_profile_view_model.dart';
import 'package:flutter_movie_app/presentation/widget/warning_alert_dialog.dart';
import 'package:flutter_movie_app/utils/colors.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileAccountScreen extends StatefulWidget {
  ProfileAccountScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ProfileAccountScreen> createState() => _ProfileAccountScreenState();
}

class _ProfileAccountScreenState extends State<ProfileAccountScreen> {
  String strLatLong = 'Belum Mendapatkan Lokasi anda';
  String strAlamat = 'Mencari lokasi...';
  bool loading = false;
  bool isMockLocationDetected = false; // Menyimpan status mock location
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  XFile? _image;

  // Mendapatkan posisi geolokasi
  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    // location service not enabled, don't continue
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location service Not Enabled');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission denied');
      }
    }

    // permission denied forever
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permission denied forever, we cannot access',
      );
    }
    // continue accessing the position of device
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // Mengecek apakah lokasi menggunakan Mock Location
  Future<bool> _isMockLocation(Position position) async {
    return position.isMocked;
  }

  // getAddress
  Future<void> getAddressFromLongLat(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    Placemark place = placemarks[0];
    setState(() {
      strAlamat = '${place.street}, ${place.subLocality}, ${place.locality}, '
          '${place.postalCode}, ${place.country}';
      _alamatController.text = strAlamat;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final provider = Provider.of<UserProfileViewModel>(context, listen: false);

    // Memuat data dari database lokal
    await provider.loadUserProfile(user.uid);

    // Set data yang ditemukan ke input field
    final profile = provider.userProfile;
    if (profile != null) {
      _setUserData(
          profile.name, profile.email, profile.alamat!, profile.photoURL);
    }
  }

  void _setUserData(
      String name, String email, String alamat, String? photoURL) {
    setState(() {
      _nameController.text = name;
      _emailController.text = email;
      _alamatController.text = alamat;
      if (photoURL != null) {
        _image = XFile(photoURL);
      } else {
        _image = null;
      }
    });
  }

  Future<void> _updateProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final provider = Provider.of<UserProfileViewModel>(context, listen: false);

    try {
      // Simpan ke Firestore dan database lokal
      final updatedProfile = UserProfile(
        uid: user.uid,
        name: _nameController.text,
        email: _emailController.text,
        alamat: _alamatController.text,
        photoURL: _image?.path ?? user.photoURL,
      );

      await provider.updateUserProfile(updatedProfile);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Profile updated successfully'),
            backgroundColor: Colors.green, // Menentukan warna latar belakang
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating profile: $e'),
            backgroundColor: Colors.red[200],
          ),
        );
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      _image = await _picker.pickImage(source: source);
      if (_image != null) {
        setState(() {
          _image = _image;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  void _showImagePickerModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                context.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                context.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Consumer<UserProfileViewModel>(
      builder: (context, provider, child) {
        final userProfile = provider.userProfile;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    GestureDetector(
                      onTap: _showImagePickerModal,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50.0),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const CircleAvatar(
                              radius: 63,
                              backgroundColor: AppColors.primary,
                            ),
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.grey[300],
                              backgroundImage: _image != null
                                  ? FileImage(File(_image!.path))
                                  : (userProfile?.photoURL != null
                                      ? NetworkImage(userProfile!.photoURL!)
                                      : null),
                              child: _image == null &&
                                      (userProfile?.photoURL == null)
                                  ? const Icon(Icons.person,
                                      size: 50, color: Colors.grey)
                                  : null,
                            ),
                            const Positioned(
                              bottom: 0,
                              right: 0,
                              child: CircleAvatar(
                                radius: 18,
                                backgroundColor: AppColors.primary,
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(
                        RegExp(r'\s')), // Menolak spasi
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _alamatController,
                  maxLines: 3, // Mengatur tinggi TextField agar lebih besar
                  decoration: InputDecoration(
                    labelText: 'Alamat',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      splashColor: Colors.blue, // Splash berwarna biru
                      icon: const Icon(
                        size: 30,
                        Icons.my_location_outlined,
                        color: AppColors.primary,
                      ),
                      onPressed: () async {
                        // Ambil lokasi dan cek mock location
                        Position position = await _getGeoLocationPosition();
                        bool isMock = await _isMockLocation(position);
                        setState(() {
                          isMockLocationDetected =
                              isMock; // Update status mock location
                        });

                        if (isMock) {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            // Tidak bisa menutup dengan men-tap di luar dialog
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Warning'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AnimatedWarningIcon(),
                                    // Menambahkan animasi ikon warning
                                    const SizedBox(height: 10),
                                    const Text(
                                        'Mock location detected!\nplease turn it off',
                                        textAlign: TextAlign.center),
                                  ],
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      // Menutup dialog dan mereload halaman
                                      context.pop(context);
                                      setState(() {
                                        // Opsional: Anda bisa menambahkan kode untuk melakukan refresh halaman di sini.
                                      });
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }

                        setState(() {
                          strLatLong =
                              '${position.latitude}, ${position.longitude}';
                        });

                        await getAddressFromLongLat(position);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Tombol Update Profile dengan kondisi disable jika mock location terdeteksi
                ElevatedButton(
                  onPressed: isMockLocationDetected || provider.isLoading
                      ? null
                      : _updateProfile,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: AppColors.primary,
                    minimumSize: const Size(double.infinity, 45),
                  ),
                  child: provider.isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Update Profile'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    context.push('/changepassword');
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: AppColors.primary,
                    minimumSize: const Size(double.infinity, 45),
                  ),
                  child: const Text('Change Password'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _buildProfileHeader(),
    );
  }
}
