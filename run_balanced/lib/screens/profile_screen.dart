import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart'; // Importing intl package for formatting the date
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:run_balanced/providers/user_profile_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final ageController = TextEditingController();
  String gender = 'Male';
  bool _isLoading = true;
  File? _localImage;
  String? _localImagePath;
  String? _imageName; // To store the name of the selected image
  String? _lastEdited; // To store the formatted last edited time

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  // Load user profile from Firestore and local storage
  Future<void> _loadUserProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      final doc =
          await FirebaseFirestore.instance.collection('Users').doc(uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        final editedAtTimestamp = data['editedAt'] as Timestamp?;
        final editedFormatted =
            editedAtTimestamp != null
                ? DateFormat(
                  'yyyy-MM-dd HH:mm:ss',
                ).format(editedAtTimestamp.toDate())
                : null;

        setState(() {
          firstNameController.text = data['firstName'] ?? '';
          lastNameController.text = data['lastName'] ?? '';
          ageController.text = (data['age'] ?? '').toString();
          gender = data['gender'] ?? 'Male';
          _imageName = data['imageName'] ?? '';
          _localImagePath = data['imageUrl'] ?? '';
          if (_localImagePath != null && _localImagePath!.isNotEmpty) {
            _localImage = File(_localImagePath!);
          }
          _lastEdited = editedFormatted;
        });
      }
    } catch (e) {
      print("Error loading profile: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Pick and save the new image to local storage
  Future<void> _pickAndSaveImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final dir = await getApplicationDocumentsDirectory();
      final savedImage = await File(
        picked.path,
      ).copy('${dir.path}/${picked.name}');

      // Update local image, image path, and image name
      setState(() {
        _localImage = savedImage;
        _localImagePath =
            savedImage.path; // Save the local path to use it later
        _imageName = picked.name; // Store the image name
      });
    }
  }

  // Submit user details to Firestore (including the image name)
  Future<void> submitDetails() async {
    if (_formKey.currentState!.validate()) {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final now = DateTime.now(); // exact timestamp used for both

      await FirebaseFirestore.instance.collection('Users').doc(uid).set({
        'firstName': firstNameController.text.trim(),
        'lastName': lastNameController.text.trim(),
        'age': int.parse(ageController.text.trim()),
        'gender': gender,
        'imageUrl': _localImagePath,
        'imageName': _imageName,
        'editedAt': Timestamp.fromDate(now), // save as Firestore timestamp
      }, SetOptions(merge: true));

      setState(() {
        _lastEdited = DateFormat(
          'yyyy-MM-dd HH:mm:ss',
        ).format(now); // update UI
      });

      final userProfileProvider = Provider.of<UserProfileProvider>(
        context,
        listen: false,
      );

      userProfileProvider.updateProfile(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        imagePath: _localImagePath ?? '',
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Profile updated')));
    }
  }

  // Show the image preview in a dialog
  void _showImagePreview() {
    if (_localImage != null) {
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(child: Image.file(_localImage!));
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      TextFormField(
                        controller: firstNameController,
                        decoration: InputDecoration(labelText: 'First Name'),
                        validator:
                            (value) => value!.isEmpty ? 'Required' : null,
                      ),
                      TextFormField(
                        controller: lastNameController,
                        decoration: InputDecoration(labelText: 'Last Name'),
                        validator:
                            (value) => value!.isEmpty ? 'Required' : null,
                      ),
                      TextFormField(
                        controller: ageController,
                        decoration: InputDecoration(labelText: 'Age'),
                        keyboardType: TextInputType.number,
                        validator:
                            (value) => value!.isEmpty ? 'Required' : null,
                      ),
                      DropdownButtonFormField<String>(
                        value: gender,
                        items:
                            ['Male', 'Female', 'Other']
                                .map(
                                  (g) => DropdownMenuItem(
                                    value: g,
                                    child: Text(g),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) => setState(() => gender = value!),
                        decoration: InputDecoration(labelText: 'Gender'),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            _imageName != null
                                ? _imageName!
                                : 'No image selected',
                            style: TextStyle(fontSize: 16),
                          ),
                          Spacer(),
                          if (_localImage != null)
                            TextButton(
                              onPressed: _showImagePreview,
                              child: Text('Preview Image'),
                            ),
                        ],
                      ),
                      TextButton(
                        onPressed: _pickAndSaveImage,
                        child: Text('Pick Profile Image'),
                      ),
                      SizedBox(height: 16),
                      if (_lastEdited != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            'Last edited: $_lastEdited',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: submitDetails,
                        child: Text('Save'),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
