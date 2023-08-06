import 'package:flutter/foundation.dart';

class AppFeedback {
  int rating;
  String userID;
  String reason;
  DateTime dateTime;

  AppFeedback({
    this.reason = "",
    required this.userID,
    required this.rating,
    required this.dateTime,
  });

  List<String> getReasons(int rating) {
    if (rating == 5) {
      return [
        "App has a good user interface",
        "App is easy to use",
        "App is bug free",
      ];
      //TODO: rating for 4,3 pending
    } else if (rating <= 2) {
      return [
        "App has a bad user interface",
        "App is not easy to use",
        "App is buggy",
      ];
    } else
      return [
        "Improve App",
      ];
  }
}
