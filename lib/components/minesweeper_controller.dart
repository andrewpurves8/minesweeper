import 'dart:math';
// Flutter
import 'package:flutter/foundation.dart';

class MinesweeperController extends ChangeNotifier {
  int _width = 0;
  int get width => _width;

  int _height = 0;
  int get height => _height;

  int _numBombs = 0;
  int get numBombs => _numBombs;

  List<List<bool>> bombed = [[]];
  List<List<bool>> flagged = [[]];
  List<List<bool>> revealed = [[]];
  List<List<int>> numSurroundingBombs = [[]];
  int emptyCellNearestCentreRow = 0;
  int emptyCellNearestCentreCol = 0;
  bool gameWon = false;
  bool gameLost = false;
  bool get gameOver => gameWon || gameLost;
  int numFlags = 0;
  int numRevealed = 0;

  void init(int width, int height, int numBombs) {
    _width = width;
    _height = height;
    _numBombs = numBombs;
    bombed = create2DListBool();
    flagged = create2DListBool();
    revealed = create2DListBool();
    numSurroundingBombs = create2DListInt();
    gameWon = false;
    gameLost = false;
    numFlags = 0;
    numRevealed = 0;

    populateBombs();
    calcNumSurroundingBombs();

    reveal(emptyCellNearestCentreRow, emptyCellNearestCentreCol, false);
    notifyListeners();
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
    double centreRow = (height ~/ 2).toDouble();
    double centreCol = (width ~/ 2).toDouble();
    double nearestDistanceToCentre =
        sqrt(pow(centreRow, 2) + pow(centreCol, 2));

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

        if (numSurroundingBombs[i][j] == 0 && !bombed[i][j]) {
          double distanceToCentre = sqrt(pow(i.toDouble() - centreRow, 2) +
              pow(j.toDouble() - centreCol, 2));
          if (distanceToCentre < nearestDistanceToCentre) {
            nearestDistanceToCentre = distanceToCentre;
            emptyCellNearestCentreRow = i;
            emptyCellNearestCentreCol = j;
          }
        }
      }
    }
  }

  int calcNumSurroundingFlagsAt(int i, int j) {
    int flags = 0;
    int xMin = i == 0 ? 0 : -1;
    int xMax = i == height - 1 ? 0 : 1;

    int yMin = j == 0 ? 0 : -1;
    int yMax = j == width - 1 ? 0 : 1;

    for (int x = xMin; x <= xMax; x++) {
      for (int y = yMin; y <= yMax; y++) {
        if (x != 0 || y != 0) {
          flags += flagged[i + x][j + y] ? 1 : 0;
        }
      }
    }
    return flags;
  }

  void reveal(int i, int j, bool recursive) {
    if (flagged[i][j] || (revealed[i][j] && recursive)) return;

    if (bombed[i][j]) {
      gameLost = true;
      notifyListeners();
      return;
    }

    int xMin = i == 0 ? 0 : -1;
    int xMax = i == height - 1 ? 0 : 1;

    int yMin = j == 0 ? 0 : -1;
    int yMax = j == width - 1 ? 0 : 1;

    if (revealed[i][j]) {
      if (numSurroundingBombs[i][j] != calcNumSurroundingFlagsAt(i, j)) return;

      for (int x = xMin; x <= xMax; x++) {
        for (int y = yMin; y <= yMax; y++) {
          if ((x != 0 || y != 0) && !flagged[i][j]) {
            reveal(i + x, j + y, true);
          }
        }
      }
    } else {
      revealed[i][j] = true;

      if (numSurroundingBombs[i][j] == 0 && !bombed[i][j]) {
        Future.delayed(const Duration(milliseconds: 200), () {
          for (int x = xMin; x <= xMax; x++) {
            for (int y = yMin; y <= yMax; y++) {
              if (x != 0 || y != 0) {
                reveal(i + x, j + y, true);
              }
            }
          }
        });
      }
    }

    numRevealed++;
    checkWon();

    notifyListeners();
  }

  void flag(int i, int j) {
    if (revealed[i][j]) return;

    if (flagged[i][j])
      numFlags--;
    else
      numFlags++;

    flagged[i][j] = !flagged[i][j];

    checkWon();

    notifyListeners();
  }

  void checkWon() {
    gameWon = numRevealed + numFlags == width * height && numFlags == numBombs;
  }
}
