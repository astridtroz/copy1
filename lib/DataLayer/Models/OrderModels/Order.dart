import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '/DataLayer/Models/OrderModels/Item.dart';
import '/DataLayer/Models/StoreModels/Offer.dart';
import '../../../DataLayer/Models/OrderModels/Activity.dart';
import '../../../DataLayer/Models/OrderModels/Payment.dart';
import '../../../DataLayer/Models/OrderModels/Price.dart';
import '../../../DataLayer/Models/OrderModels/Review.dart';
import '../../../DataLayer/Models/Other/EnumToString.dart';
import '../../../DataLayer/Models/Other/Enums.dart';
import '../../../DataLayer/Models/Other/LatLngExtended.dart';
import '../../../DataLayer/Models/Other/StringToEnum.dart';
import '../../../DataLayer/Models/StoreModels/StoreAddress.dart';
import '../../../DataLayer/Models/UserModels/PhoneNumber.dart';
import '../../../DataLayer/Models/UserModels/UserAddress.dart';
import 'chats.dart';

class Order {
  /// Order related states
  String? orderId;
  Price? price;
  DateTime? orderPlacingDate;
  OrderStatus? orderStatus;
  List<Payment>? payments;
  DeliveryType? deliveryType;
  DateTime? pickupDateTimeRequested;
  DateTime? estimatedDeliveryDateTime;
  DateTime? actualDeliveryDateTime;
  DeliveryMode? deliveryMode;
  List<Activity>? auditTrail;
  int? numberOfClothes;
  Chats? chats;

  /// User related states
  String? userId;
  String? userName;
  LatLngExtended? userCoordinates;
  UserAddress? userAddress;
  PhoneNumber? userPhoneNumber;
  Review? userReview;
  String? fcmUser;

  /// Store related states
  String? storeId;
  String? storeName;
  LatLngExtended? storeCoordinates;
  StoreAddress? storeAddress;
  List<PhoneNumber>? storePhoneNumber;
  Review? storeReview;
  String? storeType;
  List<String>? fcmStore;

  List<String>? services;
  List<Item>? items;

  //==========Implicit Parameters==========//
  // These fields are neither fetched
  // nor pushed to the database. They are calculated
  // at runtime in the app.

  /// The distance between store address and user address
  double? distance;

  Order({
    this.orderId,
    this.price,
    required this.orderPlacingDate,
    required this.orderStatus,
    this.payments,
    this.deliveryType,
    this.pickupDateTimeRequested,
    this.estimatedDeliveryDateTime,
    this.actualDeliveryDateTime,
    this.numberOfClothes,
    this.deliveryMode,
    required this.userId,
    this.userName,
    required this.userCoordinates,
    required this.userAddress,
    required this.userPhoneNumber,
    this.userReview,
    required this.fcmUser,
    required this.fcmStore,
    required this.storeId,
    required this.storeName,
    this.storeCoordinates,
    required this.storeAddress,
    required this.storePhoneNumber,
    this.storeReview,
    required this.storeType,
    required this.services,
    this.auditTrail,
  });

  Order.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    // Store related
    this.fcmStore =
        List<String>.from(snapshot.data()!["fcmStore"] ?? ["Not-available"]);
    this.fcmUser = snapshot.data()!["fcmUser"] ?? "Not-available";
    this.storeType = snapshot.data()!["storeType"];
    this.storeName = snapshot.data()!["storeName"];
    this.storeId = snapshot.data()!["storeId"];
    this.storeAddress = StoreAddress.fromMap(snapshot.data()!["storeAddress"]);
    if (snapshot.data()!["storeCoordinates"] != null &&
        !snapshot.data()!["storeCoordinates"].isEmpty) {
      this.storeCoordinates =
          LatLngExtended.fromMap(snapshot.data()!["storeCoordinates"]);
    }
    // this.storeCoordinates = LatLngExtended(
    //     (snapshot.data["storeCoordinates"]["lat"]).toDouble(),
    //     (snapshot.data["storeCoordinates"]["lng"]).toDouble());
    storePhoneNumber = [];
    for (int i = 0; i < snapshot.data()!["storePhoneNumber"].length; i++) {
      storePhoneNumber
          ?.add(PhoneNumber.fromMap(snapshot.data()!["storePhoneNumber"][i]));
    }
    if (snapshot.data()!["storeReview"] != null &&
        !snapshot.data()!["storeReview"].isEmpty) {
      this.storeReview = Review.fromJson(snapshot.data()!["storeReview"]);
    }
    this.storeType = snapshot.data()!["storeType"];

