import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Constants {
  static Color mainColor = Color(0xff013678);
  // Name
  static String appName = "Rhinestone";

  // Material Design Color
  static Color lightPrimary = Color(0xfffcfcff);
  static Color lightAccent = Color(0xFF3B72FF);
  static Color lightBackground = Color(0xfffcfcff);

  static Color darkPrimary = Colors.black;
  static Color darkAccent = Color(0xFF3B72FF);
  static Color darkBackground = Colors.black;

  static Color grey = Color(0xff707070);
  static Color textPrimary = Color(0xFF486581);
  static Color textDark = Color(0xFF102A43);

  static Color backgroundColor = Color(0xFFF5F5F7);

  // Green
  static Color darkGreen = Color(0xFF3ABD6F);
  static Color lightGreen = Color(0xFFA1ECBF);

  // Yellow
  static Color darkYellow = Color(0xFF3ABD6F);
  static Color lightYellow = Color(0xFFFFDA7A);

  // Blue
  static Color darkBlue = Color(0xFF3B72FF);
  static Color lightBlue = Color(0xFF3EC6FF);

  // Orange
  static Color darkOrange = Color(0xFFFFB74D);

  static ThemeData lighTheme(BuildContext context) {
    return ThemeData(
      backgroundColor: lightBackground,
      primaryColor: lightPrimary,
      // cursorColor: lightAccent,
      scaffoldBackgroundColor: lightBackground,
      textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme),
      appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(
          color: lightAccent,
        ),
        toolbarTextStyle:
            GoogleFonts.latoTextTheme(Theme.of(context).textTheme).bodyText2,
        titleTextStyle:
            GoogleFonts.latoTextTheme(Theme.of(context).textTheme).headline6,
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(secondary: lightAccent),
    );
  }

  static double headerHeight = 228.5;
  static double paddingSide = 25.0;
}
