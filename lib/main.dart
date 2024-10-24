import 'package:flutter/material.dart';
import 'package:weather_app/weather_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async{
  await dotenv.load(fileName: "assets/.env");
  runApp(const MyWeatherApp());
}

class MyWeatherApp extends StatefulWidget {
  const MyWeatherApp({super.key});

  @override
  State<MyWeatherApp> createState() => _MyWeatherAppState();
}

class _MyWeatherAppState extends State<MyWeatherApp> {
  // Dark theme colors based on darker tones of the sunset
  final darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: const Color(0xFFFFB4A1), // Muted sunset pink
    onPrimary: const Color(0xFF2B2B2B),
    primaryContainer: const Color(0xFF8B4A3F), // Darker version of primary
    onPrimaryContainer: const Color(0xFFFFDADA),
    secondary: const Color(0xFFCE93D8), // Darker blue-purple
    onSecondary: Colors.white,
    secondaryContainer: const Color(0xFF4A5270), // Darker version of secondary
    onSecondaryContainer: const Color(0xFFE1E5F5),
    tertiary: const Color(0xFF885F57), // Darker pink
    onTertiary: Colors.white,
    tertiaryContainer: const Color(0xFF633B34), // Darker version of tertiary
    onTertiaryContainer: const Color(0xFFFFE6E2),
    error: const Color(0xFFFFB4AB),
    onError: const Color(0xFF690005),
    errorContainer: const Color(0xFF93000A),
    onErrorContainer: const Color(0xFFFFDAD6),
    surface: const Color(0xFF2B2B2B), // Dark surface
    onSurface: Colors.white,
    onSurfaceVariant: const Color(0xFFC5C6D0),
    outline: const Color(0xFF8F909A),
    outlineVariant: const Color(0xFF45464F),
    shadow: Colors.black.withOpacity(0.2),
    scrim: Colors.black.withOpacity(0.3),
    inverseSurface: const Color(0xFFE4E3E7),
    onInverseSurface: const Color(0xFF1B1B1F),
    inversePrimary: const Color(0xFF984838),
  );

  ThemeData _createTheme(ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,

      // Card theme
      cardTheme: CardTheme(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: colorScheme.surface,
      ),

      // App bar theme
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: colorScheme.primary),
      ),

      // Text theme
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 16,
        ),
      ),

      // Icon theme
      iconTheme: IconThemeData(
        color: colorScheme.primary,
        size: 24,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _createTheme(darkColorScheme),
      darkTheme: _createTheme(darkColorScheme),
      home: const WeatherScreen(),
    );
  }
}
