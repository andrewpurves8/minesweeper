// Flutter
import 'package:flutter/material.dart';
// Third party
import 'package:provider/provider.dart';
// Local
import 'package:minesweeper/components/minesweeper_controller.dart';

class CellWidget extends StatelessWidget {
  final int i;
  final int j;

  CellWidget(this.i, this.j);

  @override
  Widget build(BuildContext context) {
    return Consumer<MinesweeperController>(
      builder: (BuildContext context, MinesweeperController gameController,
              Widget child) =>
          GestureDetector(
        onTap: () {
//          gameController.cellControllers[i][j].reveal();
          gameController.reveal(i, j);
        },
        child: Container(
          width: 40,
          height: 40,
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(4),
            child: Container(
              color: gameController.revealed[i][j]
//              color: gameController.cellControllers[i][j].isRevealed
                  ? Colors.white
                  : Colors.grey[800],
              child: gameController.revealed[i][j]
//                child: gameController.cellControllers[i][j].isRevealed
                  ? Center(
                      child: gameController.bombed[i][j]
//                  child: gameController.cellControllers[i][j].isBomb
                          ? Icon(Icons.whatshot)
                          : Text(
//                      '${gameController.cellControllers[i][j].numSurroundingBombs}'))
                              '${gameController.numSurroundingBombs[i][j]}'))
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
