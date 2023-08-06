import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart' as cloud;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

import '/DataLayer/Models/Other/EnumToString.dart';
import '/DataLayer/Models/Other/Enums.dart';
import './OrderEvent.dart';
import '../DataLayer/Models/OrderModels/Order.dart';

class OrderBloc extends Bloc {
  final databaseReference = cloud.FirebaseFirestore.instance;
  String orderCollection = "orders";

  List<String>? _selectedServices;
  List<String> get getSelectedServices => this._selectedServices!;

  Order? _newOrder;
  // List<Order> _allOrders = List<Order>();
  List<Order> _currentOrders = [];
  List<Order> _awaitingOrders = [];

  List<Order> get getAwaitingOrders => this._awaitingOrders;

  List<Order> get getCurrentOrders => this._currentOrders;

  // Order _currentOrder;

  List<Order> _pastOrders = [];

  // Order get getCurrentOrder => this._currentOrder;
  List<Order> get getPastOrders => this._pastOrders;

// Event controller
  StreamController<OrderEvent> _orderEventController =
      StreamController<OrderEvent>.broadcast();
  StreamSink<OrderEvent> get orderEventSink => _orderEventController.sink;
  Stream<OrderEvent> get _orderEventStream => _orderEventController.stream;

  // Event controller
  StreamController<Order> _createOrderController =
      StreamController<Order>.broadcast();
  StreamSink<Order> get createOrderSink => _createOrderController.sink;
  Stream<Order> get _createOrderStream => _createOrderController.stream;

  // All orders
  StreamController<List<Order>> _orderListController =
      StreamController<List<Order>>.broadcast();
  StreamSink<List<Order>> get _orderListSink => _orderListController.sink;
  Stream<List<Order>> get orderListStream => _orderListController.stream;

  // For awaiting orders only
  StreamController<List<Order>> _awaitingOrderController =
      StreamController<List<Order>>.broadcast();
  StreamSink<List<Order>> get _awaitingOrderSink =>
      _awaitingOrderController.sink;
  Stream<List<Order>> get awaitingOrderStream =>
      _awaitingOrderController.stream;

  // For current orders only
  StreamController<List<Order>> _currentOrderController =
      StreamController<List<Order>>.broadcast();
  StreamSink<List<Order>> get _currentOrderSink => _currentOrderController.sink;
  Stream<List<Order>> get currentOrderStream => _currentOrderController.stream;

  // For past orders only
  StreamController<List<Order>> _pastOrderListController =
      StreamController<List<Order>>.broadcast();
  StreamSink<List<Order>> get pastOrderListSink =>
      _pastOrderListController.sink;
  Stream<List<Order>> get pastOrderListStream =>
      _pastOrderListController.stream;

  StreamController<List<String>> _selectedServiceController =
      StreamController<List<String>>.broadcast();
  StreamSink<List<String>> get selectedServicesSink =>
      _selectedServiceController.sink;
  Stream<List<String>> get selectedServiceStream =>
      _selectedServiceController.stream;

  OrderBloc() {
    _orderEventStream.listen(mapEventToState);
  }

