import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:run_balanced/theme/theme_provider.dart';
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
    ProfileScreen(),
  ];

  final List<String> _titles = [
    'Training',
    'Programs',
    'Recap',
    'Connection',
    'Challenges',
    'Settings',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = 6; // Index of ProfileScreen
                      });
                      Navigator.pop(context); // Close the drawer
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: theme.cardColor,
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
      case 5:
        return Icon(Icons.settings);
      default:
        return Icon(Icons.circle);
    }
  }
}
