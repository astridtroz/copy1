import 'dart:ui';

import 'package:flutter/material.dart';

class ServiceChip extends StatelessWidget {
  final bool? isSelected;
  final String text;
  final String imageUrl;
  ServiceChip({
    Key? key,
    required this.text,
    required this.imageUrl,
    this.isSelected,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: isSelected!
                ? RadialGradient(colors: [Colors.black87, Colors.black54])
                : RadialGradient(colors: [Colors.black54, Colors.black12])),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isSelected! ? Colors.grey : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
