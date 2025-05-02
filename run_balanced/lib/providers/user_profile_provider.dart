import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProfileProvider with ChangeNotifier {
  String _imagePath = '';
  String _firstName = '';
  String _lastName = '';
  bool _isLoaded = false;

  String get imagePath => _imagePath;
  String get firstName => _firstName;
  String get lastName => _lastName;
  bool get isLoaded => _isLoaded;

  Future<void> loadUserProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      final doc =
          await FirebaseFirestore.instance.collection('Users').doc(uid).get();
      final data = doc.data();
      if (data != null) {
        _firstName = data['firstName'] ?? '';
        _lastName = data['lastName'] ?? '';
        _imagePath = data['imageUrl'] ?? '';
        _isLoaded = true;
        notifyListeners();
      }
    } catch (e) {
      print("Failed to load user profile: $e");
    }
  }

  void updateProfile({
    required String firstName,
    required String lastName,
    required String imagePath,
  }) {
    _firstName = firstName;
    _lastName = lastName;
    _imagePath = imagePath;
    notifyListeners();
  }
}
