// Flutter
import 'package:flutter/material.dart';
// Local
import 'package:minesweeper/components/cell_visual.dart';

class MineSweeperScreen extends StatefulWidget {
  int width;
  int height;

  MineSweeperScreen({this.width, this.height});

  @override
  _MineSweeperScreenState createState() => _MineSweeperScreenState();
}

class _MineSweeperScreenState extends State<MineSweeperScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Minesweeper')),
      body: createCells(),
    );
  }

  Column createCells() {
    List<Row> rows;
    for (int i = 0; i < widget.height; i++) {
      List<CellVisual> cells;
      for (int j = 0; j < widget.width; j++) {
        cells.add(CellVisual());
      }
      rows.add(Row(children: cells));
    }
    return Column(children: rows);
  }
}
