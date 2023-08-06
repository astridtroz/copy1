import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '/BloCLayer/AdminBloc.dart';
import '/BloCLayer/OrderBloc.dart';
import '/BloCLayer/OrderEvent.dart';
import '/BloCLayer/StoreBloc.dart';
import '/BloCLayer/StoreEvent.dart';
import '/DataLayer/Models/OrderModels/Activity.dart';
import '/DataLayer/Models/OrderModels/Order.dart';
import '/DataLayer/Models/OrderModels/Payment.dart';
import '/DataLayer/Models/OrderModels/Price.dart';
import '/DataLayer/Models/Other/EnumToString.dart';
import '/DataLayer/Models/Other/Enums.dart';
import '/DataLayer/Models/StoreModels/Offer.dart';
import '/UILayer/Screens/ChatScreen.dart';
import '/UILayer/Widgets/AddressAndCancelCard.dart';
import '../../const.dart';

class CurrentOrder extends StatefulWidget {
  final Order order;

  CurrentOrder({required this.order});

  @override
  _CurrentOrderState createState() => _CurrentOrderState();
}

class _CurrentOrderState extends State<CurrentOrder> {
  static const platform = const MethodChannel("razorpay_flutter");

  Razorpay? _razorpay;

  OrderBloc? _orderBloc;
  StoreBloc? _storeBloc;
  AdminBloc? _adminBloc;

