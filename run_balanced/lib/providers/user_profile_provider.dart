import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProfileProvider with ChangeNotifier {
  String _imagePath = '';
  String _firstName = '';
  String _lastName = '';
  double _age = 0.0;
  double _weight = 0.0;
  double _height = 0.0;
  bool _isLoaded = false;

  String get imagePath => _imagePath;
  String get firstName => _firstName;
  String get lastName => _lastName;
  double get age => _age;
  double get weight => _weight;
  double get height => _height;
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
        _age = (data['age'] ?? 0).toDouble();
        _weight = (data['weight'] ?? 0).toDouble();
        _height = (data['height'] ?? 0).toDouble();
        _isLoaded = true;
        notifyListeners();
      }
    } catch (e) {
      print("Failed to load user profile: $e");
    }
  }

  Future<void> updateProfile({
    String? firstName,
    String? lastName,
    double? age,
    double? weight,
    double? height,
    String? imagePath,
  }) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    _firstName = firstName ?? _firstName;
    _lastName = lastName ?? _lastName;
    _age = age ?? _age;
    _weight = weight ?? _weight;
    _height = height ?? _height;
    _imagePath = imagePath ?? _imagePath;

    notifyListeners();

    final Map<String, dynamic> dataToUpdate = {
      'firstName': _firstName,
      'lastName': _lastName,
      'age': _age,
      'weight': _weight,
      'height': _height,
      'imageUrl': _imagePath,
    };

    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .set(dataToUpdate, SetOptions(merge: true));
    } catch (e) {
      print("Failed to update user profile: $e");
    }
  }
}
