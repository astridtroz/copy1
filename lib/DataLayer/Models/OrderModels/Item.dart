import 'package:flutter/foundation.dart';

class Item {
  // String itemID;
  String? serviceAvailed;
  double? price;
  int? itemCount;

  Item({
    // @required this.itemID,
    required this.serviceAvailed,
    required this.price,
    required this.itemCount,
  });

  Item.fromMap(Map<String, dynamic> map) {
    this.serviceAvailed = map["serviceAvailed"];
    this.price = (map["price"]).toDouble();
    this.itemCount = map["itemCount"];
  }

  Map<String, dynamic> toJson() {
    return {
      "serviceAvailed": this.serviceAvailed,
      "price": this.price,
      "itemCount": this.itemCount,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Item &&
          runtimeType == other.runtimeType &&
          // itemID == other.itemID &&
          serviceAvailed == other.serviceAvailed &&
          price == other.price &&
          itemCount == other.itemCount;

  @override
  int get hashCode =>
      // itemID.hashCode ^
      serviceAvailed.hashCode ^ price.hashCode ^ itemCount.hashCode;

  @override
  String toString() {
    return '''Item{
        serviceAvailed: $serviceAvailed, 
        price: $price, 
        itemCount: $itemCount
      }''';
  }
}
