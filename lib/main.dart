import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PAES Catalog Dashboard',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F1319),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF38B6FF),
          secondary: Color(0xFF8A2387),
          surface: Color(0xFF0F1319),
          error: Color(0xFFE94057),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
            color: Colors.white,
          ),
          titleLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
            color: Colors.white,
          ),
          bodyLarge: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.normal,
            color: Color(0xFF90A4AE),
          ),
          bodyMedium: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.normal,
            color: Color(0xFF78909C),
          ),
          labelLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        useMaterial3: true,
      ),
      home: const AppEntry(),
    );
  }
}

class AppEntry extends StatefulWidget {
  const AppEntry({super.key});

  @override
  State<AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends State<AppEntry> {
  bool _isLoggedIn = false;
  String _username = '';

  void _handleLogin(String email) {
    setState(() {
      _isLoggedIn = true;
      _username = email;
    });
  }

  void _handleLogout() {
    setState(() {
      _isLoggedIn = false;
      _username = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoggedIn) {
      return DashboardScreen(username: _username, onLogout: _handleLogout);
    } else {
      return LoginScreen(onLoginSuccess: _handleLogin);
    }
  }
}
