// Flutter
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// Third party
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
// Local
import 'package:minesweeper/components/minesweeper_controller.dart';
import 'package:minesweeper/helpers/constants.dart';

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
          w = Icon(
            // Icons.block,
            // Icons.brightness_5,
            // Icons.brightness_high_outlined,
            // Icons.clear,
            // Icons.coronavirus,
            // Icons.dangerous,
            // Icons.flare,
            // Icons.gps_not_fixed,
            // Icons.grade,
            Icons.new_releases_outlined,
            // Icons.sentiment_very_dissatisfied_outlined,
            color: Colors.red,
          );
        else if (gameController.numSurroundingBombs[i][j] > 0)
          w = Text(
            '${gameController.numSurroundingBombs[i][j]}',
            style: TextStyle(color: kColorText, fontSize: 18),
          );
      } else if (gameController.flagged[i][j])
        w = Icon(
          Icons.flag,
          color: kColorBackground,
        );

      bool topRevealed = i != 0 && gameController.revealed[i - 1][j];
      bool bottomRevealed =
          i != gameController.height - 1 && gameController.revealed[i + 1][j];
      bool leftRevealed = j != 0 && gameController.revealed[i][j - 1];
      bool rightRevealed =
          j != gameController.width - 1 && gameController.revealed[i][j + 1];

      bool roundTopLeft = topRevealed && leftRevealed;
      bool roundTopRight = topRevealed && rightRevealed;
      bool roundBottomLeft = bottomRevealed && leftRevealed;
      bool roundBottomRight = bottomRevealed && rightRevealed;

      return GestureDetector(
        onTap: () {
          gameController.reveal(i, j, false);
        },
        onLongPress: () {
          gameController.flag(i, j);
          vibrate(100);
        },
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: roundTopLeft ? Radius.circular(5.0) : Radius.zero,
              topRight: roundTopRight ? Radius.circular(5.0) : Radius.zero,
              bottomLeft: roundBottomLeft ? Radius.circular(5.0) : Radius.zero,
              bottomRight:
                  roundBottomRight ? Radius.circular(5.0) : Radius.zero,
            ),
            color:
                gameController.revealed[i][j] ? kColorBackground : kColorAccent,
          ),
          child: Center(child: w),
        ),
      );
    });
  }

  void vibrate(int duration) async {
    if (await Vibration.hasCustomVibrationsSupport()) {
      Vibration.vibrate(duration: duration);
    } else {
      Vibration.vibrate();
    }
  }
}
