import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

import '/BloCLayer/UserEvent.dart';
import '/DataLayer/Models/OrderModels/Activity.dart';
import '/DataLayer/Models/OrderModels/Price.dart';
import '../../BloCLayer/OrderBloc.dart';
import '../../BloCLayer/OrderEvent.dart';
import '../../BloCLayer/StoreBloc.dart';
import '../../BloCLayer/UserBloc.dart';
import '../../DataLayer/Models/OrderModels/Order.dart';
import '../../DataLayer/Models/Other/Enums.dart';
import '../../DataLayer/Models/Other/LatLngExtended.dart';
import '../../DataLayer/Models/StoreModels/Store.dart';
import '../../DataLayer/Models/UserModels/User.dart';
import '../../DataLayer/Models/UserModels/UserAddress.dart';
import '../../UILayer/Widgets/MyContainer.dart';
import '../../const.dart';

class CheckoutScreen extends StatefulWidget {
  static String route = "checkout_screen";
  final List<String> selectedServices;
  final Map<String, int> selectedServicesItems;
  CheckoutScreen(
      {required this.selectedServices, required this.selectedServicesItems});
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _totleSelectedItems = 0;
  String? name;

  OrderBloc? _orderBloc;
  UserBloc? _userBloc;
  StoreBloc? _storeBloc;
  User2? _user;
  Store? _store;
  //ServicesScreenArgs _args;
  List<String>? _selectedService;
  Map<String, int>? _selectedServiceItem;
  bool _deliveryType = true;
  bool _deliveryMode = true;

  /// Date Time Fields
  String _date = "Pick Date";
  String _time = "Pick Time";
  DateTime? _pickUpDateTimeRequested;
  DateTime? _pickedDate;

  /// Address Fields
  bool usePreviousAddress = false;
  String? houseNo;
  String? landmark;
  String? mainAddress;

  /// Special Instructions
  String? specialInstructions;

  List<bool> selectedAddress = [];

  @override
  void initState() {
    super.initState();
    if (widget.selectedServicesItems.length == 0) {
      for (int i = 0; i < widget.selectedServices.length; i++)
        widget.selectedServicesItems[widget.selectedServices[i]] = 1;
    }
    for (int i = 0; i < widget.selectedServices.length; i++)
      _totleSelectedItems +=
          widget.selectedServicesItems[widget.selectedServices[i]]!;
  }

  callback(selectedItem, oprater) {
    if (_totleSelectedItems > 0) {
      if (oprater == '+') {
        setState(() {
          _totleSelectedItems += selectedItem as int;
        });
      } else {
        setState(() {
          _totleSelectedItems -= selectedItem as int;
        });
      }
    } else {
      setState(() {
        _totleSelectedItems = widget.selectedServices.length;
      });
    }
  }

  User2? newUser;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context)
        .textTheme
        .apply(bodyColor: titleColor, displayColor: themeColor);

    TextStyle titleStyle = textTheme.subtitle1!
        .copyWith(fontWeight: FontWeight.bold, letterSpacing: 1);
    _userBloc = BlocProvider.of<UserBloc>(context);
    _orderBloc = BlocProvider.of<OrderBloc>(context);
    _storeBloc = BlocProvider.of<StoreBloc>(context);
    _userBloc!.mapEventToState(GetUserDetails());
    _user = _userBloc!.getUser;
    // print(_user.toString());
    _store = _storeBloc!.getSingleStore;
//    if (_store.storeType == "Laundry") {
    //_args = ModalRoute.of(context).settings.arguments as ServicesScreenArgs;
    _selectedService = widget.selectedServices;
    _selectedServiceItem = widget.selectedServicesItems;
    // _deliveryType = _args.deliveryType;
    // _deliveryMode = _args.deliveryMode;
