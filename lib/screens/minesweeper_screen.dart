import 'dart:async';
// Flutter
import 'package:flutter/material.dart';
// Third party
import 'package:provider/provider.dart';
// Local
import 'package:minesweeper/components/cell_widget.dart';
import 'package:minesweeper/components/minesweeper_controller.dart';
import 'package:minesweeper/helpers/constants.dart';

const double appBarHeight = 50.0;

class MinesweeperScreen extends StatefulWidget {
  final int width;
  final int height;
  final int numBombs;
  final int emptyCellNearestCentreRow;
  final int emptyCellNearestCentreCol;
  final double topBarHeight;
  final double screenWidth;
  final double screenHeight;

  MinesweeperScreen(
      {this.width,
      this.height,
      this.numBombs,
      this.emptyCellNearestCentreRow,
      this.emptyCellNearestCentreCol,
      this.topBarHeight,
      this.screenWidth,
      this.screenHeight});

  @override
  _MinesweeperScreenState createState() => _MinesweeperScreenState();
}

class _MinesweeperScreenState extends State<MinesweeperScreen>
    with SingleTickerProviderStateMixin {
  bool timerFlag = true;
  Stream<int> timerStream;
  StreamSubscription<int> timerSubscription;
  String time = '0:00';
  TransformationController transformationController =
      TransformationController();
  AnimationController opacityController;

  @override
  void initState() {
    super.initState();
    timerStream = stopWatchStream();
    timerSubscription = timerStream.listen((int newTick) {
      setState(() {
        int minutes = ((newTick / 60) % 60).floor();
        int seconds = (newTick % 60).floor();
        String secondsPadded = seconds.toString().padLeft(2, '0');
        time = minutes > 0 ? '$minutes:$secondsPadded' : '$seconds';
      });
    });
    double availableHeight =
        widget.screenHeight - widget.topBarHeight - appBarHeight;
    transformationController.value.setTranslationRaw(
        0.5 * widget.screenWidth -
            kCellSize * (widget.emptyCellNearestCentreCol.toDouble() + 0.5),
        0.5 * availableHeight -
            kCellSize * (widget.emptyCellNearestCentreRow.toDouble() + 0.5),
        0.0);
    opacityController = AnimationController(
        duration: const Duration(milliseconds: 5000), vsync: this);
    opacityController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    timerSubscription.cancel();
    timerStream = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MinesweeperController>(
      builder: (BuildContext context, MinesweeperController gameController,
          Widget child) {
        if (gameController.gameOver) {
          opacityController.forward();
          timerSubscription.cancel();
        }

        return Scaffold(
          backgroundColor: kColorBackground,
          body: Column(
            children: [
              SizedBox(
                height: widget.topBarHeight,
              ),
              SizedBox(
                height: appBarHeight,
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child:
                                  Icon(Icons.arrow_back, color: Colors.white),
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Spacer(),
                          Icon(Icons.timer, color: kColorAccent),
                          SizedBox(width: 5.0),
                          Text(
                            time,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: kColorText,
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Spacer(),
                          Icon(Icons.new_releases_outlined,
                              color: kColorAccent),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(5.0, 0.0, 10.0, 0.0),
                            child: Text(
                              (gameController.numBombs -
                                      gameController.numFlags)
                                  .toString(),
                              style: TextStyle(
                                fontSize: 16.0,
                                color: kColorText,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              createBody(gameController),
            ],
          ),
        );
      },
    );
  }

  Column createCells() {
    List<Widget> rows = [];
    for (int i = 0; i < widget.height; i++) {
      List<CellWidget> cellWidgets = [];
      for (int j = 0; j < widget.width; j++) {
        cellWidgets.add(CellWidget(i, j));
      }
      rows.add(Row(children: cellWidgets));
    }
    return Column(children: rows);
  }

  Stream<int> stopWatchStream() {
    StreamController<int> streamController;
    Timer timer;
    Duration timerInterval = Duration(seconds: 1);
    int counter = 0;

    void stopTimer() {
      if (timer != null) {
        timer.cancel();
        timer = null;
        counter = 0;
        streamController.close();
      }
    }

    void tick(_) {
      counter++;
      streamController.add(counter);
      if (!timerFlag) {
        stopTimer();
      }
    }

    void startTimer() {
      timer = Timer.periodic(timerInterval, tick);
    }

    streamController = StreamController<int>(
      onListen: startTimer,
      onCancel: stopTimer,
      onResume: startTimer,
      onPause: stopTimer,
    );

    return streamController.stream;
  }

  Widget createBody(MinesweeperController gameController) {
    InteractiveViewer interactiveViewer = InteractiveViewer(
      transformationController: transformationController,
      boundaryMargin: const EdgeInsets.all(100.0),
      minScale: 0.1,
      maxScale: 1.4,
      constrained: false,
      child: createCells(),
    );

    return gameController.gameOver
        ? Expanded(
            child: Stack(
              children: [
                interactiveViewer,
                Opacity(
                  opacity: 0.9 * opacityController.value,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: kColorAccent,
                    child: Center(
                        child: Text(
                            gameController.gameWon ? 'You win!' : 'You lose!',
                            style: TextStyle(
                                fontSize: 20.0, color: kColorBackground))),
                  ),
                ),
              ],
            ),
          )
        : Expanded(child: interactiveViewer);
  }
}