    // User related
    if (snapshot.data()!["userReview"] != null &&
        !snapshot.data()!["userReview"].isEmpty) {
      this.userReview = Review.fromJson(snapshot.data()!["userReview"]);
    }
    this.userId = snapshot.data()!["userId"];
    this.userCoordinates =
        LatLngExtended.fromMap(snapshot.data()!["userCoordinates"]);
    // this.userCoordinates = LatLngExtended(
    //     (snapshot.data["userCoordinates"]["lat"]).toDouble(),
    //     (snapshot.data["userCoordinates"]["lng"]).toDouble());
    this.userName = snapshot.data()!["userName"];
    this.userAddress = UserAddress.fromMap(snapshot.data()!["userAddress"]);
    this.userPhoneNumber =
        PhoneNumber.fromMap(snapshot.data()!["userPhoneNumber"]);

    // Order related
    this.orderId = snapshot.data()!["orderId"];
    this.orderPlacingDate = (snapshot.data()!["orderPlacingDate"]).toDate();
    this.orderStatus =
        String2Enum.getOrderStatus(snapshot.data()!["orderStatus"]);
    this.deliveryType =
        String2Enum.getDeliveryType(snapshot.data()!["deliveryType"]);
    this.deliveryMode =
        String2Enum.getDeliveryMode(snapshot.data()!["deliveryMode"]);
    if (snapshot.data()!["pickupDateTimeRequested"] != null &&
        snapshot.data()!["pickupDateTimeRequested"].toString().isNotEmpty) {
      this.pickupDateTimeRequested =
          snapshot.data()!["pickupDateTimeRequested"].toDate();
    }
    if (snapshot.data()!["estimatedDeliveryDateTime"] != null &&
        snapshot.data()!["estimatedDeliveryDateTime"].toString().isNotEmpty) {
      this.pickupDateTimeRequested =
          snapshot.data()!["estimatedDeliveryDateTime"].toDate();
    }
    if (snapshot.data()!["actualDeliveryDateTime"] != null &&
        snapshot.data()!["actualDeliveryDateTime"].toString().isNotEmpty) {
      this.pickupDateTimeRequested =
          snapshot.data()!["actualDeliveryDateTime"].toDate();
    }
    this.numberOfClothes = snapshot.data()!["numberOfClothes"] ?? 0;
    // if (snapshot.data["price"] != null && !snapshot.data["price"].isEmpty) {
    //   this.price = Price.fromMap(snapshot.data["price"]);
    // }
    this.price = snapshot.data()!["price"] == null
        ? Price(
            servicesOpted: [],
            orderCharge: Map<String, double>(),
            netCharge: 0,
            taxes: 0,
            amountChargable: 0,
            deliveryCharge: 0,
            discount: 0,
            pietyCoins: 0,
            offer: Offer(
              description: "",
              isActive: false,
              maxDiscount: 0,
              minAmount: 0,
              offer: 0,
              offerCode: "null",
            ))
        : Price.fromMap(snapshot.data()!["price"], this.services!);
    auditTrail = [];
    for (int i = 0; i < snapshot.data()!["auditTrail"].length; i++) {
      auditTrail?.add(Activity.fromMap(snapshot.data()!["auditTrail"][i]));
    }
    payments = [];
    int _length = snapshot.data()!["payment"] == null
        ? 0
        : snapshot.data()!["payment"].length;
    for (int i = 0; i < _length; i++) {
      payments?.add(Payment.fromMap(snapshot.data()!["payment"][i]));
    }
    services = [];
    if (snapshot.data()!["services"] != null &&
        !snapshot.data()!["services"].isEmpty) {
      for (int i = 0; i < snapshot.data()!["services"].length; i++) {
        services?.add(snapshot.data()!["services"][i]);
      }
    }

