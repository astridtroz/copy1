import 'package:flutter/foundation.dart';

class ChatMessage {
  DateTime? dateTime;
  String? message;
  bool? isStore;
  bool? isself;

  ChatMessage({
    required this.dateTime,
    required this.message,
    required this.isStore,
  });

  ChatMessage.fromMap(Map<String, dynamic> map) {
    this.dateTime = map["dateTime"].toDate();
    this.message = map["message"];
    this.isStore = map["isStore"];
  }

  Map<String, dynamic> toJson() {
    return {
      "dateTime": this.dateTime,
      "message": this.message,
      "isStore": this.isStore,
    };
  }

  @override
  String toString() {
    return '''Chat{message: $message dateTime: $dateTime isStore: $isStore} ''';
  }
}
