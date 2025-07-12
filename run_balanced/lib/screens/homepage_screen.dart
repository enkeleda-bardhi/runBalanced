import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:run_balanced/providers/user_profile_provider.dart';
import 'package:run_balanced/theme/theme_provider.dart';
import 'training_screen.dart';
import 'programs_screen.dart';
import 'recap_screen.dart';
import 'connection_screen.dart';
import 'challenges_screen.dart';
import 'profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// il contenuto visualizzato (pagina selezionata) cambia dinamicamente
class HomeScreen extends StatefulWidget {
  final int initialIndex;

  const HomeScreen({super.key, this.initialIndex = 0}); // default to 0

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// tiene traccia della schermata corrente. Inizialmente è 0 → la prima pagina (“Allenamento”)
class _HomeScreenState extends State<HomeScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  final List<Widget> _pages = [
    TrainingScreen(),
    ProgramsScreen(),
    RecapScreen(),
    ConnectionsScreen(),
    ChallengesScreen(),
    // SettingsScreen(),
    ProfileScreen(),
  ];

  final List<String> _titles = [
    'Training',
    'Programs',
    'Recap',
    'Connections',
    'Challenges',
    // 'Settings',
    'Profile',
  ];

  Future<Map<String, String>> getUserDetails(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('Users').doc(uid).get();

      if (userDoc.exists) {
        var data = userDoc.data() as Map<String, dynamic>;
        return {
          'firstName': data['firstName'] ?? '',
          'lastName': data['lastName'] ?? '',
          'imageUrl': data['imageUrl'] ?? '',
        };
      }
    } catch (e) {
      debugPrint("Error fetching user details: $e");
    }
    return {'firstName': '', 'lastName': '', 'imageUrl': ''};
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titles[_selectedIndex],
          style: theme.appBarTheme.titleTextStyle,
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
        iconTheme: theme.appBarTheme.iconTheme,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: theme.appBarTheme.backgroundColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'RunBalance',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.appBarTheme.foregroundColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  if (user != null)
                    FutureBuilder<Map<String, String>>(
                      future: getUserDetails(user.uid),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }

                        if (snapshot.hasData) {
                          final userProfile = Provider.of<UserProfileProvider>(
                            context,
                          );

                          return Row(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundImage:
                                    userProfile.imagePath.isNotEmpty
                                        ? FileImage(File(userProfile.imagePath))
                                        : null,
                                child:
                                    userProfile.imagePath.isEmpty
                                        ? Icon(Icons.person, size: 30)
                                        : null,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "${userProfile.firstName} ${userProfile.lastName}",
                                style: theme.appBarTheme.titleTextStyle,
                              ),
                            ],
                          );
                        } else {
                          return Text('Loading...');
                        }
                      },
                    ),
                ],
              ),
            ),

            for (int i = 0; i < _titles.length; i++)
              ListTile(
                leading: _iconForIndex(i),
                title: Text(_titles[i]),
                selected: _selectedIndex == i,
                selectedTileColor: theme.listTileTheme.selectedTileColor,
                selectedColor: theme.listTileTheme.selectedColor,
                onTap: () {
                  setState(() {
                    _selectedIndex = i;
                    Navigator.pop(context);
                  });
                },
              ),

            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Sign Out'),
              onTap: () async {
                Navigator.pop(context);
                await FirebaseAuth.instance.signOut();
              },
            ),

            Divider(),
            ListTile(
              leading: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
              title: Text('Switch Theme'),
              onTap: () {
                Provider.of<ThemeProvider>(
                  context,
                  listen: false,
                ).toggleTheme();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }

  Icon _iconForIndex(int index) {
    switch (index) {
      case 0:
        return Icon(Icons.fitness_center);
      case 1:
        return Icon(Icons.list);
      case 2:
        return Icon(Icons.analytics);
      case 3:
        return Icon(Icons.link);
      case 4:
        return Icon(Icons.flag);
      // case 5:
      //   return Icon(Icons.settings);
      default:
        return Icon(Icons.person_2_outlined);
    }
  }
}
