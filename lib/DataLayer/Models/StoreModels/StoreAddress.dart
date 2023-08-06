import 'package:flutter/foundation.dart';

class StoreAddress {
  String? storeNo;
  String? landmark;
  String? locality;
  String? city;
  String? state;

  StoreAddress({
    this.city,
    required this.storeNo,
    required this.landmark,
    required this.locality,
    required this.state,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoreAddress &&
          runtimeType == other.runtimeType &&
          storeNo == other.storeNo &&
          landmark == other.landmark &&
          locality == other.locality &&
          city == other.city &&
          state == other.state;

  @override
  int get hashCode =>
      storeNo.hashCode ^
      landmark.hashCode ^
      locality.hashCode ^
      city.hashCode ^
      state.hashCode;

  String getDisplayAddress() {
    return landmark!.isEmpty
        ? storeNo! + ", " + locality! + ", " + city! + ", " + state!
        : storeNo! +
            ", " +
            landmark! +
            ", " +
            locality! +
            ", " +
            city! +
            ", " +
            state!;
  }

  @override
  String toString() {
    return 'StoreAddress{storeNo: $storeNo, landmark: $landmark, city: $city, locality: $locality, state: $state}';
  }

  StoreAddress.fromMap(Map<String, dynamic> map) {
    this.city = map["city"] ?? "";
    this.storeNo = map["storeNo"] ?? "";
    this.landmark = map["landmark"] ?? "";
    this.locality = map["locality"] ?? "";
    this.state = map["state"] ?? "";
  }

  Map<String, dynamic> toJson() {
    return {
      "storeNo": this.storeNo,
      "landmark": this.landmark,
      "city": this.city,
      "locality": this.locality,
      "state": this.state,
    };
  }
}
