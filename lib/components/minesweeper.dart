import 'dart:core';
import 'dart:math';
import 'cell.dart';

class Minesweeper {
  int width;
  int height;
  int numBombs;

  List<List<Cell>> cells;

  Minesweeper({this.width, this.height, this.numBombs}) {
    cells = List.generate(height, (index) => List.filled(width, Cell()),
        growable: false);

    int numCells = width * height;
    // Generate list of cell indices, [0, 1, ..., numCells - 1]
    List<int> cellIndices = List.generate(numCells, (index) => index);
    List<int> cellIndicesShuffled = shuffle(cellIndices);
    // Front <numBombs - 1> entries in cellIndicesShuffled are the indices of the bombs
    for (int i = 0; i < numBombs; i++) {
      int bombIndex = cellIndicesShuffled[i];
      int row = bombIndex ~/ width;
      int col = bombIndex % width;
      cells[row][col].isBomb = true;
    }

    populateAdjacent();

    for (int i = 0; i < height; i++) {
      for (int j = 0; j < width; j++) {
        cells[i][j].calcNumSurroundingBombs();
      }
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

  void populateAdjacent() {
    // Top left corner
    cells[0][0].right = cells[0][1];
    cells[0][0].bottom = cells[1][0];
    cells[0][0].bottomRight = cells[1][1];

    // Top right corner
    cells[0][width - 1].left = cells[0][width - 2];
    cells[0][width - 1].bottom = cells[1][width - 1];
    cells[0][width - 1].bottomLeft = cells[1][width - 2];

    // Bottom left corner
    cells[height - 1][0].right = cells[height - 1][1];
    cells[height - 1][0].top = cells[height - 2][0];
    cells[height - 1][0].topRight = cells[height - 2][1];

    // Top right corner
    cells[height - 1][width - 1].left = cells[height - 1][width - 2];
    cells[height - 1][width - 1].bottom = cells[height - 2][width - 1];
    cells[height - 1][width - 1].bottomLeft = cells[height - 2][width - 2];

    // Rest of top row
    for (int j = 1; j < width - 1; j++) {
      cells[0][j].left = cells[0][j - 1];
      cells[0][j].bottomLeft = cells[1][j - 1];
      cells[0][j].bottom = cells[1][j];
      cells[0][j].bottomRight = cells[1][j + 1];
      cells[0][j].right = cells[0][j + 1];
    }

    // Rest of bottom row
    for (int j = 1; j < width - 1; j++) {
      cells[height - 1][j].left = cells[height - 1][j - 1];
      cells[height - 1][j].topLeft = cells[height - 2][j - 1];
      cells[height - 1][j].top = cells[height - 2][j];
      cells[height - 1][j].topRight = cells[height - 2][j + 1];
      cells[height - 1][j].right = cells[height - 1][j + 1];
    }

    // Rest of left column
    for (int i = 1; i < height - 1; i++) {
      cells[i][0].top = cells[i - 1][0];
      cells[i][0].topRight = cells[i - 1][1];
      cells[i][0].right = cells[i][1];
      cells[i][0].bottomRight = cells[i + 1][1];
      cells[i][0].bottom = cells[i + 1][0];
    }

    // Rest of right column
    for (int i = 1; i < height - 1; i++) {
      cells[i][width - 1].top = cells[i - 1][width - 1];
      cells[i][width - 1].topLeft = cells[i - 1][width - 2];
      cells[i][width - 1].left = cells[i][width - 2];
      cells[i][width - 1].bottomLeft = cells[i + 1][width - 2];
      cells[i][width - 1].bottom = cells[i + 1][width - 1];
    }

    // Rest of cells
    for (int i = 1; i < height - 1; i++) {
      for (int j = 1; j < width - 1; j++) {
        cells[i][j].topLeft = cells[i - 1][j - 1];
        cells[i][j].top = cells[i - 1][j];
        cells[i][j].topRight = cells[i - 1][j + 1];

        cells[i][j].left = cells[i][j - 1];
        cells[i][j].right = cells[i][j + 1];

        cells[i][j].topLeft = cells[i + 1][j - 1];
        cells[i][j].top = cells[i + 1][j];
        cells[i][j].topRight = cells[i + 1][j + 1];
      }
    }
  }
}
