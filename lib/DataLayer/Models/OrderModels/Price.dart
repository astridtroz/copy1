import 'package:flutter/foundation.dart';

import '../../../DataLayer/Models/StoreModels/Offer.dart';

class Price {
  /// The service wise charge for order items
  Map<String, double>? orderCharge;

  /// The list of services selected by the customer
  List<String>? servicesOpted;

  /// The netcharge = orderCharge - offerDiscount. Does not include taxes
  double? netCharge;

  /// delivery Charges for the current order
  double? deliveryCharge;

  /// The taxes charged for the current order
  double? taxes;

  /// The offer, if any. Applied on the current order
  Offer? offer;

  /// Piety coins 🤷
  double? pietyCoins;

  /// The amount of discount given on this order
  double? discount;

  /// The final amount chargable by store to the customer. Includes
  /// orderCharge and taxes minus discounts if applicable
  double? amountChargable;

  Price({
    required this.servicesOpted,
    required this.amountChargable,
    required this.orderCharge,
    required this.netCharge,
    this.deliveryCharge = 0,
    required this.taxes,
    this.discount,
    this.offer,
    this.pietyCoins = 0,
  });

  Price.fromMap(Map<String, dynamic> map, List<String> services) {
    // print("price.dart map: $map");
    if (map != null) {
      this.servicesOpted = services;
      this.orderCharge = Map<String, double>();
      this.servicesOpted?.forEach((s) {
        orderCharge?.putIfAbsent(s, () {
          // print("price.dart: ${s.name} : ${map["orderCharge"][s.name]}");
          if (map["orderCharge"] == null) {
            return 0;
          } else {
            return (map["orderCharge"][s] ?? 0).toDouble();
          }
        });
      });
      this.netCharge = (map["netCharge"] ?? 0).toDouble();
      this.deliveryCharge = (map["deliveryCharge"] ?? 0).toDouble();
      this.amountChargable = (map["amountChargable"] ?? 0).toDouble();
      this.taxes = (map["taxes"] ?? 0).toDouble();
      this.offer = map["offer"] == null
          ? Offer(
              isActive: false,
              maxDiscount: 0,
              minAmount: 0,
              offer: 0,
              offerCode: "NA",
              description: "NA",
            )
          : Offer.fromMap(map["offer"]);
      this.pietyCoins = (map["pietyCoins"] ?? 0).toDouble();
      this.discount = (map["discount"] ?? 0).toDouble();
      // print("price.dart json: ${this.toJson()}");
    }
  }

  Map<String, dynamic> toJson() {
    return {
      // "orderCharge": {
      //   for (String key in this.orderCharge.keys) key: this.orderCharge[key],
      // },
      "orderCharge": this.orderCharge != null
          ? {
              for (String key in this.orderCharge!.keys)
                key: this.orderCharge![key],
            }
          : null,
      "netCharge": this.netCharge,
      "deliveryCharge": this.deliveryCharge,
      "taxes": this.taxes,
      "offer": this.offer != null ? this.offer?.toJson() : null,
      "pietyCoins": this.pietyCoins,
      "discount": this.discount,
      "amountChargable": this.amountChargable,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Price &&
          runtimeType == other.runtimeType &&
          orderCharge == other.orderCharge &&
          netCharge == other.netCharge &&
          deliveryCharge == other.deliveryCharge &&
          taxes == other.taxes &&
          offer == other.offer &&
          pietyCoins == other.pietyCoins &&
          discount == other.discount &&
          amountChargable == other.amountChargable;

  @override
  int get hashCode =>
      orderCharge.hashCode ^
      netCharge.hashCode ^
      deliveryCharge.hashCode ^
      taxes.hashCode ^
      offer.hashCode ^
      pietyCoins.hashCode ^
      amountChargable.hashCode ^
      discount.hashCode;

  @override
  String toString() {
    return '''Price{
        orderCharge: $orderCharge, 
        netCharge: $netCharge, 
        deliveryCharge: $deliveryCharge, 
        taxes: $taxes, offer: $offer, 
        pietyCoins: $pietyCoins, 
        discount: $discount,
        offer: ${offer?.offer}%,
        amountChargable: $amountChargable,
      }''';
  }
}
