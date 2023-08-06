import 'package:flutter/foundation.dart';

import '../../../DataLayer/Models/Other/EnumToString.dart';
import '../../../DataLayer/Models/Other/Enums.dart';
import '../../../DataLayer/Models/Other/StringToEnum.dart';

class UserAddress {
  String? name;
  String? houseNo;
  String? landmark;
  String? locality;
  String? city;
  String? state;
  String? postalCode;
  AddressType? addressType;

  UserAddress({
    this.city,
    required this.houseNo,
    required this.landmark,
    required this.locality,
    this.addressType,
    this.name,
    this.state,
    this.postalCode,
  });

  @deprecated
  String getPipedAddress() {
    return landmark!.isEmpty
        ? houseNo! + "|" + locality! + "|" + city! + "|"
        : houseNo! + "|" + landmark! + "|" + locality! + "|" + city! + "|";
  }

  UserAddress.fromMap(Map<String, dynamic> map) {
    this.name = map["name"] ?? "";
    this.houseNo = map["houseNo"] ?? "";
    this.landmark = map["landmark"] ?? "";
    this.locality = map["locality"] ?? "";
    this.city = map["city"] ?? "";
    this.state = map["state"] ?? "";
    this.postalCode = map["postalCode"];
    this.addressType = String2Enum.getAddressType(map["addressType"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "name": this.name,
      "houseNo": this.houseNo,
      "landmark": this.landmark,
      "city": this.city,
      "locality": this.locality,
      "state": this.state,
      "postalCode": this.postalCode,
      "addressType": Enum2String.getAddressType(this.addressType!),
    };
  }

  @override
  String toString() {
    return 'UserAddress{name: $name, houseNo: $houseNo, landmark: $landmark, locality: $locality, city: $city, state: $state, postalCode: $postalCode, addressType: $addressType}';
  }

  String profileAddress() {
    return "$name\n$houseNo,\n$locality, $city, $state\n$postalCode";
  }

  String displayAddress() {
    return "$locality, $city, $postalCode";
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAddress &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          houseNo == other.houseNo &&
          landmark == other.landmark &&
          locality == other.locality &&
          city == other.city &&
          state == other.state &&
          postalCode == other.postalCode;

  @override
  int get hashCode =>
      name.hashCode ^
      houseNo.hashCode ^
      landmark.hashCode ^
      locality.hashCode ^
      city.hashCode ^
      state.hashCode ^
      postalCode.hashCode ^
      addressType.hashCode;
}
