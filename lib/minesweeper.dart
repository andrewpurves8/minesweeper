import 'dart:core';
import 'dart:math';

class Minesweeper {
  int width;
  int height;
  int numBombs;

  // Consists of either 0 - 8 referring to number of surrounding bombs,
  // or 9 if the cell contains a bomb
  List<List<int>> cells;

  Minesweeper({this.width, this.height, this.numBombs}) {
    cells = List.generate(height, (index) => List.filled(width, -1),
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
      cells[row][col] = 9;
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
}