  //bool applyOffer = false;
  bool paymentDone = false;
  double _offerDiscount = 0;
  double _netCharge = 0;
  @override
  Widget build(BuildContext context) {
    _orderBloc = BlocProvider.of<OrderBloc>(context);
    _storeBloc = BlocProvider.of<StoreBloc>(context);
    _adminBloc = BlocProvider.of<AdminBloc>(context);
    _storeBloc!.mapEventToState(GetStoreOffer(storeId: widget.order.storeId!));
    // print(
    //     widget.order.payments[widget.order.payments.length - 1].paymentStatus);

    // print(widget.order.payments.contains(
    //     {"paymentStatus": Enum2String.getPaymentStatus(PaymentStatus.paid)}));

    return Container(
      margin: EdgeInsets.only(
        bottom: 10,
        left: 10,
        right: 10,
      ),
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: Constants.constBorderRadius,
      ),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 20.0, bottom: 20.0),
                  child: CircularPercentIndicator(
                    radius: 175.0,
                    lineWidth: 7.0,
                    animation: true,
                    percent: CircularIndicator()!,
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "${Enum2String.getOrderStatus(widget.order.orderStatus!)}",
                          style: GoogleFonts.openSans(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.0,
                            // color: Colors.black45,
                          ),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          "${Constants.toFancyDate(widget.order.orderPlacingDate!)}",
                          style: GoogleFonts.openSans(
                            fontSize: 13.0,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: Colors.blueGrey,
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'PICK UP',
                            style: GoogleFonts.openSans(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${Constants.toFancyDate1(widget.order.pickupDateTimeRequested!)}",
                            style: TextStyle(
                              fontSize: 13.0,
                              fontFamily: 'OpenSans',
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 30, left: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'DELIVERY',
                            style: GoogleFonts.openSans(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${Constants.toFancyDate1(widget.order.orderPlacingDate!)}",
                            style: TextStyle(
                              fontSize: 13.0,
                              fontFamily: 'OpenSans',
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 30, left: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'COST',
                            style: GoogleFonts.openSans(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${widget.order.price?.netCharge}',
                            style: TextStyle(
                              fontSize: 13.0,
                              fontFamily: 'OpenSans',
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            Divider(
              thickness: 1,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      "Order ID: ",
                      style: GoogleFonts.openSans(
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${widget.order.orderId}",
                      style: GoogleFonts.openSans(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Divider(
                  thickness: 1,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "${widget.order.numberOfClothes} Clothes",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),

            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      ElevatedButton.icon(
                        onPressed: () => _paymentCheck()
                            ? Fluttertoast.showToast(
                                msg: 'You have already paid')
                            : openCheckout(),
                        // onPressed: () {},
                        icon: Icon(
                          Icons.payment,
                          color: Colors.white,
                        ),
                        label: Text(
                          //it's not the best approach
                          _paymentCheck() ? 'Paid' : 'Pay Online',

                          style: GoogleFonts.openSans(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                          elevation: 0,
                          backgroundColor:
                              _paymentCheck() ? Colors.green : Colors.blueGrey,
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          if (widget.order.price?.offer!.description == "") {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    contentPadding: EdgeInsets.all(2),
                                    title: Text("Offers"),
                                    actions: <Widget>[
                                      GFButton(
                                        onPressed: () => Navigator.pop(context),
                                        text: "Close",
                                      )
                                    ],
                                    content: Container(
                                      height: 300,
                                      width: 300,
                                      child: StreamBuilder<List<Offer>>(
                                        initialData: _storeBloc!.storeOffer,
                                        stream:
                                            _storeBloc!.storeOfferListStream,
                                        builder: (BuildContext context,
                                            AsyncSnapshot<List<Offer>>
                                                snapshot) {
                                          if (!snapshot.hasData) {
                                            return Text("No Offer Available");
                                          } else {
                                            return ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: snapshot.data!.length,
                                              itemBuilder: (context, index) {
                                                return Column(
                                                  children: <Widget>[
                                                    ListTile(
                                                      title: Text(
                                                        "${snapshot.data![index].description}",
                                                        maxLines: 6,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      trailing: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                          ),
                                                          elevation: 0,
                                                          backgroundColor:
                                                              Colors.green,
                                                        ),
                                                        onPressed: () {
                                                          if (widget
                                                                  .order
                                                                  .price!
                                                                  .netCharge! >=
                                                              snapshot
                                                                  .data![index]
                                                                  .minAmount!) {
                                                            void _applyOffer() {
                                                              _netCharge = widget
                                                                  .order
                                                                  .price!
                                                                  .netCharge!;

                                                              setState(() {
                                                                _offerDiscount = Constants.precisionOfTwo((snapshot
                                                                        .data![
                                                                            index]
                                                                        .offer! *
                                                                    _netCharge /
                                                                    100));
                                                                if (_offerDiscount >
                                                                    snapshot
                                                                        .data![
                                                                            index]
                                                                        .maxDiscount!) {
                                                                  _offerDiscount =
                                                                      widget
                                                                          .order
                                                                          .price!
                                                                          .offer!
                                                                          .maxDiscount!;
                                                                }
                                                                _netCharge = Constants
                                                                    .precisionOfTwo(
                                                                        _netCharge -
                                                                            _offerDiscount);
                                                              });
                                                            }

                                                            _applyOffer();
                                                            Offer _offer = Offer(
                                                                description: snapshot
                                                                    .data![
                                                                        index]
                                                                    .description,
                                                                isActive: snapshot
                                                                    .data![
                                                                        index]
                                                                    .isActive,
                                                                maxDiscount: snapshot
                                                                    .data![
                                                                        index]
                                                                    .maxDiscount,
                                                                minAmount: snapshot
                                                                    .data![
                                                                        index]
                                                                    .maxDiscount,
                                                                offer: snapshot
                                                                    .data![
                                                                        index]
                                                                    .offer,
                                                                offerCode: snapshot
                                                                    .data![
                                                                        index]
                                                                    .offerCode);
                                                            // print("Offer applied::" +
                                                            //     _offer
                                                            //         .toString());

                                                            Price _price =
                                                                Price(
                                                              orderCharge: widget
                                                                  .order
                                                                  .price!
                                                                  .orderCharge,
                                                              netCharge:
                                                                  _netCharge,
                                                              taxes: widget
                                                                  .order
                                                                  .price
                                                                  ?.taxes,
                                                              deliveryCharge: widget
                                                                  .order
                                                                  .price
                                                                  ?.deliveryCharge,
                                                              discount:
                                                                  _offerDiscount,
                                                              offer: Offer
                                                                  .fromMap(_offer
                                                                      .toJson()),
                                                              servicesOpted: widget
                                                                  .order
                                                                  .price
                                                                  ?.servicesOpted,
                                                              amountChargable:
                                                                  widget
                                                                      .order
                                                                      .price
                                                                      ?.amountChargable,
                                                            );
                                                            // print(_netCharge);
                                                            // print("Price" +
                                                            //     _price
                                                            //         .toString());
                                                            _orderBloc!
                                                                .orderEventSink
                                                                .add(
                                                              ApplyOffer(
                                                                // offerCode: snapshot
                                                                //     .data[index]
                                                                //     .offerCode,
                                                                orderId: widget
                                                                    .order
                                                                    .orderId!,
                                                                prices: _price,
                                                                activity:
                                                                    Activity(
                                                                  activity:
                                                                      Activities
                                                                          .offerAppliedOnOrder,
                                                                  timeStamp:
                                                                      DateTime
                                                                          .now(),
                                                                ),
                                                                // userId: widget
                                                                //     .order.userId,
                                                              ),
                                                            );
                                                            Navigator.pop(
                                                                context);
                                                          } else {
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    'You are not eligible to apply this offer.');
                                                          }
                                                        },
                                                        child: Text(
                                                          'Apply',
                                                          style: GoogleFonts
                                                              .openSans(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Divider(),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  );
                                });
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Offer Already Applied.."),
                                    content: Text(widget
                                        .order.price!.offer!.description!),
                                    actions: <Widget>[
                                      GFButton(
                                        onPressed: () => Navigator.pop(context),
                                        text: "CLOSE",
                                      )
                                    ],
                                  );
                                });
                          }
                        },
                        icon: Icon(
                          Icons.local_offer,
                          color: Colors.white,
                        ),
                        label: Text(
                          widget.order.price?.offer!.description != ""
                              ? 'Offer Applied'
                              : 'Apply Offer',
                          style: GoogleFonts.openSans(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                          elevation: 0,
                          backgroundColor:
                              widget.order.price?.offer!.description != ""
                                  ? Colors.green
                                  : Color(0xFF588da8),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                          elevation: 0,
                        ),
                        label: Text(
                          'Need help?',
                          style: GoogleFonts.openSans(
                            color: Colors.white,
                          ),
                        ),
                        icon: Icon(
                          Icons.phone,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          String _phone =
                              widget.order.storePhoneNumber![0].number!;
                          String _launchPhone = "tel:$_phone";
                          bool _canLaunch = await canLaunch(_launchPhone);
                          if (_canLaunch) {
                            launch("tel:$_phone");
                          } else {
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(_phone),
                                  actions: <Widget>[
                                    CupertinoButton.filled(
                                      child: Text("Copy to Clipboard"),
                                      onPressed: () {
                                        Clipboard.setData(
                                          ClipboardData(
                                            text: _phone,
                                          ),
                                        );
                                        Navigator.of(context).pop();
                                        Fluttertoast.showToast(
                                          msg: "Copied to clipboard",
                                        );
                                      },
                                    )
                                  ],
                                );
                              },
                            );
                          }
                        },
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      ElevatedButton.icon(
                        label: Text(
                          'Chat',
                          style: GoogleFonts.openSans(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                          elevation: 0,
                        ),
                        icon: Icon(
                          Icons.chat,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              fullscreenDialog: true,
                              builder: (BuildContext context) {
                                return ChatScreen(
                                  customerName: widget.order.userName!,
                                  orderId: widget.order.orderId!,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),

            // ExpansionTile(
            //   initiallyExpanded: true,
            //   leading: Icon(
            //     Icons.monetization_on,
            //   ),
            //   title: Text(
            //     'Apply Offers',
            //     style: TextStyle(
            //       fontSize: 14.0,
            //       fontFamily: 'OpenSansBold',
            //       color: Colors.black54,
            //     ),
            //   ),
            //   children: <Widget>[
            //     StreamBuilder<List<Offer>>(
            //       initialData: _storeBloc.storeOffer,
            //       stream: _storeBloc.storeOfferListStream,
            //       builder: (BuildContext context,
            //           AsyncSnapshot<List<Offer>> snapshot) {
            //         print("StreamBuilder offers: ${snapshot.data}");
            //         print(
            //             "StreamBuilder connection: ${snapshot.connectionState}");
            //         if (!snapshot.hasData) {
            //           print(
            //               "currentordercard.dart No Data in offer stream builder");
            //           return Text("No Data");
            //         } else {
            //           print(
            //               "currentordercard.dart Data FOUND in offer stream builder");
            //           return ListView.builder(
            //             shrinkWrap: true,
            //             itemCount: snapshot.data.length,
            //             itemBuilder: (context, index) {
            //               print(snapshot.data[index].description);
            //               return ListTile(
            //                 title: Text(
            //                   "${snapshot.data[index].description}",
            //                   maxLines: 3,
            //                   overflow: TextOverflow.ellipsis,
            //                 ),
            //                 trailing: ElevatedButton(
            //                   shape: RoundedRectangleBorder(
            //                     borderRadius: new BorderRadius.circular(10.0),
            //                   ),
            //                   elevation: 0,
            //                   color:
            //                       applyOffer ? Colors.green : Color(0xFF588da8),
            //                   onPressed: () {
            //                     if (!applyOffer) {
            //                       _applyOffer();
            //                       Price _price = Price(
            //                         orderCharge: widget.order.price.orderCharge,
            //                         netCharge: _netCharge,
            //                         taxes: widget.order.price.taxes,
            //                         deliveryCharge:
            //                             widget.order.price.deliveryCharge,
            //                         discount: _offerDiscount,
            //                         offer: widget.order.price.offer,
            //                       );
            //                       print(_netCharge);
            //                       _orderBloc.orderEventSink.add(ApplyOffer(
            //                           orderId: widget.order.orderId,
            //                           prices: _price,
            //                           activity: Activity(
            //                             activity: Activities.orderPriceUpdated,
            //                             timeStamp: DateTime.now(),
            //                           )));
            //                     } else {
            //                       return null;
            //                     }
            //                     applyOffer = true;
            //                   },
            //                   child: Text(
            //                     applyOffer ? 'Applied' : 'Apply',
            //                     style: TextStyle(
            //                       color: Colors.white,
            //                       fontFamily: "OpenSansBold",
            //                     ),
            //                   ),
            //                 ),
            //               );
            //             },
            //           );
            //         }
            //       },
            //     ),
            //   ],
            // ),
            // ExpansionTile(
            //   leading: Icon(
            //     Icons.monetization_on,
            //   ),
            //   title: Text(
            //     'Use Your Piety Coins',
            //     style: TextStyle(
            //       fontSize: 14.0,
            //       fontFamily: 'OpenSansBold',
            //       color: Colors.black54,
            //     ),
            //   ),
            // ),
            // Divider(
            //   thickness: 2,
            // ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AddressAndCancelCard(order: widget.order),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //is it same for all offers?

  // void _applyOffer() {
  //   _netCharge = widget.order.price.netCharge;

  //   setState(() {
  //     _offerDiscount = Constants.precisionOfTwo(
  //         (widget.order.price.offer.offer * _netCharge / 100));
  //     if (_offerDiscount > widget.order.price.offer.maxDiscount) {
  //       _offerDiscount = widget.order.price.offer.maxDiscount;
  //     }
  //     _netCharge = Constants.precisionOfTwo(_netCharge - _offerDiscount);
  //   });
  // }

  bool _paymentCheck() {
    if (widget.order.payments?.length != 0) {
      return widget.order.payments![widget.order.payments!.length - 1]
              .paymentStatus ==
          PaymentStatus.paid;
    } else {
      return false;
    }
  }

  double? CircularIndicator() {
    if ((Enum2String.getOrderStatus(widget.order.orderStatus!) ==
            "awaitingConfirmation") ||
        (Enum2String.getOrderStatus(widget.order.orderStatus!) ==
            "orderPending")) {
      return 0.2;
    } else if (Enum2String.getOrderStatus(widget.order.orderStatus!) ==
        "inProcess") {
      return 0.4;
    } else if (Enum2String.getOrderStatus(widget.order.orderStatus!) ==
        "cleaned") {
      return 0.6;
    } else if (Enum2String.getOrderStatus(widget.order.orderStatus!) ==
        "onTheWay") {
      return 0.8;
    } else if (Enum2String.getOrderStatus(widget.order.orderStatus!) ==
        "outForDelivery") {
      return 0.9;
    } else if (Enum2String.getOrderStatus(widget.order.orderStatus!) ==
        "delivered") {
      return 1.0;
    }
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay!.clear();
  }

  void openCheckout() async {
    var options = {
      'key': _adminBloc!.getAdminMetaData.razorAPIKey,
      'amount': widget.order.price!.netCharge! * 100,
      'name': widget.order.userName,
      'description': 'Payment for your order: ${widget.order.orderId}',
      'notes': {
        'orderId': widget.order.orderId,
      },
      'currency': 'INR',
      'prefill': {
        'contact': widget.order.userPhoneNumber?.number,
        // 'email': 'test@razorpay.com'
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay!.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId!, timeInSecForIosWeb: 4);
    paymentDone = true;
    _orderBloc!.orderEventSink.add(
      PaymentOrder(
        userId: widget.order.userId!,
        orderId: widget.order.orderId!,
        amount: widget.order.price!.netCharge!,
        payment: Payment(
          amount: widget.order.price!.netCharge!,
          paymentMode: PaymentMode.upi,
          paymentStatus:
              paymentDone == true ? PaymentStatus.paid : PaymentStatus.pending,
        ),
      ),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message!,
        timeInSecForIosWeb: 4);
    paymentDone = false;
    _orderBloc!.orderEventSink.add(
      PaymentOrder(
        userId: widget.order.userId!,
        orderId: widget.order.orderId!,
        amount: widget.order.price!.netCharge!,
        payment: Payment(
          amount: widget.order.price!.netCharge,
          paymentMode: PaymentMode.upi,
          paymentStatus:
              paymentDone == true ? PaymentStatus.paid : PaymentStatus.pending,
        ),
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName!, timeInSecForIosWeb: 4);
  }
}
