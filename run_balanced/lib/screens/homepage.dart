import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'training_screen.dart';
import 'programs_screen.dart';
import 'recap_screen.dart';
import 'connection_screen.dart';
import 'challenges_screen.dart';
import 'settings_screen.dart';
import 'profile_screen.dart';

// il contenuto visualizzato (pagina selezionata) cambia dinamicamente
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

// tiene traccia della schermata corrente. Inizialmente è 0 → la prima pagina (“Allenamento”)
class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    TrainingScreen(),
    ProgramsScreen(),
    RecapScreen(),
    ConnectionScreen(),
    ChallengesScreen(),
    SettingsScreen(),
  ];

  final List<String> _titles = [
    'Training',
    'Programs',
    'Recap',
    'Connection',
    'Challenges',
    'Settings',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titles[_selectedIndex],
          style: TextStyle(color: Colors.white), // Colore del testo in bianco
        ),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.white,
        ), // Per cambiare colore delle icone (es. menu)
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.black),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'RunBalance',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // chiude il drawer
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(),
                        ),
                      );
                    },
                    child: Column(
                      mainAxisSize:
                          MainAxisSize
                              .min, // Riduce al minimo lo spazio verticale utilizzato
                      children: [
                        CircleAvatar(
                          radius: 30, // Avatar di dimensioni fisse
                          backgroundColor: Colors.white, // Sfondo bianco
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            for (int i = 0; i < _titles.length; i++)
              ListTile(
                leading: _iconForIndex(i),
                title: Text(_titles[i]),
                selected: _selectedIndex == i,
                selectedTileColor: Colors.lightBlue.shade100,
                onTap: () {
                  setState(() {
                    _selectedIndex = i;
                    Navigator.pop(context); // chiude il drawer
                  });
                },
              ),
            Divider(), // Optional: separates the sign out from the rest

            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Sign Out'),
              onTap: () async {
                Navigator.pop(context); // Close the drawer
                await FirebaseAuth.instance.signOut();
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
      case 5:
        return Icon(Icons.settings);
      default:
        return Icon(Icons.circle);
    }
  }
}
