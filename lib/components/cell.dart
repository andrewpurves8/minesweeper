class Cell {
  bool isBomb = false;
  bool isRevealed = false;
  bool isFlagged = false;
  int numSurroundingBombs = 0;

  // References to adjacent cells
  Cell topLeft;
  Cell top;
  Cell topRight;
  Cell left;
  Cell right;
  Cell bottomLeft;
  Cell bottom;
  Cell bottomRight;

  void calcNumSurroundingBombs() {
    if (topLeft != null && topLeft.isBomb) numSurroundingBombs++;
    if (top != null && top.isBomb) numSurroundingBombs++;
    if (topRight != null && topRight.isBomb) numSurroundingBombs++;

    if (left != null && left.isBomb) numSurroundingBombs++;
    if (right != null && right.isBomb) numSurroundingBombs++;

    if (bottomLeft != null && bottomLeft.isBomb) numSurroundingBombs++;
    if (bottom != null && bottom.isBomb) numSurroundingBombs++;
    if (bottomRight != null && bottomRight.isBomb) numSurroundingBombs++;
  }
}
