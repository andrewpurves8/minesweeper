import 'dart:math';
// Flutter
import 'package:flutter/material.dart';
// Third party
import 'package:provider/provider.dart';
// Local
import 'package:minesweeper/components/cell_widget.dart';
import 'package:minesweeper/components/minesweeper_controller.dart';

class MineSweeperScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MinesweeperController>(
        builder: (BuildContext context, MinesweeperController gameController,
                Widget child) =>
            Scaffold(
              appBar: AppBar(title: Text('Minesweeper')),
              body: createCells(gameController),
            ));
  }

  Column createCells(MinesweeperController gameController) {
    List<Row> rows = [];
    for (int i = 0; i < gameController.height; i++) {
      List<CellWidget> cellWidgets = [];
      for (int j = 0; j < gameController.width; j++) {
        cellWidgets.add(CellWidget(i, j));
      }
      rows.add(Row(children: cellWidgets));
    }
    return Column(children: rows);
  }
}
