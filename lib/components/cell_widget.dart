// Flutter
import 'package:flutter/material.dart';
// Local
import 'package:minesweeper/components/cell_controller.dart';

class CellWidget extends StatefulWidget {
  final CellController controller;

  CellWidget({this.controller});

  @override
  _CellWidgetState createState() => _CellWidgetState();
}

class _CellWidgetState extends State<CellWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.controller.reveal();
        });
      },
      child: Container(
        width: 40,
        height: 40,
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(4),
          child: Container(
            color:
                widget.controller.isRevealed ? Colors.white : Colors.grey[800],
            child: widget.controller.isRevealed
                ? Center(
                    child: widget.controller.isBomb
                        ? Icon(Icons.whatshot)
                        : Text('${widget.controller.numSurroundingBombs}'))
                : null,
          ),
        ),
      ),
    );
  }
}
