import 'package:flutter/material.dart';

class GenericOutlineButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final buttonColor;

  GenericOutlineButton({
    required this.onPressed,
    required this.text,
    this.buttonColor = const Color.fromRGBO(255, 64, 64, 1),
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      child: Text(
        text,
        style: TextStyle(
          color: buttonColor,
        ),
      ),

      // borderSide: BorderSide(
      //   color: buttonColor,
      // ),
      // shape: RoundedRectangleBorder(
      //   borderRadius: Constants.constBorderRadius,
      // ),
      onPressed: this.onPressed,
    );
  }
}
