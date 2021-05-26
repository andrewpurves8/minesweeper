// Flutter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// Local
import 'package:minesweeper/screens/menu_screen.dart';
import 'package:minesweeper/screens/minesweeper_screen.dart';

void main() => runApp(Minesweeper());

class Minesweeper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Minesweeper',
      theme: ThemeData(
        appBarTheme: AppBarTheme(color: Colors.grey[800]),
      ),
      home: MenuScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