//    }

    return SafeArea(
      child: Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            elevation: 0,
            backgroundColor: Colors.cyan[200],
            // centerTitle: true,
            title: Text(
              "Checkout",
              style: TextStyle(color: Colors.black),
            ),
          ),
          // body: NestedScrollView(
          //   headerSliverBuilder:
          //       (BuildContext context, bool innerBoxIsScrolled) {
          //     return <Widget>[
          //       SliverAppBar(
          //         backgroundColor: bgColor,
          //         expandedHeight: 100.0,
          //         flexibleSpace: FlexibleSpaceBar(
          //           centerTitle: true,
          //           title: Column(
          //             mainAxisAlignment: MainAxisAlignment.start,
          //             mainAxisSize: MainAxisSize.min,
          //             children: <Widget>[
          //               Text(
          //                 "Checkout",
          //                 textAlign: TextAlign.center,
          //                 style: TextStyle(
          //                   letterSpacing: 1,
          //                   color: titleColor,
          //                   fontWeight: FontWeight.bold,
          //                   fontSize: 15.0,
          //                 ),
          //               ),
          //               Container(
          //                 margin: const EdgeInsets.only(
          //                     left: 0.0, top: 6.0, right: 06.0),
          //                 height: 4,
          //                 width: 180,
          //                 decoration: BoxDecoration(
          //                     borderRadius:
          //                         BorderRadius.all(Radius.circular(0)),
          //                     color: subtitleColor),
          //               )
          //             ],
          //           ),
          //         ),
          //       ),
          //     ];
          //   },
          body: Stack(
            children: [
              Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.cyan[200]),
              Positioned(
                  top: 75.0,
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(45.0),
                            topRight: Radius.circular(45.0),
                          ),
                          color: Colors.white),
                      height: MediaQuery.of(context).size.height - 200.0,
                      width: MediaQuery.of(context).size.width)),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 75, 0, 0),
                child: ListView(
                  children: <Widget>[
//              _store.storeType == "Laundry"
//                  ?
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: myContainer(
                          // height: 265 + heightOffSet,
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 35,
                            child: TextFormField(
                              decoration: InputDecoration(
                                icon: Icon(Icons.person),
                                labelText: "Name",
                                contentPadding: EdgeInsets.only(left: 5),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                // hintText: "Enter Name",
                              ),
                              onChanged: (val) => name = val,
                            ),
                          ),
                          Container(
                            alignment: Alignment.topRight,
                            width: double.infinity,
                            child: Text("(Mandatory *)",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 8)),
                          ),
                          Divider(),
                          SizedBox(height: 8),
                          Text(
                            "Service Selected",
                            style: titleStyle,
                          ),
                          SizedBox(height: 8),
                          Text(
                              "(Your Minimum Order amount is : ${_store!.minOrderAmount})",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              )),
                          _selectedService != null
                              ? ListView.separated(
                                  physics: ClampingScrollPhysics(),
                                  separatorBuilder: (context, count) {
                                    return SizedBox(height: 8);
                                  },
                                  shrinkWrap: true,
                                  itemCount: _selectedService!.length,
                                  itemBuilder: (context, count) {
                                    return SelctedItems(
                                      _selectedService![count],
                                      _selectedServiceItem![
                                          _selectedService![count]]!,
                                      callback,
                                    );
                                  },
                                )
                              : Center(
                                  child: CircularProgressIndicator(),
                                ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8, top: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Total number of Items selected ",
                                  style: TextStyle(fontSize: 15),
                                ),
                                Text(
                                  "${_totleSelectedItems}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                    ),
//                  : Container(),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: myContainer(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Available Date and Time",
                            style: titleStyle,
                          ),
                          Container(
                            alignment: Alignment.topRight,
                            width: double.infinity,
                            child: Text("(Mandatory *)",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 8)),
                          ),
                          Divider(),
                          Text(
                            "Select Delivery Date Time",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                      elevation: 1.0,
                                      backgroundColor: Colors.white,
                                    ),
                                    onPressed: () {
                                      DatePicker.showDatePicker(context,
                                          theme: DatePickerTheme(
                                            containerHeight: 210.0,
                                          ),
                                          showTitleActions: true,
                                          minTime: DateTime(2000, 01, 01),
                                          maxTime: DateTime(2022, 12, 31),
                                          onConfirm: (date) {
                                        _date =
                                            '${date.day} - ${date.month} - ${date.year % 100}';
                                        _pickedDate = date;
                                        print(date.toIso8601String());
                                        setState(() {});
                                      },
                                          currentTime: DateTime.now(),
                                          locale: LocaleType.en);
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 50.0,
                                      //width: 100,
                                      child: Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.date_range,
                                            size: 18.0,
                                            color: subtitleColor,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 4.0),
                                            child: Text(
                                              " $_date",
                                              style: TextStyle(
                                                  color: subtitleColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15.0),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                        elevation: 1.0,
                                        backgroundColor: Colors.white),
                                    onPressed: () {
                                      DatePicker.showTimePicker(context,
                                          theme: DatePickerTheme(
                                            containerHeight: 210.0,
                                          ),
                                          showTitleActions: true,
                                          showSecondsColumn: false,
                                          onConfirm: (time) {
                                        _time = '${time.hour} : ${time.minute}';
                                        _pickUpDateTimeRequested = DateTime(
                                            _pickedDate!.year,
                                            _pickedDate!.month,
                                            _pickedDate!.day,
                                            time.hour,
                                            time.minute);
                                        setState(() {});
                                      },
                                          currentTime: DateTime.now(),
                                          locale: LocaleType.en);
                                      setState(() {});
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 50.0,
                                      //width: 95,
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            child: Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.access_time,
                                                  size: 18.0,
                                                  color: subtitleColor,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 4.0,
                                                  ),
                                                  child: Text(
                                                    " $_time",
                                                    style: TextStyle(
                                                        color: subtitleColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15.0),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ]),
                          ),
                        ],
                      )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: myContainer(
                        // height: 100.0,
                        //padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Pickup Address',
                              style: textTheme.subtitle1!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1),
                            ),
                            Divider(),
                            StreamBuilder<UserAddress>(
                              initialData: _userBloc!.getSelectedUserAddress,
                              stream: _userBloc!.selectedAddressStream,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  if (snapshot.hasError) {
                                    return Text("Something went wrong");
                                  } else {
                                    return Text(
                                        "${snapshot.data?.locality}, ${snapshot.data!.city}, ${snapshot.data!.state}, ${snapshot.data!.postalCode}");
                                  }
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _store?.storeType == "Laundry" ? true : false,
                      child: Container(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: ListView(
                          primary: false,
                          shrinkWrap: true,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                "Delivery Type",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Checkbox(
                                            activeColor: Colors.deepPurple,
                                            value: _deliveryType,
                                            onChanged: (val) {
                                              setState(() {
                                                _deliveryType = true;
                                              });
                                            }),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text("Regular Delivery"),
                                            Text(
                                                "₹${_store!.normalDeliveryCharge}  ⏲ ${_store!.normalDeliveryTime} H"),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Checkbox(
                                            activeColor: Colors.deepPurple,
                                            value: !_deliveryType,
                                            onChanged: (val) {
                                              setState(() {
                                                _deliveryType = false;
                                              });
                                            }),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text("Express Delivery"),
                                            Text(
                                                "₹${_store!.expressDeliveryCharge.toString()}  ⏲ ${_store!.expressDeliveryTime} H"),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                "Delivery Mode",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Checkbox(
                                            activeColor: Colors.deepPurple,
                                            value: _deliveryMode,
                                            onChanged: (val) {
                                              setState(() {
                                                _deliveryMode = true;
                                              });
                                            }),
                                        Text("Home Delivery"),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Checkbox(
                                            activeColor: Colors.deepPurple,
                                            value: !_deliveryMode,
                                            onChanged: (val) {
                                              setState(() {
                                                _deliveryMode = false;
                                              });
                                            }),
                                        Text("Self PickUp"),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 200, right: 28, bottom: 20.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: subtitleColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(
                          "PLACE ORDER",
                          style: textTheme.button!.copyWith(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        onPressed: _date == "Pick Date" ||
                                _time == "Pick Time" ||
                                name == "" ||
                                name == null
                            ? () {
                                Fluttertoast.showToast(
                                    msg: "Please Fill All Mandatory Fileds",
                                    toastLength: Toast.LENGTH_SHORT);
                              }
                            : () {
                                Order newOrder;
                                if (_store!.storeType == "Laundry") {
                                  UserAddress orderAddress = UserAddress(
                                      city: _userBloc!
                                          .getSelectedUserAddress.city,
                                      name: name!,
                                      postalCode: _userBloc!
                                          .getSelectedUserAddress.postalCode,
                                      state: _userBloc!
                                          .getSelectedUserAddress.state,
                                      houseNo: _userBloc!
                                          .getSelectedUserAddress.houseNo,
                                      landmark: _userBloc!
                                          .getSelectedUserAddress.landmark,
                                      locality: _userBloc!
                                          .getSelectedUserAddress.locality);
                                  newOrder = Order(
                                    orderPlacingDate: DateTime.now(),
                                    orderStatus:
                                        OrderStatus.awaitingConfirmation,
                                    userId: _user!.uid,
                                    fcmUser: Constants.fcmToken!,
                                    estimatedDeliveryDateTime: DateTime.now()
                                        .add(Duration(
                                            hours:
                                                (_store!.normalDeliveryTime ??
                                                        24.0)
                                                    .toInt())),
                                    price: Price(
                                      offer: null,
                                      orderCharge: null,
                                      netCharge: _store!.minOrderAmount,
                                      deliveryCharge:
                                          _store!.normalDeliveryCharge,
                                      taxes: _store!.taxRate,
                                      servicesOpted: _selectedService!,
                                      amountChargable: null,
                                    ),
                                    pickupDateTimeRequested:
                                        _pickUpDateTimeRequested!,
                                    deliveryType: _deliveryType
                                        ? DeliveryType.regular
                                        : DeliveryType.express,
                                    deliveryMode: _deliveryMode
                                        ? DeliveryMode.homeDelivery
                                        : DeliveryMode.selfPickup,
                                    userCoordinates: LatLngExtended(
                                      _userBloc!.userPlace!.position.latitude,
                                      _userBloc!.userPlace!.position.longitude,
                                    ),
                                    userName: _user!.name,
                                    userAddress: orderAddress,
                                    userPhoneNumber: _user!.phoneNumbers![0],
                                    storeId: _store!.uid,
                                    storeName: _store!.name,
                                    storeAddress: _store!.address,
                                    storePhoneNumber: _store!.phoneNumbers,
                                    storeType: _store!.storeType,
                                    storeCoordinates: _store!.storeCoordinates,
                                    fcmStore:
                                        _store!.fcmTokens?.values.toList(),
                                    services: _selectedService!,
                                    auditTrail: [
                                      Activity(
                                        activity: Activities.orderPlaced,
                                        timeStamp: DateTime.now(),
                                      ),
                                    ],
                                    numberOfClothes: _totleSelectedItems,
                                    // numberOfClothes:
                                    //     int.parse(_numberOfClothesController.text),
                                  );
                                  _orderBloc!.createOrderSink.add(newOrder);
                                  // print(newOrder.toString());
                                  _orderBloc!.mapEventToState(
                                      CreateOrder(order: newOrder));
                                } else {
                                  UserAddress orderAddress = UserAddress(
                                      city: _userBloc!
                                          .getSelectedUserAddress.city,
                                      name: name,
                                      postalCode: _userBloc!
                                          .getSelectedUserAddress.postalCode,
                                      state: _userBloc!
                                          .getSelectedUserAddress.state,
                                      houseNo: _userBloc!
                                          .getSelectedUserAddress.houseNo,
                                      landmark: _userBloc!
                                          .getSelectedUserAddress.landmark,
                                      locality: _userBloc!
                                          .getSelectedUserAddress.locality);
                                  newOrder = Order(
                                    orderPlacingDate: DateTime.now(),
                                    orderStatus:
                                        OrderStatus.awaitingConfirmation,
                                    userId: _user!.uid,
                                    fcmUser: _user!.fcmToken,
                                    estimatedDeliveryDateTime: DateTime.now()
                                        .add(Duration(
                                            hours:
                                                (_store!.normalDeliveryTime ??
                                                        24.0)
                                                    .toInt())),
                                    price: Price(
                                      offer: null,
                                      orderCharge: null,
                                      netCharge: _store!.minOrderAmount,
                                      deliveryCharge:
                                          _store!.normalDeliveryCharge,
                                      taxes: _store!.taxRate,
                                      servicesOpted: _selectedService!,
                                      amountChargable: null,
                                    ),
                                    pickupDateTimeRequested:
                                        _pickUpDateTimeRequested!,
                                    userCoordinates: LatLngExtended(
                                      _userBloc!.userPlace!.position.latitude,
                                      _userBloc!.userPlace!.position.longitude,
                                    ),
                                    userName: _user!.name,
                                    userAddress: orderAddress,
                                    userPhoneNumber: _user!.phoneNumbers![0],
                                    storeId: _store!.uid,
                                    storeName: _store!.name,
                                    storeAddress: _store!.address,
                                    storePhoneNumber: _store!.phoneNumbers,
                                    storeType: _store!.storeType,
                                    storeCoordinates: _store!.storeCoordinates,
                                    fcmStore:
                                        _store!.fcmTokens?.values.toList(),
                                    services: _selectedService!,
                                    auditTrail: [
                                      Activity(
                                        activity: Activities.orderPlaced,
                                        timeStamp: DateTime.now(),
                                      ),
                                    ],
                                    numberOfClothes: _totleSelectedItems,
                                    // numberOfClothes:
                                    //     int.parse(_numberOfClothesController.text),
                                  );
                                  _orderBloc!.createOrderSink.add(newOrder);
                                  _orderBloc!.mapEventToState(
                                      CreateOrder(order: newOrder));
                                }
                                Navigator.of(context).pop();
                              },
                      ),
                    )
                  ],
                ),
              ),
            ],
          )),
    );
  }
}

