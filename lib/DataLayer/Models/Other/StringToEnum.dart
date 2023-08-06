import '/DataLayer/Models/Other/Enums.dart';

/// This class contains static methods for
/// converting strings to enums because they are fetched
/// from FirebaseFirestore as string but are handled as an enum
/// in the application.
///
/// The string convertion method has been chosen over
/// operating on index integers as a fail safe because
/// if in future a not so experienced programmer changed
/// the sequence of enums instead of appending to the bottom,
///  the results could be catastrophic.
class String2Enum {
  static DeliveryMode getDeliveryMode(String deliveryMode) {
    switch (deliveryMode) {
      case "selfPickup":
        return DeliveryMode.selfPickup;
      case "homeDelivery":
        return DeliveryMode.homeDelivery;
      default:
        return DeliveryMode.unknown;
    }
  }

  static RatelistType getRatelistType(String ratelistType) {
    switch (ratelistType) {
      case "withCategory":
        return RatelistType.withCategory;
      case "withoutCategory":
        return RatelistType.withoutCategory;
      default:
        return RatelistType.withCategory;
    }
  }

  static PaymentMode getPaymentMode(String paymentMode) {
    switch (paymentMode) {
      case "cash":
        return PaymentMode.cash;
      case "upi":
        return PaymentMode.upi;
      case "pietyCoins":
        return PaymentMode.pietyCoins;
      default:
        return PaymentMode.unknown;
    }
  }

  static PaymentStatus getPaymentStatus(String paymentStatus) {
    switch (paymentStatus) {
      case "paid":
        return PaymentStatus.paid;
      case "pending":
        return PaymentStatus.pending;
      case "failed":
        return PaymentStatus.failed;
      default:
        return PaymentStatus.unknown;
    }
  }

  static OrderStatus getOrderStatus(String orderStatus) {
    switch (orderStatus) {
      case "awaitingConfirmation":
        return OrderStatus.awaitingConfirmation;
      case "orderCancelled":
        return OrderStatus.orderCancelled;
      case "orderPending":
        return OrderStatus.orderPending;
      case "onTheWay":
        return OrderStatus.onTheWay;
      case "inProcess":
        return OrderStatus.inProcess;
      case "cleaned":
        return OrderStatus.cleaned;
      case "outForDelivery":
        return OrderStatus.outForDelivery;
      case "delivered":
        return OrderStatus.delivered;
      default:
        return OrderStatus.unknown;
    }
  }

  static DeliveryType getDeliveryType(String deliveryType) {
    switch (deliveryType) {
      case "regular":
        return DeliveryType.regular;
      case "express":
        return DeliveryType.express;
      default:
        return DeliveryType.unknown;
    }
  }

  static AddressType getAddressType(String addressType) {
    switch (addressType) {
      case "work":
        return AddressType.work;
      case "home":
        return AddressType.home;
      case "other":
        return AddressType.other;
      default:
        return AddressType.unknown;
    }
  }

  static ServiceType getServiceType(String serviceType) {
    switch (serviceType) {
      case "laundry":
        return ServiceType.laundry;
      default:
        return ServiceType.unknown;
    }
  }

  static UserType getUserType(String userType) {
    switch (userType) {
      case "registered":
        return UserType.registered;
      default:
        return UserType.anonymous;
    }
  }

  /// Return the list of orderStatus enums which reflect
  /// that an order is currently in the ongoing state.
  /// This includes all current order states except
  /// for the `orderCancelled`, `awaitingConfirmation` and
  /// `delivered` enum.
  ///
  /// These are returned as list of enums of type
  /// [OrderStaus]. Currently they are of no use
  /// but it's appropriate to provide a corollary
  ///  method for the same method inside [EnumToString] class.
  static List<OrderStatus> ongoingOrderPossibilities() {
    return [
      String2Enum.getOrderStatus("orderPending"),
      String2Enum.getOrderStatus("onTheWay"),
      String2Enum.getOrderStatus("inProcess"),
      String2Enum.getOrderStatus("cleaned"),
      String2Enum.getOrderStatus("outForDelivery"),
    ];
  }

  static List<OrderStatus> finishedOrderPossibilities() {
    return [
      String2Enum.getOrderStatus("delivered"),
      String2Enum.getOrderStatus("orderCancelled"),
    ];
  }
}