    // Implicit fields
    if (this.userCoordinates != null && this.storeCoordinates != null) {
      this.distance = _calculateDistanceKM(userCoordinates!, storeCoordinates!);
    }
  }

  Map<String, dynamic> toJson(String orderID) {
    return {
      "orderId": orderID,
      "price": this.price?.toJson(),
      "orderPlacingDate": this.orderPlacingDate,
      "orderStatus": Enum2String.getOrderStatus(this.orderStatus!) ??
          Enum2String.getOrderStatus(OrderStatus.awaitingConfirmation),
      "payment": this.payments != null
          ? List<dynamic>.from(this.payments!.map((p) => p.toJson()))
          : null,
      "deliveryType": Enum2String.getDeliveryType(this.deliveryType!),
      "pickupDateTimeRequested": this.pickupDateTimeRequested,
      "estimatedDeliveryDateTime": this.estimatedDeliveryDateTime,
      "actualDeliveryDateTime": this.actualDeliveryDateTime,
      "deliveryMode": Enum2String.getDeliveryMode(this.deliveryMode!) ??
          Enum2String.getDeliveryMode(DeliveryMode.homeDelivery),
      "auditTrail": this.auditTrail != null
          ? List<dynamic>.from(this.auditTrail!.map((a) => a.toJson()))
          : null,
      "numberOfClothes": this.numberOfClothes ?? 1,
      "userId": this.userId,
      "userName": this.userName,
      "userCoordinates": this.userCoordinates?.toJson(),
      "userAddress": this.userAddress?.toJson(),
      "userPhoneNumber": this.userPhoneNumber?.toJson(),
      "userReview": this.userReview?.toJson(),
      "fcmUser": this.fcmUser,
      "fcmStore": List<String>.from(this.fcmStore!),
      "storeId": this.storeId,
      "storeName": this.storeName,
      "storeCoordinates": this.storeCoordinates?.toJson(),
      "storeAddress": this.storeAddress?.toJson(),
      "storePhoneNumber": this.storePhoneNumber != null
          ? List<dynamic>.from(this.storePhoneNumber!.map((p) => p.toJson()))
          : null,
      "storeReview": this.storeReview?.toJson(),
      "storeType": this.storeType,
      "services":
          this.services != null ? List<dynamic>.from(this.services!) : null,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Order &&
          runtimeType == other.runtimeType &&
          orderId == other.orderId &&
          price == other.price &&
          orderPlacingDate == other.orderPlacingDate &&
          orderStatus == other.orderStatus &&
          payments == other.payments &&
          deliveryType == other.deliveryType &&
          pickupDateTimeRequested == other.pickupDateTimeRequested &&
          estimatedDeliveryDateTime == other.estimatedDeliveryDateTime &&
          actualDeliveryDateTime == other.actualDeliveryDateTime &&
          deliveryMode == other.deliveryMode &&
          auditTrail == other.auditTrail &&
          numberOfClothes == other.numberOfClothes &&
          chats == other.chats &&
          userId == other.userId &&
          userName == other.userName &&
          userCoordinates == other.userCoordinates &&
          userAddress == other.userAddress &&
          userPhoneNumber == other.userPhoneNumber &&
          userReview == other.userReview &&
          fcmUser == other.fcmUser &&
          fcmStore == other.fcmStore &&
          storeId == other.storeId &&
          storeName == other.storeName &&
          storeCoordinates == other.storeCoordinates &&
          storeAddress == other.storeAddress &&
          storePhoneNumber == other.storePhoneNumber &&
          storeReview == other.storeReview &&
          storeType == other.storeType &&
          services == other.services &&
          items == other.items &&
          distance == other.distance;

  @override
  int get hashCode =>
      orderId.hashCode ^
      price.hashCode ^
      orderPlacingDate.hashCode ^
      orderStatus.hashCode ^
      payments.hashCode ^
      deliveryType.hashCode ^
      pickupDateTimeRequested.hashCode ^
      estimatedDeliveryDateTime.hashCode ^
      actualDeliveryDateTime.hashCode ^
      deliveryMode.hashCode ^
      auditTrail.hashCode ^
      numberOfClothes.hashCode ^
      chats.hashCode ^
      userId.hashCode ^
      userName.hashCode ^
      userCoordinates.hashCode ^
      userAddress.hashCode ^
      userPhoneNumber.hashCode ^
      userReview.hashCode ^
      fcmUser.hashCode ^
      fcmStore.hashCode ^
      storeId.hashCode ^
      storeName.hashCode ^
      storeCoordinates.hashCode ^
      storeAddress.hashCode ^
      storePhoneNumber.hashCode ^
      storeReview.hashCode ^
      storeType.hashCode ^
      services.hashCode ^
      items.hashCode ^
      distance.hashCode;

  @override
  String toString() {
    return '''Order{
         orderId: $orderId,
         price: $price,
         orderPlacingDate: $orderPlacingDate,
         orderStatus: $orderStatus,
         payment: $payments,
         deliveryType: $deliveryType,
         pickupDateTimeRequested: $pickupDateTimeRequested,
         estimatedDeliveryDateTime: $estimatedDeliveryDateTime,
         actualDeliveryDateTime: $actualDeliveryDateTime,
         deliveryMode: $deliveryMode,
         auditTrail: $auditTrail,
         numberOfClothes: $numberOfClothes,
         userId: $userId,
         userName: $userName,
         userCoordinates: $userCoordinates,
         userAddress: $userAddress,
         userPhoneNumber: $userPhoneNumber,
         userReview: $userReview,
         storeId: $storeId,
         storeName: $storeName,
         storeCoordinates: $storeCoordinates,
         storeAddress: $storeAddress,
         storePhoneNumber: $storePhoneNumber,
         storeReview: $storeReview,
         storeType: $storeType,
         items: $services
     }''';
  }

  double _calculateDistanceKM(
      LatLngExtended userCoords, LatLngExtended storeCoords) {
    const double r = 6371; // Radius of the earth in km
    var latitudeDiff = _deg2rad(storeCoords.latitude - userCoords.latitude);
    var longitudeDiff = _deg2rad(storeCoords.longitude - userCoords.longitude);
    var a = sin(latitudeDiff / 2) * sin(latitudeDiff / 2) +
        cos(_deg2rad(userCoords.latitude)) *
            cos(_deg2rad(storeCoords.latitude)) *
            sin(longitudeDiff / 2) *
            sin(longitudeDiff / 2);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));
    var distance = r * c; // Distance in km
    return distance;
  }

  double _deg2rad(double deg) {
    return deg * (3.14159 / 180);
  }
}

