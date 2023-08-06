import 'package:flutter/foundation.dart';

class Offer {
  String? offerCode;
  String? description;
  double? minAmount;
  double? maxDiscount;
  double? offer;
  bool? isActive;

  Offer({
    required this.isActive,
    this.description,
    required this.maxDiscount,
    required this.minAmount,
    required this.offer,
    required this.offerCode,
  });

  Offer.fromMap(Map<String, dynamic> map) {
    // print("offer.dart map: $map");
    this.offerCode = map == null ? "" : map["offerCode"];
    this.description = map == null ? "" : map["description"];
    this.minAmount = map == null ? 0.toDouble() : map["minAmount"].toDouble();
    this.maxDiscount =
        map == null ? 0.toDouble() : map["maxDiscount"].toDouble();
    this.offer = map == null ? 0.toDouble() : map["offer"].toDouble();
    this.isActive = map == null ? false : map["isActive"];
  }

  Map<String, dynamic> toJson() {
    return {
      "offerCode": this.offerCode,
      "description": this.description,
      "minAmount": this.minAmount,
      "maxDiscount": this.maxDiscount,
      "offer": this.offer,
      "isActive": this.isActive,
    };
  }

  @override
  String toString() {
    return '''Offer{
      offerCode: $offerCode, 
      minAmount: $minAmount, 
      maxDiscount: $maxDiscount, 
      offer: $offer, 
      description: $description,
      isActive: $isActive
    }''';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Offer &&
          runtimeType == other.runtimeType &&
          offerCode == other.offerCode &&
          description == other.description &&
          minAmount == other.minAmount &&
          maxDiscount == other.maxDiscount &&
          offer == other.offer &&
          isActive == other.isActive;

  @override
  int get hashCode =>
      offerCode.hashCode ^
      description.hashCode ^
      minAmount.hashCode ^
      maxDiscount.hashCode ^
      offer.hashCode ^
      isActive.hashCode;
}
