// FLutter
import 'package:flutter/material.dart';
// Local
import 'package:minesweeper/helpers/constants.dart';
import 'package:minesweeper/components/rounded_button.dart';
import 'package:minesweeper/screens/minesweeper_screen.dart';

const List<String> difficulties = [
  "Beginner",
  "Easy",
  "Medium",
  "Hard",
  "Huge",
  "Insane"
];

const List<int> widths = [12, 7, 12, 18, 27, 18];

const List<int> heights = [22, 10, 21, 32, 48, 32];

const List<int> numBombs = [12, 10, 40, 100, 220, 150];

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
    return Scaffold(
      backgroundColor: kColorBackground,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.width * viewportFraction -
                2 * pagePadding,
            child: PageView.builder(
              // store this controller in a State to save the carousel scroll position
              controller: PageController(viewportFraction: viewportFraction),
              physics: BouncingScrollPhysics(),
              itemBuilder: (BuildContext context, int itemIndex) =>
                  _buildCarouselItem(context, itemIndex),
            ),
          ),
          SizedBox(height: 20.0),
          RoundedButton(
            title: "New Game",
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MineSweeperScreen(
                          width: widths[difficultyIndex],
                          height: heights[difficultyIndex],
                          numBombs: numBombs[difficultyIndex],
                        ))),
          )
        ],
      ),
    );
  }

  Widget _buildCarouselItem(BuildContext context, int itemIndex) {
    if (itemIndex > 5) return null;

    difficultyIndex = itemIndex;

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
            Text(
              difficulties[difficultyIndex],
              style: TextStyle(fontSize: 32.0, color: kColorBackground),
            ),
            SizedBox(height: 60.0),
            Text(
              "${widths[difficultyIndex]} × ${heights[difficultyIndex]}",
              style: TextStyle(fontSize: 22.0, color: kColorBackground),
            ),
            Text(
              "${numBombs[difficultyIndex]} mines",
              style: TextStyle(fontSize: 22.0, color: kColorBackground),
            ),
          ],
        ),
      ),
    );
  }
}
