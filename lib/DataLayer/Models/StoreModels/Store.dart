import 'package:flutter/foundation.dart';

import '/DataLayer/Models/Other/EnumToString.dart';
import './StoreAddress.dart';
import '../../../DataLayer/Models/Other/Enums.dart';
import '../../../DataLayer/Models/Other/LatLngExtended.dart';
import '../../../DataLayer/Models/Other/StoreTime.dart';
import '../../../DataLayer/Models/StoreModels/Offer.dart';
import '../../../DataLayer/Models/UserModels/PhoneNumber.dart';

class Store {
  String? name;
  String? uid;
  Map<String, String>? fcmTokens;
  String? owner;
  double? rating;
  bool? isMainBranch;
  bool? isActive;
  bool? isOpen;
  StoreAddress? address;
  int? pincode;
  int? reviewCount;
  List<Offer>? offers;
  StoreTime? openingHour;
  StoreTime? closingHour;
  List<String>? services;
  int? customerCount;
  double? normalDeliveryCharge;
  double? expressDeliveryCharge;
  double? freeDeliveryAmount;
  double? minOrderAmount;
  double? normalDeliveryTime;
  double? expressDeliveryTime;
  double? selfDeliveryDistance;
  List<PhoneNumber>? phoneNumbers;
  String? exceptions;
  String? storeType;
  double? taxRate;
  LatLngExtended? storeCoordinates;
  List<String>? managers;
  String? storeLogo;
  List<String>? myGallery;
  double? minOrderServiceCharge;
//  List<Branch> branch;
  RatelistType? ratelistType;

  ///if true store allow us to feature there
  ///offers on homepage
  bool? featureOffer;

  // Implicit parameters
  Role? role;

  Store({
    required this.name,
    required this.uid,
    required this.owner,
    this.storeType,
    this.fcmTokens,
    required this.rating,
    this.isMainBranch,
    this.isActive,
    this.isOpen,
    this.address,
    this.pincode,
    this.offers,
    this.openingHour,
    this.closingHour,
    @required this.services,
    this.customerCount,
    this.phoneNumbers,
    this.role,
    this.exceptions,
    this.reviewCount,
//    this.branch,
    this.expressDeliveryCharge,
    this.expressDeliveryTime,
    this.freeDeliveryAmount,
    this.minOrderAmount,
    this.normalDeliveryCharge,
    this.normalDeliveryTime,
    this.selfDeliveryDistance,
    this.taxRate,
    @required this.storeCoordinates,
    @required this.managers,
    @required this.storeLogo,
    @required this.myGallery,
    this.minOrderServiceCharge,
    this.featureOffer,
    @required this.ratelistType,
  });

  Store.fromMap(Map<String, dynamic> data) {
    this.uid = data["storeId"];
    this.name = data["name"] ?? "";
    this.owner = data["owner"] ?? "";
    this.minOrderServiceCharge = data["minOrderServiceCharge"] != null
        ? data["minOrderServiceCharge"].toDouble()
        : 0.0;
    this.featureOffer = data["featureOffer"] ?? false;

    this.reviewCount = data["reviewCount"] ?? 10;
    this.isMainBranch = data["isMainBranch"] ?? false;
    this.isActive = data["isActive"] ?? false;
    this.isOpen = data["isOpen"] ?? false;
    this.address = StoreAddress.fromMap(data["address"]);
    this.pincode = data["pincode"] ?? 123456;
    this.offers = [];
    if (data["offers"] != null) {
      for (int i = 0; i < data["offers"].length; i++) {
        offers?.add(Offer.fromMap(data["offers"][i]));
      }
    }
    this.openingHour =
        (StoreTime.fromMap(data["openingHour"]) ?? "") as StoreTime?;
    this.closingHour =
        (StoreTime.fromMap(data["closingHour"]!) ?? "") as StoreTime?;
    this.storeType = data["storeType"];
    this.services = [];
    if (data["services"] != null) {
      for (int i = 0; i < data["services"].length; i++) {
        services?.add(data["services"][i]);
      }
    }
    this.customerCount = data["customerCount"] ?? 0;
    this.uid = data["storeId"] ?? null;
    this.expressDeliveryCharge =
        (data["expressDeliveryCharge"] ?? 0).toDouble() ?? 100.0;
    this.expressDeliveryTime =
        (data["expressDeliveryTime"] ?? 0).toDouble() ?? 10.0;
    this.freeDeliveryAmount =
        (data["freeDeliveryAmount"] ?? 0).toDouble() ?? 0.0;
    this.minOrderAmount = (data["minOrderAmount"] ?? 0).toDouble() ?? 0.0;
    this.normalDeliveryCharge =
        (data["normalDeliveryCharge"] ?? 0).toDouble() ?? 0.0;
    this.normalDeliveryTime =
        (data["normalDeliveryTime"] ?? 0).toDouble() ?? 0.0;
    this.selfDeliveryDistance = (data["selfDeliveryDistance"] ?? 10).toDouble();
    this.taxRate = (data["taxRate"] ?? 0).toDouble() ?? 0.0;
    this.rating = data["rating"]?.toDouble() ?? 0.0;
    this.phoneNumbers = [];
    for (int i = 0; i < data["phoneNumbers"].length; i++) {
      phoneNumbers?.add(PhoneNumber.fromMap(data["phoneNumbers"][i]));
    }
    this.storeCoordinates = data["storeCoordinates"] != null
        ? LatLngExtended.fromMap(data["storeCoordinates"])
        : null;
    this.managers = List<String>.from(data["managers"]);
    this.fcmTokens = Map<String, String>();
    this.managers?.forEach((String managerId) {
      this.fcmTokens?.putIfAbsent(managerId, () {
        return data["fcmTokens"] != null
            ? data["fcmTokens"][managerId]
            : "Not available";
      });
    });
    this.myGallery = [];
    if (data["myGallery"] != null) {
      for (var i = 0; i < data["myGallery"].length; i++) {
        myGallery?.add(data["myGallery"][i]);
      }
    }
    this.storeLogo = data["storeLogo"] != null ? data["storeLogo"] : null;
  }

