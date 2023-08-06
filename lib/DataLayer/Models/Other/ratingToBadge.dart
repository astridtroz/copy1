import 'package:flutter/material.dart';

class RatingToBadge {
  static String getStoreCategory(double rating) {
    if (rating >= 4.0 && rating < 4.2) {
      return "Exclusive";
    } else if (rating >= 4.2 && rating < 4.5) {
      return "Popular";
    } else if (rating >= 4.5 && rating <= 5) {
      return "Trending";
    } else {
      return "";
    }
  }

  static Color badgeColor(double rating) {
    if (rating >= 4.0 && rating < 4.2) {
      return Colors.blue;
    } else if (rating >= 4.2 && rating < 4.5) {
      return Colors.green;
    } else if (rating >= 4.5 && rating <= 5) {
      return Colors.red;
    } else {
      return Colors.transparent;
    }
  }
}
