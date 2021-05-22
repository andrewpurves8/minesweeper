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
    return Consumer<MinesweeperController>(builder: (BuildContext context,
        MinesweeperController gameController, Widget child) {
      Widget w;
      if (gameController.revealed[i][j]) {
        if (gameController.bombed[i][j])
          w = Icon(Icons.whatshot);
        else if (gameController.numSurroundingBombs[i][j] > 0)
          w = Text('${gameController.numSurroundingBombs[i][j]}');
      } else if (gameController.flagged[i][j]) w = Icon(Icons.flag);

      return GestureDetector(
        onTap: () {
          gameController.reveal(i, j, false);
        },
        onLongPress: () {
          gameController.flag(i, j);
        },
        child: Container(
          width: 40,
          height: 40,
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(4),
            child: Container(
              color: gameController.revealed[i][j]
                  ? Colors.white
                  : Colors.grey[800],
              child: Center(child: w),
            ),
          ),
        ),
      );
    });
  }
}
