// FLutter
import 'package:flutter/material.dart';
// Third party
import 'package:provider/provider.dart';
// Local
import 'package:minesweeper/helpers/constants.dart';
import 'package:minesweeper/components/rounded_button.dart';
import 'package:minesweeper/components/minesweeper_controller.dart';
import 'package:minesweeper/screens/minesweeper_screen.dart';

const List<String> difficulties = [
  'Beginner',
  'Easy',
  'Medium',
  'Hard',
  // 'Huge',
  'Insane'
];

List<IconData> difficultyIcons = [
  Icons.sentiment_very_satisfied_outlined,
  Icons.sentiment_satisfied_outlined,
  Icons.sentiment_neutral_outlined,
  Icons.sentiment_dissatisfied_outlined,
  Icons.sentiment_very_dissatisfied_outlined,
];

const List<int> widths = [12, 7, 12, 18, 18];

const List<int> heights = [22, 10, 21, 32, 32];

const List<int> numBombs = [12, 10, 40, 100, 150];

const double viewportFraction = 0.7;
const double pagePadding = 10.0;

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int difficultyIndex = 0;

  @override
  Widget build(BuildContext context) {
    double topBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: kColorBackground,
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              children: [
                SizedBox(height: topBarHeight + 50.0),
                Image.asset('assets/images/mine_white.png', height: 75.0),
                SizedBox(height: 10.0),
                Text('MINESWEEPER',
                    style: TextStyle(
                        fontSize: 28.0,
                        color: kColorText,
                        fontFamily: 'JuliusSansOne')),
                Spacer(),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              children: [
                SizedBox(
                  height: 100.0,
                  child: PageView.builder(
                    // store this controller in a State to save the carousel scroll position
                    controller:
                        PageController(viewportFraction: viewportFraction),
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int itemIndex) =>
                        _buildCarouselItem(context, itemIndex),
                    onPageChanged: (int pageIndex) {
                      difficultyIndex = pageIndex;
                    },
                  ),
                ),
                SizedBox(height: 20.0),
                RoundedButton(
                  title: 'New Game',
                  onPressed: () {
                    MinesweeperController gameController =
                        Provider.of<MinesweeperController>(context,
                            listen: false);
                    gameController.init(widths[difficultyIndex],
                        heights[difficultyIndex], numBombs[difficultyIndex]);
                    double screenWidth = MediaQuery.of(context).size.width;
                    double screenHeight = MediaQuery.of(context).size.height;

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MinesweeperScreen(
                                  width: widths[difficultyIndex],
                                  height: heights[difficultyIndex],
                                  numBombs: numBombs[difficultyIndex],
                                  emptyCellNearestCentreRow:
                                      gameController.emptyCellNearestCentreRow,
                                  emptyCellNearestCentreCol:
                                      gameController.emptyCellNearestCentreCol,
                                  topBarHeight: topBarHeight,
                                  screenWidth: screenWidth,
                                  screenHeight: screenHeight,
                                )));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselItem(BuildContext context, int itemIndex) {
    if (itemIndex > 4) return null;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: pagePadding),
      child: Container(
        decoration: BoxDecoration(
          color: kColorAccent,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              difficultyIcons[itemIndex],
              color: kColorBackground,
              size: 40.0,
            ),
            SizedBox(height: 10.0),
            Text(
              difficulties[itemIndex],
              style: TextStyle(fontSize: 18.0, color: kColorBackground),
            ),
          ],
        ),
      ),
    );
  }
}
