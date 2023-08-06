import 'package:flutter/foundation.dart';

class Activity {
  String? activity;
  String? additionalMessage;
  DateTime? timeStamp;

  Activity({
    required this.activity,
    required this.timeStamp,
    this.additionalMessage,
  });

  Activity.fromMap(Map<String, dynamic> map) {
    this.activity = map["activity"];
    this.timeStamp = (map["timeStamp"]).toDate();
    this.additionalMessage = map["additionalMessage"] ?? "";
  }

  Map<String, dynamic> toJson() {
    return {
      "activity": this.activity,
      "timeStamp": this.timeStamp,
      "additionalMessage": this.additionalMessage,
    };
  }

  @override
  String toString() {
    return '''Activity: $activity AT $timeStamp additionalMessage: $additionalMessage''';
  }
}

class Activities {
  static String orderPlaced = "orderPlaced";
  static String orderAccepted = "orderAccepted";
  static String orderRejected = "orderRejected";
  static String orderPending = "orderPending";

  /// For OrderStatus.onTheWay
  static String orderOutForCollecting = "orderOutForCollecting";
  static String orderInProcess = "orderInProcess";
  static String orderCleaned = "orderCleaned";
  static String orderOutForDelivery = "orderOutForDelivery";
  static String orderDelivered = "orderDelivered";
  static String orderCancelled = "orderCancelledByCustomer";
  static String storeReviewed = "storeReviewed";
  static String userReviewed = "userReviewed";
  static String paymentCompleted = "paymentCompleted";
  static String offerAppliedOnOrder = "offerAppliedOnOffer";
  static String orderPriceUpdated = "orderPriceUpdated";
  static String orderDeliveryChargeUpdated = "orderDeliveryChargeUpdated";
}
