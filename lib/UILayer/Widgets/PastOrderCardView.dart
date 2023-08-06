import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '/BloCLayer/OrderBloc.dart';
import '/DataLayer/Models/OrderModels/Order.dart';
import '/DataLayer/Models/Other/EnumToString.dart';
import '/UILayer/Widgets/GenericMaterialButton.dart';
import '/UILayer/Widgets/GenericOutlineButton.dart';
import '/UILayer/Widgets/RatingCard.dart';
import '../../const.dart';

class PastOrderCardView extends StatefulWidget {
  final Order order;

  PastOrderCardView({required this.order});

  @override
  _PastOrderCardViewState createState() => _PastOrderCardViewState();
}

class _PastOrderCardViewState extends State<PastOrderCardView> {
  bool applyOffer = true;
  int count = 0;
  @override
  Widget build(BuildContext context) {
    OrderBloc _orderBloc;
    _orderBloc = BlocProvider.of<OrderBloc>(context);

    return StreamBuilder<List<Order>>(
        stream: _orderBloc.currentOrderStream,
        builder: (context, snapshot) {
          return Container(
            margin: const EdgeInsets.only(
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
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.only(right: 20.0, bottom: 20.0),
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
                    height: 7,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 3),
                            child: Text(
                              'Wash and Fold',
                              style: TextStyle(
                                color: Colors.black54,
                                fontFamily: "OpenSansBold",
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 0.0, bottom: 3),
                            child: Text(
                              "${widget.order.numberOfClothes} Clothes",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          widget.order.userReview == null
                              ? GenericOutlineButton(
                                  text: "Add Review",
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext buildContext) {
                                        return RatingCard(
                                          order: widget.order,
                                        );
                                      },
                                    );
                                  },
                                )
                              : GenericMaterialButton(
                                  text: "Reviewed",
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext buildContext) {
                                        return RatingCard(
                                          order: widget.order,
                                        );
                                      },
                                    );
                                  },
                                ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            color: Colors.grey[300],
                            height: 1,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    color: Colors.grey[300],
                    height: 1,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Shipping Details',
                        style: TextStyle(
                          fontSize: 15.0,
                          fontFamily: "OpenSansBold",
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '${widget.order.userAddress?.name}',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: "OpenSansBold",
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        "${widget.order.userAddress?.houseNo}, ${widget.order.userAddress?.locality}, \n${widget.order.userAddress?.city}, ${widget.order.userAddress?.city}",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: "OpenSans",
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      Text(
                        'Phone number : ${widget.order.userPhoneNumber?.number}',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: "OpenSansBold",
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  double? CircularIndicator() {
    if (Enum2String.getOrderStatus(widget.order.orderStatus!) ==
        "awaitingConfirmation") {
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
        "delivered") {
      return 1.0;
    }
  }
}
