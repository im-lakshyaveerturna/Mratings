import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  fontFamily: 'OpenSans',
  primaryColor: Colors.black12,
  textTheme: TextTheme(
    button: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
  ),
);

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  fontFamily: 'OpenSans',
  primaryColor: Colors.white,
  textTheme: TextTheme(
    button: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),
  ),
);
