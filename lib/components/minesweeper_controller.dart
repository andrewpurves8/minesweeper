import 'dart:math';
// Flutter
import 'package:flutter/foundation.dart';

class MinesweeperController extends ChangeNotifier {
  final int width;
  final int height;
  final int numBombs;
  List<List<bool>> bombed;
  List<List<bool>> flagged;
  List<List<bool>> revealed;
  List<List<int>> numSurroundingBombs;

  MinesweeperController({this.width, this.height, this.numBombs}) {
    bombed = create2DListBool();
    flagged = create2DListBool();
    revealed = create2DListBool();
    numSurroundingBombs = create2DListInt();

    populateBombs();
    calcNumSurroundingBombs();
  }

  List<List<bool>> create2DListBool() => List.generate(
      height, (i) => List.generate(width, (j) => false, growable: false),
      growable: false);

  List<List<int>> create2DListInt() => List.generate(
      height, (i) => List.generate(width, (j) => 0, growable: false),
      growable: false);

  void populateBombs() {
    int numCells = width * height;

    // Generate list of cell indices, [0, 1, ..., numCells - 1]
    List<int> cellIndices = List.generate(numCells, (index) => index);
    List<int> cellIndicesShuffled = shuffle(cellIndices);

    // Front <numBombs - 1> entries in cellIndicesShuffled are the indices of the bombs
    for (int i = 0; i < numBombs; i++) {
      int bombIndex = cellIndicesShuffled[i];
      int row = bombIndex ~/ width;
      int col = bombIndex % width;
      bombed[row][col] = true;
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

  void calcNumSurroundingBombs() {
    for (int i = 0; i < height; i++) {
      for (int j = 0; j < width; j++) {
        int xMin = i == 0 ? 0 : -1;
        int xMax = i == height - 1 ? 0 : 1;

        int yMin = j == 0 ? 0 : -1;
        int yMax = j == width - 1 ? 0 : 1;

        for (int x = xMin; x <= xMax; x++) {
          for (int y = yMin; y <= yMax; y++) {
            if (x != 0 || y != 0) {
              numSurroundingBombs[i][j] += bombed[i + x][j + y] ? 1 : 0;
            }
          }
        }
      }
    }
  }

  void reveal(int i, int j) {
    if (revealed[i][j]) return;

    revealed[i][j] = true;

    if (numSurroundingBombs[i][j] == 0 && !bombed[i][j]) {
      int xMin = i == 0 ? 0 : -1;
      int xMax = i == height - 1 ? 0 : 1;

      int yMin = j == 0 ? 0 : -1;
      int yMax = j == width - 1 ? 0 : 1;

      for (int x = xMin; x <= xMax; x++) {
        for (int y = yMin; y <= yMax; y++) {
          if (x != 0 || y != 0) {
            reveal(i + x, j + y);
          }
        }
      }
    }

    notifyListeners();
  }
}
