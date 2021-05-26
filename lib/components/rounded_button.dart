// Flutter
import 'package:flutter/material.dart';
// Local
import 'package:minesweeper/helpers/constants.dart';

class RoundedButton extends StatelessWidget {
  final String title;
  final Function onPressed;
  final bool enabled;
  final EdgeInsets padding;

  RoundedButton(
      {this.title, this.onPressed, this.enabled = true, this.padding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          padding ?? EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(color: kColorText, width: 1.5),
          ),
          backgroundColor: kColorBackground,
        ),
        onPressed: enabled ? onPressed : null,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 70.0, vertical: 5.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 16.0, color: kColorText),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
