import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/theme.dart';

import 'theme/thememanager.dart';
import 'pages/home.dart';

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
            },
          );
        },
      ),
    );
  }
}
