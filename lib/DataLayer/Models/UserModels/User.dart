import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../../DataLayer/Models/Other/Enums.dart';
import '../../../DataLayer/Models/UserModels/PhoneNumber.dart';
import '../../../DataLayer/Models/UserModels/UserAddress.dart';

class User2 {
  String? uid;
  String? name;
  String? fcmToken;
  List<PhoneNumber>? phoneNumbers;
  List<UserAddress>? addresses;
  double? rating;
  DateTime? joiningDate;
  String? referCode;
  int? orderCount;
  String? pietyCoinsRedeemed;
  String? pietyCoinsEarned;
  String? userType;
  String? referredBy;
  List<String>? referredTo;
  //storing list of Offer user has already used
  //List<String> appliedOffers;

  User2({
    required this.uid,
    this.fcmToken,
    this.name,
    this.phoneNumbers,
    this.addresses,
    this.rating,
    this.joiningDate,
    this.referCode,
    this.orderCount,
    this.pietyCoinsRedeemed,
    this.pietyCoinsEarned,
    this.userType,
    this.referredBy,
    this.referredTo,
    //this.appliedOffers,
  });

  toJson(String uid) {
    return {
      "uid": uid,
      "name": this.name ?? null,
      "addresses": this.addresses != null
          ? List<dynamic>.from(
              this.addresses!.map((address) => address.toJson()),
            )
          : null,
      "phoneNumbers": this.phoneNumbers != null
          ? List<dynamic>.from(
              this.phoneNumbers!.map((phoneNumbers) => phoneNumbers.toJson()))
          : null,
      "rating": this.rating ?? 4,
      "joiningDate": this.joiningDate ?? null,
      "referCode": this.referCode ?? null,
      "orderCount": this.orderCount,
      "pietyCoinsRedeemed": this.pietyCoinsRedeemed ?? null,
      "userType": this.userType.toString() ?? UserType.anonymous.toString(),
      "fcmToken": this.fcmToken,
      "referredBy": this.referredBy ?? null,
      "referredTo":
          this.referredTo != null ? List<dynamic>.from(this.referredTo!) : null,
      "pietyCoinsEarned": this.pietyCoinsEarned ?? null,
      // "appliedOffers": this.appliedOffers != null
      //     ? List<String>.from(this.appliedOffers)
      //     : [],
    };
  }

  User2.fromMap(Map<String, dynamic> map) {
    this.uid = map['uid'] ?? null;
    this.name = map['name'] ?? null;
    this.addresses = [];
    if (map["addresses"] != null) {
      for (int i = 0; i < map["addresses"].length; i++) {
        addresses?.add(UserAddress.fromMap(map["addresses"][i]));
      }
    }
    this.phoneNumbers = [];
    for (int i = 0; i < map["phoneNumbers"].length; i++) {
      phoneNumbers?.add(PhoneNumber(
          countryCode: map["phoneNumbers"][i]["countryCode"],
          number: map["phoneNumbers"][i]["number"]));
    }
    this.rating = map['rating'] ?? 4;
    this.joiningDate =
        (map["joiningDate"] ?? Timestamp.fromDate(DateTime.now())).toDate();
    this.referCode = map['referCode'] ?? null;
    this.orderCount = map['orderCount'];
    this.pietyCoinsRedeemed = map['pietyCoinsRedeemed'] ?? null;
    this.userType = map["userType"] ?? UserType.registered;
    this.fcmToken = map["fcmToken"] ?? null;
    this.referredBy = map["referredBy"] ?? null;
    this.referredTo = [];
    if (map["referredTo"] != null) {
      for (int i = 0; i < map["referredTo"].length; i++) {
        referredTo?.add(map["referredTo"][i]);
      }
    }
    this.pietyCoinsEarned = map["pietyCoinsEarned"] ?? null;
    // this.appliedOffers = List<String>();
    // if (map["appliedOffers"] != null) {
    //   for (var i = 0; i < map["appliedOffers"].length; i++) {
    //     appliedOffers.add(map["appliedOffers"][i]);
    //   }
    // }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User2 &&
          runtimeType == other.runtimeType &&
          uid == other.uid &&
          name == other.name &&
          fcmToken == other.fcmToken &&
          phoneNumbers == other.phoneNumbers &&
          addresses == other.addresses &&
          rating == other.rating &&
          joiningDate == other.joiningDate &&
          referCode == other.referCode &&
          orderCount == other.orderCount &&
          pietyCoinsRedeemed == other.pietyCoinsRedeemed &&
          pietyCoinsEarned == other.pietyCoinsEarned &&
          userType == other.userType &&
          referredBy == other.referredBy &&
          referredTo == other.referredTo;

  @override
  int get hashCode =>
      uid.hashCode ^
      name.hashCode ^
      fcmToken.hashCode ^
      phoneNumbers.hashCode ^
      addresses.hashCode ^
      rating.hashCode ^
      joiningDate.hashCode ^
      referCode.hashCode ^
      orderCount.hashCode ^
      pietyCoinsRedeemed.hashCode ^
      pietyCoinsEarned.hashCode ^
      userType.hashCode ^
      referredBy.hashCode ^
      referredTo.hashCode;

  @override
  String toString() {
    return 'User{uid: $uid, name: $name, fcmToken: $fcmToken, phoneNumbers: $phoneNumbers, addresses: $addresses, rating: $rating, joiningDate: $joiningDate, referCode: $referCode, orderCount: $orderCount, pietyCoinsRedeemed: $pietyCoinsRedeemed, pietyCoinsEarned: $pietyCoinsEarned, userType: $userType, referredBy: $referredBy, referredTo: $referredTo}';
  }
}