  @override
  String toString() {
    return 'Store{name: $name, uid: $uid, fcmTokens: $fcmTokens, owner: $owner, rating: $rating, isMainBranch: $isMainBranch, isActive: $isActive, isOpen: $isOpen, address: $address, pincode: $pincode, offers: $offers, openingHour: $openingHour, closingHour: $closingHour, services: $services, customerCount: $customerCount, normalDeliveryCharge: $normalDeliveryCharge, expressDeliveryCharge: $expressDeliveryCharge, freeDeliveryAmount: $freeDeliveryAmount, minOrderAmount: $minOrderAmount, normalDeliveryTime: $normalDeliveryTime, expressDeliveryTime: $expressDeliveryTime, selfDeliveryDistance: $selfDeliveryDistance,  phoneNumbers: $phoneNumbers, exceptions: $exceptions, storeType: $storeType, taxRate: $taxRate, storeCoordinates: $storeCoordinates, managers: $managers, myGallery: $myGallery, role: $role}';
  }

  Map<String, dynamic> toJson() {
    return {
      "name": this.name,
      "storeId": this.uid,
      "featureOffer": this.featureOffer ?? false,
      "minOrderServiceCharge": this.minOrderServiceCharge,
      "storeType": this.storeType,
      "fcmTokens": Map<String, String>.from(this.fcmTokens!),
      "rating": this.rating,
      "isActive": this.isActive,
      "isOpen": this.isOpen,
      "address": this.address?.toJson(),
      "storeCoordinates": this.storeCoordinates?.toJson(),
      "pincode": this.pincode,
      "offers": List<dynamic>.from(this.offers!.map((o) => o.toJson())),
      // "subscription":
      //     List<dynamic>.from(this.subscription.map((o) => o.toJson())),
      "openingHour": this.openingHour?.timeToJson(),
      "closingHour": this.closingHour?.timeToJson(),
      "services": List<dynamic>.from(this.services!),
      "reviewCount": this.reviewCount,
      // "joiningDate": this.joiningDate,
      "phoneNumbers": List<dynamic>.from(
          this.phoneNumbers!.map((number) => number.toJson())),
      // "socialLink": this.socialLink.toJson(),
      "exceptions": this.exceptions,
      "expressDeliveryCharge": this.expressDeliveryCharge,
      "expressDeliveryTime": this.expressDeliveryTime,
      "freeDeliveryAmount": this.freeDeliveryAmount,
      "minOrderAmount": this.minOrderAmount,
      "normalDeliveryCharge": this.normalDeliveryCharge,
      "normalDeliveryTime": this.normalDeliveryTime,
      "selfDeliveryDistance": this.selfDeliveryDistance,
      "taxRate": this.taxRate,
      "managers": List<dynamic>.from(this.managers!),
      "ratelistType": Enum2String.getRatelistType(this.ratelistType!),
      // "myGallery": List<String>.from(this.myGallery),
    };
  }
}
