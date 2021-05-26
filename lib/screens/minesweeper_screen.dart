import 'dart:math';
// Flutter
import 'package:flutter/material.dart';
// Third party
import 'package:provider/provider.dart';
// Local
import 'package:minesweeper/components/cell_widget.dart';
import 'package:minesweeper/components/minesweeper_controller.dart';
import 'package:minesweeper/helpers/constants.dart';

class MineSweeperScreen extends StatelessWidget {
  final int width;
  final int height;
  final int numBombs;

  MineSweeperScreen({this.width, this.height, this.numBombs});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MinesweeperController>(
      create: (BuildContext context) => MinesweeperController(
        width: width,
        height: height,
        numBombs: numBombs,
      ),
      child: Scaffold(
        backgroundColor: kColorBackground,
        body: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            SizedBox(
              height: 50.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                  Text(
                    '1:23',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: kColorText,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      '12',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: kColorText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: InteractiveViewer(
                boundaryMargin: const EdgeInsets.all(100.0),
                minScale: 0.1,
                maxScale: 1.4,
                constrained: false,
                child: createCells(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column createCells() {
    List<Widget> rows = [];
    for (int i = 0; i < height; i++) {
      List<CellWidget> cellWidgets = [];
      for (int j = 0; j < width; j++) {
        cellWidgets.add(CellWidget(i, j));
      }
      rows.add(Row(children: cellWidgets));
    }
    return Column(children: rows);
  }
}
