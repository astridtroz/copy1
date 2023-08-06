import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class StoreTime {
  int? hour;
  int? minute;
  DateTime? time;
  StoreTime({
    required this.hour,
    required this.minute,
  });
  timeToJson() {
    return {
      "hour": this.hour,
      "minute": this.minute,
    };
  }

  String dateTimeFormated() {
    return DateFormat("h:mma").format(DateTime.parse(
        "2000-01-01 ${this.hour}:${this.minute.toString().padLeft(2, '0')}:00Z"));
  }

  StoreTime.fromMap(Map<String, dynamic> map) {
    this.hour = map["hour"];
    this.minute = map["minute"];
  }

  @override
  String toString() {
    return '$hour:$minute';
  }
}
