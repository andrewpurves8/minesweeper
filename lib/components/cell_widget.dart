import 'dart:math';
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
        duration: const Duration(milliseconds: 300), vsync: this);
    _colorAnimation = ColorTween(begin: kColorAccent, end: kColorBackground)
        .animate(_colorController)
          ..addListener(() {
            setState(() {});
          });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MinesweeperController>(builder: (BuildContext context,
        MinesweeperController gameController, Widget child) {
      if (gameController.revealed[widget.i][widget.j]) {
        _colorController.forward();
      }

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

      return GestureDetector(
        onTap: () {
          gameController.reveal(widget.i, widget.j, false);
          if (gameController.gameLost) vibrate(200);
        },
        onLongPress: () {
          gameController.flag(widget.i, widget.j);
          vibrate(50);
        },
        child: SizedBox(
          width: kCellSize,
          height: kCellSize,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              // Only round border of covered cells or bombed cells at end-game
              borderRadius: !gameController.revealed[widget.i][widget.j] ||
                      (gameController.gameLost &&
                          gameController.bombed[widget.i][widget.j])
                  ? BorderRadius.only(
                      topLeft:
                          roundTopLeft ? Radius.circular(5.0) : Radius.zero,
                      topRight:
                          roundTopRight ? Radius.circular(5.0) : Radius.zero,
                      bottomLeft:
                          roundBottomLeft ? Radius.circular(5.0) : Radius.zero,
                      bottomRight:
                          roundBottomRight ? Radius.circular(5.0) : Radius.zero,
                    )
                  : null,
              color: _determineBackgroundColor(gameController),
            ),
            child: Center(
                child: Opacity(
                    // Only smooth opacity of revealed cells during the game
                    opacity: gameController.revealed[widget.i][widget.j] &&
                            !gameController.gameOver
                        ? _colorController.value
                        : 1.0,
                    child: _createCell(gameController))),
          ),
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
    // If flagged, show flag icon
    if (gameController.flagged[widget.i][widget.j])
      return Icon(
        Icons.flag,
        color: kColorBackground,
      );

    // If we lost the game, show all the bombs
    if (gameController.gameLost && gameController.bombed[widget.i][widget.j])
      return Icon(
        Icons.new_releases_outlined,
        color: Colors.black,
      );

    // If the tile has been revealed and there are bombs around it, show number of bombs
    if (gameController.revealed[widget.i][widget.j] &&
        gameController.numSurroundingBombs[widget.i][widget.j] > 0)
      return Text(
        '${gameController.numSurroundingBombs[widget.i][widget.j]}',
        style: TextStyle(color: kColorText, fontSize: 18),
      );

    // Else show nothing
    return null;
  }

  Color _determineBackgroundColor(MinesweeperController gameController) {
    // If we lost the game, show bombs in red
    if (gameController.bombed[widget.i][widget.j] && gameController.gameLost)
      return Colors.red;

    if (gameController.revealed[widget.i][widget.j]) {
      // The tile revealed at game-over shouldn't animate
      if (gameController.gameOver)
        return kColorBackground;
      else
        return _colorAnimation.value;
    }

    // Not revealed, return covered color
    return kColorAccent;
  }
}
