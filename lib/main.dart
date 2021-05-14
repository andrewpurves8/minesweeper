// Flutter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// Third party
import 'package:provider/provider.dart';
// Local
import 'package:minesweeper/components/minesweeper_controller.dart';
import 'package:minesweeper/screens/minesweeper_screen.dart';

void main() => runApp(Minesweeper());

class Minesweeper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ChangeNotifierProvider<MinesweeperController>(
      create: (BuildContext context) => MinesweeperController(
        width: 10,
        height: 10,
        numBombs: 10,
      ),
      child: MaterialApp(
        title: 'Minesweeper',
        theme: ThemeData(
          appBarTheme: AppBarTheme(color: Colors.grey[800]),
        ),
        home: MineSweeperScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
