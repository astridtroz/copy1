import '/DataLayer/Models/Other/Enums.dart';

/// This class contains static methods for
/// converting enums to string because they are pushed
/// to FirebaseFirebaseFirestore as string.
///
/// The string convertion method has been chosen over
/// operating on index integers as a fail safe because
/// if in future a not so experienced programmer changed
/// the sequence of enums instead of appending to the bottom,
///  the results could be catastrophic.
class Enum2String {
  static String getDeliveryMode(DeliveryMode deliveryMode) {
    switch (deliveryMode) {
      case DeliveryMode.selfPickup:
        return "selfPickup";
      case DeliveryMode.homeDelivery:
        return "homeDelivery";
      default:
        return "unknown";
    }
  }

  static String getRatelistType(RatelistType ratelistType) {
    switch (ratelistType) {
      case RatelistType.withCategory:
        return "withCategory";
      case RatelistType.withoutCategory:
        return "withoutCategory";
      default:
        return "withCategory";
    }
  }

  static String getPaymentMode(PaymentMode paymentMode) {
    switch (paymentMode) {
      case PaymentMode.cash:
        return "cash";
      case PaymentMode.upi:
        return "upi";
      case PaymentMode.pietyCoins:
        return "pietyCoins";
      default:
        return "unknown";
    }
  }

  static String getPaymentStatus(PaymentStatus paymentStatus) {
    switch (paymentStatus) {
      case PaymentStatus.paid:
        return "paid";
      case PaymentStatus.pending:
        return "pending";
      case PaymentStatus.failed:
        return "failed";
      default:
        return "unknown";
    }
  }

  static String getOrderStatus(OrderStatus orderStatus) {
    switch (orderStatus) {
      case OrderStatus.awaitingConfirmation:
        return "awaitingConfirmation";
      case OrderStatus.orderCancelled:
        return "orderCancelled";
      case OrderStatus.orderPending:
        return "orderPending";
      case OrderStatus.onTheWay:
        return "onTheWay";
      case OrderStatus.inProcess:
        return "inProcess";
      case OrderStatus.cleaned:
        return "cleaned";
      case OrderStatus.outForDelivery:
        return "outForDelivery";
      case OrderStatus.delivered:
        return "delivered";
      default:
        return "unknown";
    }
  }

  static String getDeliveryType(DeliveryType deliveryType) {
    switch (deliveryType) {
      case DeliveryType.regular:
        return "regular";
      case DeliveryType.express:
        return "express";
      default:
        return "unknown";
    }
  }

  static String getAddressType(AddressType addressType) {
    switch (addressType) {
      case AddressType.work:
        return "work";
      case AddressType.home:
        return "home";
      case AddressType.other:
        return "other";
      default:
        return "unknown";
    }
  }

  static String getServiceType(ServiceType serviceType) {
    switch (serviceType) {
      case ServiceType.laundry:
        return "laundry";
      default:
        return "unknown";
    }
  }

  static String getUserType(UserType userType) {
    switch (userType) {
      case UserType.registered:
        return "registered";
      default:
        return "anonymous";
    }
  }

  /// Return the list of orderStatus enums which reflect
  /// that an order is currently in the ongoing state.
  /// This includes all current order states except
  /// for the `orderCancelled`, `awaitingConfirmation` and
  /// `delivered` enum.
  ///
  /// These enums are returned as a
  /// string to be used inside `whereIn` query field in
  /// FirebaseFirestore to get all the ongoing orders.
  static List<String> ongoingOrderPossibilities() {
    return [
      Enum2String.getOrderStatus(OrderStatus.outForDelivery),
      Enum2String.getOrderStatus(OrderStatus.cleaned),
      Enum2String.getOrderStatus(OrderStatus.inProcess),
      Enum2String.getOrderStatus(OrderStatus.onTheWay),
      Enum2String.getOrderStatus(OrderStatus.orderPending),
    ];
  }

  static List<String> finishedOrderPossibilities() {
    return [
      Enum2String.getOrderStatus(OrderStatus.delivered),
      Enum2String.getOrderStatus(OrderStatus.orderCancelled),
    ];
  }
}
