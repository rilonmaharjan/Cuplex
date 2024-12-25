  import 'package:flutter/material.dart';

ThemeData buildAppTheme() {
    const seedColor = Color(0xffecc877);
    const cursorColor = Color.fromARGB(255, 110, 108, 110);
    const selectionHandleColor = Color.fromARGB(255, 228, 191, 106);

    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
      useMaterial3: true,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: cursorColor,
        selectionColor: seedColor.withOpacity(0.7),
        selectionHandleColor: selectionHandleColor,
      ),
      scaffoldBackgroundColor: Colors.white,
    );
  }