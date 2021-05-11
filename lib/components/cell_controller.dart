class CellController {
  bool isBomb = false;
  bool isRevealed = false;
  bool isFlagged = false;
  int numSurroundingBombs = 0;

  List<CellController> neighbours = [];

  void calcNumSurroundingBombs() {
    for (int i = 0; i < neighbours.length; i++) {
      if (neighbours[i].isBomb) numSurroundingBombs++;
    }
  }

  void addNeighbour(CellController cell) {
    neighbours.add(cell);
  }

  void reveal() {
    if (isRevealed) return;

    isRevealed = true;

    if (numSurroundingBombs == 0) {
      for (int i = 0; i < neighbours.length; i++) {
        neighbours[i].reveal();
      }
    }
  }
}
