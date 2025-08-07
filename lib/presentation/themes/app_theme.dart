import 'package:flutter/material.dart';

/// Theme configuration for the Supervisor app
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // Color constants based on UI/UX design document
  static const Color _primaryColor = Color(0xFF1565C0); // Azul
  static const Color _secondaryColor = Color(0xFFFFA000); // Ámbar
  static const Color _backgroundColor = Color(0xFFFFFFFF); // Blanco
  static const Color _textPrimaryColor = Color(0xFF212121); // Negro
  static const Color _textSecondaryColor = Color(0xFF757575); // Gris
  // static const Color _accentColor = Color(0xFF4CAF50); // Verde
  static const Color _errorColor = Color(0xFFF44336); // Rojo

  // Light theme configuration
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: _primaryColor,
      secondary: _secondaryColor,
      error: _errorColor,
      surface: _backgroundColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: _textPrimaryColor,
      onError: Colors.white,
    ),
    
    // Typography configuration
    fontFamily: 'Roboto',
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _textPrimaryColor),
      displayMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: _textPrimaryColor),
      bodyLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: _textPrimaryColor),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: _textPrimaryColor),
      labelLarge: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: _textSecondaryColor),
    ),
    
    // AppBar theme
    appBarTheme: const AppBarTheme(
      backgroundColor: _primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    
    // Elevated Button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
    ),
    
    // Outlined Button theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _primaryColor,
        side: const BorderSide(color: _primaryColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
    ),
    
    // Floating Action Button theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _secondaryColor,
      foregroundColor: Colors.white,
      elevation: 6,
    ),
    
    // Input Decoration theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Colors.grey, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Colors.grey, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: _primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: _errorColor, width: 1),
      ),
      labelStyle: const TextStyle(color: _textSecondaryColor),
      errorStyle: const TextStyle(color: _errorColor),
    ),
    
    // Card theme
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      margin: const EdgeInsets.all(8),
    ),
    
    // Checkbox theme
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return _primaryColor;
        }
        return Colors.transparent;
      }),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2),
      ),
    ),
  );
}