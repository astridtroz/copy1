import 'package:flutter/material.dart';

import '/const.dart';

class GenericMaterialButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  GenericMaterialButton({
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w400,
        ),
      ),
      color: Color.fromRGBO(81, 180, 71, 1),
      shape: RoundedRectangleBorder(
        borderRadius: Constants.constBorderRadius,
      ),
      onPressed: onPressed,
    );
  }
}
