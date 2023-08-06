import 'package:flutter/foundation.dart';

class Review {
  String? message;
  DateTime? dateTime;
  int? rating;

  Review({
    this.message,
    required this.rating,
    required this.dateTime,
  }) : assert(rating! >= 1 && rating <= 5);

  @override
  String toString() {
    return 'Review{message: $message, dateTime: $dateTime, rating: $rating}';
  }

  Review.fromJson(Map<String, dynamic> data) {
    this.dateTime = data["dateTime"].toDate();
    this.rating = data["rating"];
    this.message = data["message"] ?? "";
  }

  Map<String, dynamic> toJson() {
    return {
      "message": this.message,
      "dateTime": this.dateTime,
      "rating": this.rating,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Review &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          dateTime == other.dateTime &&
          rating == other.rating;

  @override
  int get hashCode => message.hashCode ^ dateTime.hashCode ^ rating.hashCode;
}
