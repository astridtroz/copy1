//import 'package:flutter/foundation.dart';
//
//class Service {
//  String serviceAvailed;
//  double price;
//  int itemCount;
//
//  Service({
//    @required this.serviceAvailed,
//    @required this.price,
//    @required this.itemCount,
//  });
//
//  Service.fromMap(Map<String, dynamic> map) {
//    this.serviceAvailed = map["serviceAvailed"];
//    this.price = (map["price"] ?? 0).toDouble();
//    this.itemCount = map["itemCount"];
//  }
//
//  Map<String, dynamic> toJson() {
//    return {
//      "serviceAvailed": this.serviceAvailed,
//      "price": this.price,
//      "itemCount": this.itemCount,
//    };
//  }
//
//  @override
//  bool operator ==(Object other) =>
//      identical(this, other) ||
//      other is Service &&
//          runtimeType == other.runtimeType &&
//          // itemID == other.itemID &&
//          serviceAvailed == other.serviceAvailed &&
//          price == other.price &&
//          itemCount == other.itemCount;
//
//  @override
//  int get hashCode =>
//      // itemID.hashCode ^
//      serviceAvailed.hashCode ^ price.hashCode ^ itemCount.hashCode;
//
//  @override
//  String toString() {
//    return '''Item{
//        serviceAvailed: $serviceAvailed,
//        price: $price,
//        itemCount: $itemCount
//      }''';
//  }
//}