  void mapEventToState(OrderEvent event) async {
    if (event is CreateOrder) {
      print("Under Create Order");
      cloud.DocumentReference ref = await databaseReference
          .collection(orderCollection)
          .add({"orderId": ""});
      await databaseReference
          .collection(orderCollection)
          .doc(ref.id)
          .set(event.order.toJson(ref.id), cloud.SetOptions(merge: true))
          .then((value) => Fluttertoast.showToast(msg: "OrderPlaced 👍"));
      print("Create Event Triggered");
      _createOrderStream.listen((newOrder) {
        _newOrder = newOrder;
      });
    }

    if (event is AwaitingOrdersFetch) {
      cloud.FirebaseFirestore.instance
          .collection("orders")
          .where("userId", isEqualTo: "AAA123456")
          .where("orderStatus", isEqualTo: "awaitingConfirmation")
          .snapshots()
          .listen((cloud.QuerySnapshot snapshot) {
        // print("NewOrders: ${snapshot.documents[0].data}");
        int _length = snapshot.docs.length;
        print("Awaiting Orders = $_length");
        // print(snapshot.documents[1].data);
        List<Order> _awaitingOrder =
            []; // [] putted at the place of List<Order>(_length) while making it runnable
        for (int i = 0; i < _length; i++) {
          _awaitingOrder[i] = Order.fromSnapshot(snapshot.docs[i]);
        }
        _awaitingOrderSink.add(_awaitingOrder);
      });
    }

    if (event is CurrentOrderFetch) {
      cloud.FirebaseFirestore.instance
          .collection("orders")
          .where("userId", isEqualTo: event.userId)
          .where("orderStatus",
              whereIn: Enum2String.ongoingOrderPossibilities())
          .snapshots()
          .listen((cloud.QuerySnapshot snapshot) {
        _currentOrders = [];
        for (int i = 0; i < snapshot.docs.length; i++) {
          _currentOrders.add(Order.fromSnapshot(snapshot.docs[i]));
        }
        _currentOrderSink.add(_currentOrders);
        // List<Order> _currentOrder = List<Order>(_length);
        // for (int i = 0; i < _length; i++) {
        //   _currentOrder[i] = Order.fromSnapshot(snapshot.docs[i]);
        // }
        // _currentOrderSink.add(_currentOrder);
      });
    }
    if (event is PastOrdersFetch) {
      cloud.FirebaseFirestore.instance
          .collection("orders")
          .where("userId", isEqualTo: event.userId)
          .where("orderStatus", isEqualTo: "delivered")
          .snapshots()
          .listen((cloud.QuerySnapshot snapshot) {
        int _length = snapshot.docs.length;
        print("L = $_length");
        _pastOrders = [];
        for (int i = 0; i < snapshot.docs.length; i++) {
          _pastOrders.add(Order.fromSnapshot(snapshot.docs[i]));
        }
        pastOrderListSink.add(_pastOrders);
        // List<Order> _pastOrders = List<Order>(_length);
        // for (int i = 0; i < _length; i++) {
        //   _pastOrders[i] = Order.fromSnapshot(snapshot.docs[i]);
        // }
        // pastOrderListSink.add(_pastOrders);
      });
    }
    if (event is ApplyOffer) {
      // print("InSide appluOffer::");
      // print(event.prices.toJson());
      cloud.FirebaseFirestore.instance
          .collection("orders")
          .doc(event.orderId)
          .set({
        "price": event.prices.toJson(),
        "auditTrail": cloud.FieldValue.arrayUnion([event.activity.toJson()]),
      }, cloud.SetOptions(merge: true)).then((value) => Fluttertoast.showToast(
              msg: "Offer Applied", toastLength: Toast.LENGTH_SHORT));
    }
    if (event is ReviewOrder) {
      cloud.FirebaseFirestore.instance
          .collection("orders")
          .doc(event.orderId)
          .update({
        "userReview": event.newReview.toJson(),
      });
    }
    if (event is PaymentOrder) {
      cloud.FirebaseFirestore.instance
          .collection("orders")
          .doc(event.orderId)
          .set(
              {
            "payment": cloud.FieldValue.arrayUnion([event.payment.toJson()]),
          },
              cloud.SetOptions(
                merge: true,
              ));
    }
    if (event is CancelOrder) {
      cloud.FirebaseFirestore.instance
          .collection("orders")
          .doc(event.orderUID)
          .update({
        "orderStatus": Enum2String.getOrderStatus(OrderStatus.orderCancelled),
        "auditTrail": cloud.FieldValue.arrayUnion([event.activity.toJson()]),
      }).then((onValue) {
        print("OrderCanceled: ${event.orderUID}");
      });
    }
    if (event is GetSelectedServices) {
      selectedServiceStream.listen((services) {
        _selectedServices = services;
        print(services.toString());
        print("Internal Services : ${_selectedServices.toString()}");
      });
    }
  }

  // void _fetchOrders() {
  //   FirebaseFirebaseFirestore.instance
  //       .collection("orders")
  //       .where("userId", isEqualTo: "AAA123456")
  //       .limit(300)
  //       .snapshots()
  //       .listen((QuerySnapshot snapshot) {
  //     _allOrders = List<Order>();
  //     _currentOrders = List<Order>();
  //     _pastOrders = List<Order>();
  //     _awaitingOrders = List<Order>();

  //     print("Data: ${snapshot.docs[0].data}");
  //     for (int i = 0; i < snapshot.docs.length; i++) {
  //       _allOrders.add(Order.fromSnapshot(snapshot.docs[i]));

  //       if ((_allOrders[i].orderStatus != OrderStatus.awaitingConfirmation) &&
  //           (_allOrders[i].orderStatus != OrderStatus.orderCancelled) &&
  //           (_allOrders[i].orderStatus != OrderStatus.delivered)) {
  //         _currentOrders.add(_allOrders[i]);
  //       }
  //       if (_allOrders[i].orderStatus == OrderStatus.awaitingConfirmation) {
  //         _awaitingOrders.add(_allOrders[i]);
  //       }

  //       if (_allOrders[i].orderStatus == OrderStatus.delivered) {
  //         _pastOrders.add(_allOrders[i]);
  //       }
  //     }

  //     _currentOrderSink.add(_currentOrders);
  //     pastOrderListSink.add(_pastOrders);
  //   });
  // }

  @override
  void dispose() {
    _orderEventController.close();
    _orderListController.close();
    _awaitingOrderController.close();
    _createOrderController.close();
    _currentOrderController.close();
    _pastOrderListController.close();
    _selectedServiceController.close();
  }
}
