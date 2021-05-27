// Flutter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// Third party
import 'package:provider/provider.dart';
// Local
import 'package:minesweeper/components/minesweeper_controller.dart';
import 'package:minesweeper/screens/menu_screen.dart';

void main() => runApp(Minesweeper());

class Minesweeper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ChangeNotifierProvider<MinesweeperController>(
      create: (BuildContext context) => MinesweeperController(),
      child: MaterialApp(
        title: 'Minesweeper',
        home: MenuScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
