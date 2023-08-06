import 'package:equatable/equatable.dart';

import '/DataLayer/Models/OrderModels/Activity.dart';
import '/DataLayer/Models/OrderModels/Payment.dart';
import '/DataLayer/Models/OrderModels/Price.dart';
import '/DataLayer/Models/OrderModels/Review.dart';
import '../DataLayer/Models/OrderModels/Order.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();
  @override
  List<Object> get props => [];
}

class GetAllNewOrders extends OrderEvent {
  final String UID;

  GetAllNewOrders({required this.UID});
}

class AwaitingOrdersFetch extends OrderEvent {
  final String userId;

  AwaitingOrdersFetch({required this.userId});
  @override
  List<Object> get props => [userId];
}

class CurrentOrderFetch extends OrderEvent {
  final String userId;

  CurrentOrderFetch({required this.userId});
  @override
  List<Object> get props => [userId];
}

class PastOrdersFetch extends OrderEvent {
  final String userId;

  PastOrdersFetch({required this.userId});
  @override
  List<Object> get props => [userId];
}

class CreateOrder extends OrderEvent {
  final Order order;
  CreateOrder({required this.order});
  @override
  List<Object> get props => [order];
}

class CancelOrder extends OrderEvent {
  final String orderUID;
  final Activity activity;
  CancelOrder({
    required this.orderUID,
    required this.activity,
  });
  @override
  List<Object> get props => [orderUID, activity];
}

class GetSelectedServices extends OrderEvent {
  final List<String> services;
  GetSelectedServices({required this.services});
  @override
  List<Object> get props => [services];
}

class ApplyOffer extends OrderEvent {
  final Price prices;
  final String orderId;
  final Activity activity;
  // final String offerCode;
  // final String userId;

  ApplyOffer({
    // @required this.userId,
    // @required this.offerCode,
    required this.orderId,
    required this.prices,
    required this.activity,
  });
}

class PaymentOrder extends OrderEvent {
  final String userId;
  final String orderId;
  final double amount;
  final Payment payment;

  PaymentOrder({
    required this.userId,
    required this.orderId,
    required this.amount,
    required this.payment,
  });
}

class ReviewOrder extends OrderEvent {
  final String userId;
  final String orderId;
  final Review newReview;
  final Review? oldReview;
  final Activity activity;
  final String storeId;

  ReviewOrder({
    required this.newReview,
    required this.orderId,
    required this.activity,
    required this.userId,
    this.oldReview,
    required this.storeId,
  });
}
