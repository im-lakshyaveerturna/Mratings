import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/theme.dart';
import 'theme/thememanager.dart';

import 'collections/action_cinema.dart';
import 'package:mratings/collections/comedy_cinema.dart';
import 'package:mratings/collections/drama_cinema.dart';
import 'package:mratings/collections/horror_cinema.dart';

import 'package:mratings/collections/romance_cinema.dart';
import 'package:mratings/collections/sci-fi_cinema.dart';
import 'package:mratings/collections/superhero_cinema.dart';
import 'package:mratings/collections/top_grossing.dart';


import 'pages/home.dart';
import 'package:mratings/pages/content.dart';
import 'package:mratings/error_page/error_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeManager(),
      child: Consumer<ThemeManager>(
        builder: (context, themeManager, child) {

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeManager.thememode,
            initialRoute: '/',
            routes: {
              '/': (context) => Home(),
              '/content': (context) => Content(),
              '/error': (context) => Error(),
              '/action_cinema': (context) => ActionC(),
              '/sci-fi_cinema': (context) => Scifi(),
              '/superhero_cinema': (context) => SHero(),
              '/romance_cinema': (context) => Romance(),
              '/comedy_cinema': (context) => Comedy(),
              '/horror_cinema': (context) => Horror(),
              '/top_grossing_cinema': (context) => Grossing(),
              '/drama_cinema': (context) => Drama(),
            },
          );
        },
      ),
    );
  }
}