/// Dummy Data
// List<Order> orders = [
//   Order(
//     orderId: "1234-5678",
//     price: Price(
//       orderCharge: 450.0,
//       netCharge: 530.0,
//       deliveryCharge: 50.0,
//       taxes: 30.0,
//     ),
//     orderPlacingDate: DateTime.now(),
//     orderStatus: OrderStatus.orderPending,
//     payments: [
//       Payment(
//         paymentStatus: PaymentStatus.pending,
//         paymentMode: PaymentMode.cash,
//         amount: 530,
//       ),
//     ],
//     deliveryType: DeliveryType.regular,
//     pickupDateTimeRequested: DateTime(
//       DateTime.now().year,
//       DateTime.now().month,
//       DateTime.now().day + 2,
//     ),
//     estimatedDeliveryDateTime: DateTime(
//       DateTime.now().year,
//       DateTime.now().month,
//       DateTime.now().day + 2,
//     ),
//     actualDeliveryDateTime: DateTime(
//       DateTime.now().year,
//       DateTime.now().month,
//       DateTime.now().day + 2,
//     ),
//     deliveryMode: DeliveryMode.homeDelivery,
//     auditTrail: [
//       Activity(
//         activity: "Order Placed",
//         timeStamp: DateTime.now(),
//       ),
//     ],
//     numberOfClothes: 2,
//     userId: "AAA123456",
//     userName: "ABCDE",
//     userCoordinates: LatLngExtended(45.0, 55.0),
//     userAddress: UserAddress(
//       name: "ABCDE",
//       houseNo: "A11/12",
//       landmark: "Near Tower",
//       locality: "PQRS",
//       state: "Delhi",
//       addressType: AddressType.home,
//     ),
//     userPhoneNumber: PhoneNumber(number: "9876543210", countryCode: "+91"),
//     userReview: Review(
//       rating: 5,
//       dateTime: DateTime.now(),
//     ),
//     storeId: "A1A2A3A4",
//     storeName: "MNBVC",
//     storeCoordinates: LatLngExtended(55.0, 55.0),
//     storeAddress: StoreAddress(
//       storeNo: "A11/12",
//       landmark: "Near Tower B",
//       locality: "PQRSTUV",
//       state: "Delhi",
//       city: "New Delhi",
//     ),
//     storePhoneNumber: [
//       PhoneNumber(number: "9876543210", countryCode: "+91"),
//     ],
//     storeReview: Review(
//       rating: 5,
//       dateTime: DateTime.now(),
//     ),
//     storeType: "Laundry",
//     services: [],
//   ),
// ];
