// Flutter
import 'package:flutter/material.dart';
// Third party
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
// Local
import 'package:minesweeper/components/minesweeper_controller.dart';
import 'package:minesweeper/helpers/constants.dart';

class CellWidget extends StatefulWidget {
  final int i;
  final int j;

  CellWidget(this.i, this.j);

  @override
  _CellWidgetState createState() => _CellWidgetState();
}

class _CellWidgetState extends State<CellWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _colorController;
  Animation<Color> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _colorController = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _colorAnimation = ColorTween(begin: kColorAccent, end: kColorBackground)
        .animate(
            CurvedAnimation(parent: _colorController, curve: Curves.decelerate))
          ..addListener(() {
            setState(() {});
          });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MinesweeperController>(builder: (BuildContext context,
        MinesweeperController gameController, Widget child) {
      bool topRevealed =
          widget.i != 0 && gameController.revealed[widget.i - 1][widget.j];
      bool bottomRevealed = widget.i != gameController.height - 1 &&
          gameController.revealed[widget.i + 1][widget.j];
      bool leftRevealed =
          widget.j != 0 && gameController.revealed[widget.i][widget.j - 1];
      bool rightRevealed = widget.j != gameController.width - 1 &&
          gameController.revealed[widget.i][widget.j + 1];

      bool roundTopLeft = topRevealed && leftRevealed;
      bool roundTopRight = topRevealed && rightRevealed;
      bool roundBottomLeft = bottomRevealed && leftRevealed;
      bool roundBottomRight = bottomRevealed && rightRevealed;

      if (gameController.revealed[widget.i][widget.j])
        _colorController.forward();

      return GestureDetector(
        onTap: () {
          gameController.reveal(widget.i, widget.j, false);
          if (gameController.gameLost) vibrate(100);
        },
        onLongPress: () {
          gameController.flag(widget.i, widget.j);
          vibrate(100);
        },
        child: Container(
          width: kCellSize,
          height: kCellSize,
          decoration: BoxDecoration(
            borderRadius: !gameController.revealed[widget.i][widget.j]
                ? BorderRadius.only(
                    topLeft: roundTopLeft ? Radius.circular(5.0) : Radius.zero,
                    topRight:
                        roundTopRight ? Radius.circular(5.0) : Radius.zero,
                    bottomLeft:
                        roundBottomLeft ? Radius.circular(5.0) : Radius.zero,
                    bottomRight:
                        roundBottomRight ? Radius.circular(5.0) : Radius.zero,
                  )
                : null,
            // color: gameController.revealed[widget.i][widget.j]
            //     ? kColorBackground
            //     : kColorAccent,
            color: _colorAnimation.value,
          ),
          child: Center(
              child: Opacity(
                  opacity: gameController.revealed[widget.i][widget.j]
                      ? _colorController.value
                      : 1.0,
                  child: _createCell(gameController))),
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

  Widget _createCell(MinesweeperController gameController) {
    if (gameController.revealed[widget.i][widget.j]) {
      if (gameController.bombed[widget.i][widget.j]) {
        return Icon(
          Icons.new_releases_outlined,
          color: Colors.red,
        );
      } else if (gameController.numSurroundingBombs[widget.i][widget.j] > 0) {
        return Text(
          '${gameController.numSurroundingBombs[widget.i][widget.j]}',
          style: TextStyle(color: kColorText, fontSize: 18),
        );
      }
    } else if (gameController.flagged[widget.i][widget.j]) {
      return Icon(
        Icons.flag,
        color: kColorBackground,
      );
    }

    return null;
  }
}
