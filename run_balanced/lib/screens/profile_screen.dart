import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart'; // Importing intl package for formatting the date
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:run_balanced/providers/user_profile_provider.dart';
import 'package:run_balanced/main.dart';
import 'package:run_balanced/theme/theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final ageController = TextEditingController();
  final weightController = TextEditingController();
  final heightController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
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

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    ageController.dispose();
    weightController.dispose();
    heightController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
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
          weightController.text = (data['weight'] ?? '').toString();
          heightController.text = (data['height'] ?? '').toString();
          _imageName = data['imageName'] ?? '';
          _localImagePath = data['imageUrl'] ?? '';
          if (_localImagePath != null && _localImagePath!.isNotEmpty) {
            _localImage = File(_localImagePath!);
          }
          _lastEdited = editedFormatted;
        });
      }
    } catch (e) {
      debugPrint("Error loading profile: $e");
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
      final userDocRef = FirebaseFirestore.instance
          .collection('Users')
          .doc(uid);
      final docSnapshot = await userDocRef.get();
      final now = DateTime.now();

      final isNewUser = !docSnapshot.exists;

      // Update Firestore user profile
      await userDocRef.set({
        'firstName': firstNameController.text.trim(),
        'lastName': lastNameController.text.trim(),
        'age': (double.tryParse(ageController.text.trim()) ?? 0).toInt(),
        'gender': gender,
        'weight': double.tryParse(weightController.text.trim()) ?? 0.0,
        'height': double.tryParse(heightController.text.trim()) ?? 0.0,
        'imageUrl': _localImagePath,
        'imageName': _imageName,
        if (isNewUser)
          'createdAt': Timestamp.fromDate(now)
        else
          'editedAt': Timestamp.fromDate(now),
      }, SetOptions(merge: true));

      // Try to update password if user entered one
      final newPassword = newPasswordController.text.trim();
      if (newPassword.isNotEmpty) {
        try {
          await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Password updated successfully')),
          );
        } catch (e) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Password update failed: $e')));
        }
      }

      setState(() {
        _lastEdited = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
      });

      // Update provider
      Provider.of<UserProfileProvider>(context, listen: false).updateProfile(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        age: (double.tryParse(ageController.text.trim()) ?? 0).toInt(),
        weight: double.tryParse(weightController.text.trim()) ?? 0.0,
        height: double.tryParse(heightController.text.trim()) ?? 0.0,
        imagePath: _localImagePath ?? '',
      );

      final message = isNewUser ? 'Profile created' : 'Profile updated';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));

      if (isNewUser) {
        final message = isNewUser ? 'Profile created' : 'Profile updated';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const AuthWrapper()),
          (route) => false,
        );
        // Navigate to home screen after profile creation
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => HomeScreen()),
        // );
      }
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
                      SizedBox(height: AppSpacing.md),
                      TextFormField(
                        controller: lastNameController,
                        decoration: InputDecoration(labelText: 'Last Name'),
                        validator:
                            (value) => value!.isEmpty ? 'Required' : null,
                      ),
                      SizedBox(height: AppSpacing.md),
                      TextFormField(
                        controller: ageController,
                        decoration: InputDecoration(labelText: 'Age'),
                        keyboardType: TextInputType.number,
                        validator:
                            (value) => value!.isEmpty ? 'Required' : null,
                      ),
                      SizedBox(height: AppSpacing.md),
                      TextFormField(
                        controller: weightController,
                        decoration: InputDecoration(labelText: 'Weight (kg)'),
                        keyboardType: TextInputType.number,
                        validator:
                            (value) => value!.isEmpty ? 'Required' : null,
                      ),
                      SizedBox(height: AppSpacing.md),
                      TextFormField(
                        controller: heightController,
                        decoration: InputDecoration(labelText: 'Height (cm)'),
                        keyboardType: TextInputType.number,
                        validator:
                            (value) => value!.isEmpty ? 'Required' : null,
                      ),
                      SizedBox(height: AppSpacing.md),
                      TextFormField(
                        controller: newPasswordController,
                        decoration: InputDecoration(labelText: 'New Password'),
                        obscureText: true,
                        validator: (value) {
                          if (value != null &&
                              value.isNotEmpty &&
                              value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: AppSpacing.md),
                      TextFormField(
                        controller: confirmPasswordController,
                        decoration: InputDecoration(
                          labelText: 'Confirm New Password',
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (newPasswordController.text.isNotEmpty &&
                              value != newPasswordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: AppSpacing.md),
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
