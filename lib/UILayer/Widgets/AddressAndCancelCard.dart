import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '/BloCLayer/OrderBloc.dart';
import '/BloCLayer/OrderEvent.dart';
import '/DataLayer/Models/OrderModels/Activity.dart';
import '/DataLayer/Models/OrderModels/Order.dart';
import '/DataLayer/Models/Other/EnumToString.dart';
import '/DataLayer/Models/Other/Enums.dart';
import '/UILayer/Widgets/GenericOutlineButton.dart';
import '../../const.dart';

class AddressAndCancelCard extends StatelessWidget {
  final Order order;

  AddressAndCancelCard({
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final OrderBloc _orderBloc = BlocProvider.of<OrderBloc>(context);
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: Constants.constBorderRadius,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox(
            height: 5,
          ),
          Divider(),
          _addressTable(),
          Divider(),
          _deliveryTable(),
          Divider(),
          SizedBox(
            height: 7,
          ),
          Enum2String.getOrderStatus(order.orderStatus!) ==
                  Enum2String.getOrderStatus(OrderStatus.awaitingConfirmation)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    GenericOutlineButton(
                      buttonColor: Color(0xFFFFAB40),
                      text: "Cancel",
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Cancel Order"),
                                content: Text(
                                    "Are you sure you want to cancel this order?"),
                                shape: RoundedRectangleBorder(
                                  borderRadius: Constants.constBorderRadius,
                                ),
                                actions: <Widget>[
                                  CupertinoButton.filled(
                                    child: Text("No"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  CupertinoButton.filled(
                                    child: Text("Yes"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      _orderBloc.orderEventSink.add(
                                        CancelOrder(
                                          orderUID: order.orderId!,
                                          activity: Activity(
                                            activity: Activities.orderCancelled,
                                            timeStamp: DateTime.now(),
                                          ),
                                        ),
                                      );
                                      Fluttertoast.showToast(
                                          msg: "Order Canceled");
                                    },
                                  ),
                                ],
                              );
                            });
                      },
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                )
              : Text(''),
        ],
      ),
    );
  }

  Widget _addressTable() {
    return Table(
      children: _addressTableBuilder(),
    );
  }

  List<TableRow> _addressTableBuilder() {
    List<TableRow>? _row = [];

    _row.add(
      TableRow(
        children: <Widget>[
          Text(
            "Name",
            style: GoogleFonts.openSans(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            "${order.userAddress?.name}",
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 13.0,
              fontFamily: 'OpenSans',
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
    _row.add(
      TableRow(
        children: <Widget>[
          Text(
            "Address",
            style: GoogleFonts.openSans(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            "${order.userAddress?.houseNo}, ${order.userAddress?.locality}, \n${order.userAddress?.city}, ${order.userAddress?.city}",
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 13.0,
              fontFamily: 'OpenSans',
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
    return _row;
  }

  Widget _deliveryTable() {
    return Table(
      children: <TableRow>[
        TableRow(
          children: <Widget>[
            Text(
              "Delivery Type",
              style: GoogleFonts.openSans(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              Enum2String.getDeliveryType(order.deliveryType!).toUpperCase(),
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 13.0,
                fontFamily: 'OpenSans',
                color: Colors.black,
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Text(
              "Delivery Mode",
              style: GoogleFonts.openSans(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              Constants.camelCaseToTitleCase(
                  Enum2String.getDeliveryMode(order.deliveryMode!)),
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 13.0,
                fontFamily: 'OpenSans',
                color: Colors.black,
              ),
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            Text(
              "Pickup Time",
              style: GoogleFonts.openSans(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              "${Constants.toFancyDate(order.pickupDateTimeRequested!)}",
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 13.0,
                fontFamily: 'OpenSans',
                color: Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