class SelctedItems extends StatefulWidget {
  final String serviceName;
  final int serviceAmount;
  Function(int, String) callback;

  SelctedItems(this.serviceName, this.serviceAmount, this.callback);

  @override
  _SelctedItemsState createState() => _SelctedItemsState();
}

class _SelctedItemsState extends State<SelctedItems> {
  TextEditingController _numberOfItemsController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _numberOfItemsController.text = widget.serviceAmount.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey[100],
        ),
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  widget.serviceName,
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Material(
                      type: MaterialType.button,
                      elevation: 5.0,
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        width: 25,
                        height: 25,
                        child: InkWell(
                          child: Icon(Icons.add, color: Colors.white, size: 15),
                          onTap: () {
                            int currentValue =
                                int.parse(_numberOfItemsController.text);
                            setState(() {
                              currentValue++;
                              _numberOfItemsController.text = (currentValue)
                                  .toString(); // incrementing value
                              widget.callback(1, "+");
                            });
                          },
                        ),
                      ),
                    ),
                    Container(
                      width: 35,
                      height: 25,
                      child: Center(
                        child: Text(
                          _numberOfItemsController.text,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 25,
                      height: 25,
                      child: Material(
                        type: MaterialType.button,
                        elevation: 5.0,
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(6),
                        child: InkWell(
                            child: Icon(Icons.remove,
                                color: Colors.white, size: 15),
                            onTap: () {
                              int currentValue =
                                  int.parse(_numberOfItemsController.text);
                              setState(() {
                                print("Setting state");
                                currentValue--;
                                _numberOfItemsController.text =
                                    (currentValue > 1 ? currentValue : 1)
                                        .toString(); // decrementing value
                                widget.callback(currentValue >= 1 ? 1 : 0, "-");
                              });
                            }),
                      ),
                    ),
                  ],
                )
              ],
            )
          ],
        ));

    // ExpansionTile(
    //   backgroundColor: Colors.grey[350],
    //   initiallyExpanded: true,
    //   title: Text(
    //     widget.serviceName,
    //     style: TextStyle(
    //       fontSize: 15.0,
    //       fontWeight: FontWeight.bold,
    //       color: Colors.black,
    //     ),
    //   ),
    //   children: <Widget>[
    //     Container(
    //         width: double.infinity,
    //         height: 60,
    //         decoration: BoxDecoration(
    //           color: Colors.grey[100],
    //         ),
    //         padding: EdgeInsets.all(8.0),
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: <Widget>[
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: <Widget>[
    //                 Text(
    //                   "No. of Items",
    //                   style: TextStyle(fontSize: 15),
    //                 ),
    //                 Row(
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   children: <Widget>[
    //                     Material(
    //                       type: MaterialType.button,
    //                       elevation: 5.0,
    //                       color: Colors.amber,
    //                       borderRadius: BorderRadius.circular(6),
    //                       child: Container(
    //                         width: 25,
    //                         height: 25,
    //                         child: InkWell(
    //                           child: Icon(Icons.add,
    //                               color: Colors.white, size: 15),
    //                           onTap: () {
    //                             int currentValue =
    //                                 int.parse(_numberOfItemsController.text);
    //                             setState(() {
    //                               currentValue++;
    //                               _numberOfItemsController.text =
    //                                   (currentValue)
    //                                       .toString(); // incrementing value
    //                               widget.callback(1, "+");
    //                             });
    //                           },
    //                         ),
    //                       ),
    //                     ),
    //                     Container(
    //                       width: 35,
    //                       height: 25,
    //                       child: Center(
    //                         child: Text(
    //                           _numberOfItemsController.text,
    //                           style: TextStyle(
    //                             fontSize: 18,
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                     Container(
    //                       width: 25,
    //                       height: 25,
    //                       child: Material(
    //                         type: MaterialType.button,
    //                         elevation: 5.0,
    //                         color: Colors.amber,
    //                         borderRadius: BorderRadius.circular(6),
    //                         child: InkWell(
    //                             child: Icon(Icons.remove,
    //                                 color: Colors.white, size: 15),
    //                             onTap: () {
    //                               int currentValue = int.parse(
    //                                   _numberOfItemsController.text);
    //                               setState(() {
    //                                 print("Setting state");
    //                                 currentValue--;
    //                                 _numberOfItemsController.text =
    //                                     (currentValue > 1 ? currentValue : 1)
    //                                         .toString(); // decrementing value
    //                                 widget.callback(
    //                                     currentValue >= 1 ? 1 : 0, "-");
    //                               });
    //                             }),
    //                       ),
    //                     ),
    //                   ],
    //                 )
    //               ],
    //             )
    //           ],
    //         ))
    //   ],
    // );
  }
}
