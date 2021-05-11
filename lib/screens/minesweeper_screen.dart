import 'dart:math';
// Flutter
import 'package:flutter/material.dart';
// Local
import 'package:minesweeper/components/cell_controller.dart';
import 'package:minesweeper/components/cell_widget.dart';

class MineSweeperScreen extends StatefulWidget {
  final int width;
  final int height;
  final int numBombs;

  MineSweeperScreen({this.width, this.height, this.numBombs});

  @override
  _MineSweeperScreenState createState() => _MineSweeperScreenState();
}

class _MineSweeperScreenState extends State<MineSweeperScreen> {
  List<List<CellController>> cellControllers;
  List<List<CellWidget>> cellWidgets;

  @override
  void initState() {
    super.initState();
    cellControllers = List.generate(
        widget.height,
        (i) => List.generate(widget.width, (j) => CellController(),
            growable: false),
        growable: false);

    populateBombs();
    populateNeighbours();

    for (int i = 0; i < widget.height; i++) {
      for (int j = 0; j < widget.width; j++) {
        cellControllers[i][j].calcNumSurroundingBombs();
      }
    }

    cellWidgets = List.generate(
        widget.height,
        (i) => List.generate(
            widget.width, (j) => CellWidget(controller: cellControllers[i][j]),
            growable: false),
        growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Minesweeper')),
      body: createCells(),
    );
  }

  Column createCells() {
    List<Row> rows = [];
    for (int i = 0; i < widget.height; i++) {
      rows.add(Row(children: cellWidgets[i]));
    }
    return Column(children: rows);
  }

  void populateBombs() {
    int numCells = widget.width * widget.height;

    // Generate list of cell indices, [0, 1, ..., numCells - 1]
    List<int> cellIndices = List.generate(numCells, (index) => index);
    List<int> cellIndicesShuffled = shuffle(cellIndices);

    // Front <numBombs - 1> entries in cellIndicesShuffled are the indices of the bombs
    for (int i = 0; i < widget.numBombs; i++) {
      int bombIndex = cellIndicesShuffled[i];
      int row = bombIndex ~/ widget.width;
      int col = bombIndex % widget.width;
      cellControllers[row][col].isBomb = true;
    }
  }

  List shuffle(List items) {
    Random random = Random();

    // Go through all elements
    for (int i = items.length - 1; i > 0; i--) {
      // Pick a pseudorandom number according to the list length
      int n = random.nextInt(i + 1);

      int temp = items[i];
      items[i] = items[n];
      items[n] = temp;
    }

    return items;
  }

  void populateNeighbours() {
    // Top left corner
    cellControllers[0][0].addNeighbour(cellControllers[0][1]);
    cellControllers[0][0].addNeighbour(cellControllers[1][0]);
    cellControllers[0][0].addNeighbour(cellControllers[1][1]);

    // Top right corner
    cellControllers[0][widget.width - 1]
        .addNeighbour(cellControllers[0][widget.width - 2]);
    cellControllers[0][widget.width - 1]
        .addNeighbour(cellControllers[1][widget.width - 1]);
    cellControllers[0][widget.width - 1]
        .addNeighbour(cellControllers[1][widget.width - 2]);

    // Bottom left corner
    cellControllers[widget.height - 1][0]
        .addNeighbour(cellControllers[widget.height - 1][1]);
    cellControllers[widget.height - 1][0]
        .addNeighbour(cellControllers[widget.height - 2][0]);
    cellControllers[widget.height - 1][0]
        .addNeighbour(cellControllers[widget.height - 2][1]);

    // Top right corner
    cellControllers[widget.height - 1][widget.width - 1]
        .addNeighbour(cellControllers[widget.height - 1][widget.width - 2]);
    cellControllers[widget.height - 1][widget.width - 1]
        .addNeighbour(cellControllers[widget.height - 2][widget.width - 1]);
    cellControllers[widget.height - 1][widget.width - 1]
        .addNeighbour(cellControllers[widget.height - 2][widget.width - 2]);

    // Rest of top row
    for (int j = 1; j < widget.width - 1; j++) {
      cellControllers[0][j].addNeighbour(cellControllers[0][j - 1]);
      cellControllers[0][j].addNeighbour(cellControllers[1][j - 1]);
      cellControllers[0][j].addNeighbour(cellControllers[1][j]);
      cellControllers[0][j].addNeighbour(cellControllers[1][j + 1]);
      cellControllers[0][j].addNeighbour(cellControllers[0][j + 1]);
    }

    // Rest of bottom row
    for (int j = 1; j < widget.width - 1; j++) {
      cellControllers[widget.height - 1][j]
          .addNeighbour(cellControllers[widget.height - 1][j - 1]);
      cellControllers[widget.height - 1][j]
          .addNeighbour(cellControllers[widget.height - 2][j - 1]);
      cellControllers[widget.height - 1][j]
          .addNeighbour(cellControllers[widget.height - 2][j]);
      cellControllers[widget.height - 1][j]
          .addNeighbour(cellControllers[widget.height - 2][j + 1]);
      cellControllers[widget.height - 1][j]
          .addNeighbour(cellControllers[widget.height - 1][j + 1]);
    }

    // Rest of left column
    for (int i = 1; i < widget.height - 1; i++) {
      cellControllers[i][0].addNeighbour(cellControllers[i - 1][0]);
      cellControllers[i][0].addNeighbour(cellControllers[i - 1][1]);
      cellControllers[i][0].addNeighbour(cellControllers[i][1]);
      cellControllers[i][0].addNeighbour(cellControllers[i + 1][1]);
      cellControllers[i][0].addNeighbour(cellControllers[i + 1][0]);
    }

    // Rest of right column
    for (int i = 1; i < widget.height - 1; i++) {
      cellControllers[i][widget.width - 1]
          .addNeighbour(cellControllers[i - 1][widget.width - 1]);
      cellControllers[i][widget.width - 1]
          .addNeighbour(cellControllers[i - 1][widget.width - 2]);
      cellControllers[i][widget.width - 1]
          .addNeighbour(cellControllers[i][widget.width - 2]);
      cellControllers[i][widget.width - 1]
          .addNeighbour(cellControllers[i + 1][widget.width - 2]);
      cellControllers[i][widget.width - 1]
          .addNeighbour(cellControllers[i + 1][widget.width - 1]);
    }

    // Rest of cells
    for (int i = 1; i < widget.height - 1; i++) {
      for (int j = 1; j < widget.width - 1; j++) {
        cellControllers[i][j].addNeighbour(cellControllers[i - 1][j - 1]);
        cellControllers[i][j].addNeighbour(cellControllers[i - 1][j]);
        cellControllers[i][j].addNeighbour(cellControllers[i - 1][j + 1]);

        cellControllers[i][j].addNeighbour(cellControllers[i][j - 1]);
        cellControllers[i][j].addNeighbour(cellControllers[i][j + 1]);

        cellControllers[i][j].addNeighbour(cellControllers[i + 1][j - 1]);
        cellControllers[i][j].addNeighbour(cellControllers[i + 1][j]);
        cellControllers[i][j].addNeighbour(cellControllers[i + 1][j + 1]);
      }
    }
  }
}
