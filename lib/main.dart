import 'package:flutter/material.dart';

import 'screens/programs_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Temporary theme demo: hot restart resets the app to dark mode.
  ThemeMode _themeMode = ThemeMode.dark;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark
          ? ThemeMode.light
          : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF171717),
          onPrimary: Color(0xFFF5F5F3),
          secondary: Color(0xFF171717),
          onSecondary: Color(0xFFF5F5F3),
          secondaryContainer: Color(0xFF171717),
          onSecondaryContainer: Color(0xFFF5F5F3),
          surface: Color(0xFFF0F0F0),
          onSurface: Color(0xFF171717),
        ),
        scaffoldBackgroundColor: const Color(0xFFFAFAFA),
      ),
      darkTheme: ThemeData(
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFF5F5F3),
          onPrimary: Color(0xFF090909),
          surface: Color(0xFF171717),
          onSurface: Color(0xFFF5F5F3),
        ),
        scaffoldBackgroundColor: const Color(0xFF090909),
      ),
      home: MyHomePage(
        title: 'Flutter Demo Home Page',
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
    required this.onToggleTheme,
  });

  final String title;
  final VoidCallback onToggleTheme;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  static const _pageTitles = ['Today', 'Programs', 'Schedule', 'History'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(_pageTitles[_selectedIndex]),
      ),
      body: switch (_selectedIndex) {
        1 => const ProgramsPage(),
        _ => Center(
              child: Text(
                _pageTitles[_selectedIndex],
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
      },
      bottomNavigationBar: NavigationBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        indicatorColor: Theme.of(context).colorScheme.primary,
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.today_outlined),
            label: 'Today',
          ),
          NavigationDestination(
            icon: Icon(Icons.fitness_center),
            label: 'Programs',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Schedule',
          ),
          NavigationDestination(icon: Icon(Icons.history), label: 'History'),
        ],
      ),
    );
  }
}
