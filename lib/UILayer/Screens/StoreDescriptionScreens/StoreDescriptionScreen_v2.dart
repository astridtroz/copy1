import 'dart:async';
import 'dart:math';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:getwidget/components/accordion/gf_accordion.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:google_fonts/google_fonts.dart';
import '/BloCLayer/OrderBloc.dart';
import '/DataLayer/Models/Other/Enums.dart';
import '/DataLayer/Models/StoreModels/Offer.dart';
import '/DataLayer/Models/StoreModels/RateList.dart';
import '/UILayer/Widgets/RateListContainer.dart';
import '/UILayer/Widgets/StoreOfferContainer.dart';
import '/UILayer/Widgets/noNetwork.dart';
import 'package:provider/provider.dart';
import 'package:search_widget/search_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import './StoreGallery.dart';
import './StoreNameReviewText.dart';
import './StoreReview.dart';
import './StoreTimingsText.dart';
import '../../../BloCLayer/StoreBloc.dart';
import '../../../BloCLayer/StoreEvent.dart';
import '../../../DataLayer/Models/StoreModels/Store.dart';
import '../CheckoutScreen.dart';

class StoreDescriptionScreen extends StatefulWidget {
  static String route = "store_description_screen";
  @override
  _StoreDescriptionScreenState createState() => _StoreDescriptionScreenState();
}

class _StoreDescriptionScreenState extends State<StoreDescriptionScreen> {
  List<String> _selectedText = [];
  Map<String, double> _prices = Map<String, double>();
  Map<String, int> _numberOfItems = Map<String, int>();
  String _searchField = "All";

  String dropDownValue = "All";
  StoreBloc? _storeBloc;
  OrderBloc? _orderBloc;
  var init = true;

  List<RateListItem> tempFituredList = [];

  // Visbility Text..

  bool visibilityText = false;

  void startTimer() {
    // Start the periodic timer which prints something every 1 seconds
    // Timer(Duration(seconds: 3), () {
    //   setState(() {
    //     visibilityText = false;
    //   });
    //   print("This is Visible ::: $visibilityText");
    // });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _storeBloc = BlocProvider.of<StoreBloc>(context);
    _orderBloc = BlocProvider.of<OrderBloc>(context);
    final String args = ModalRoute.of(context)?.settings.arguments as String;
    _storeBloc!.mapEventToState(GetSingleStore(storeID: args));
    _storeBloc!.mapEventToState(FetchRateList(storeID: args));
    _storeBloc!.mapEventToState(GetStoreReview(storeId: args));
    if (init) {
      _storeBloc!.singleRateListStream.listen((event) {
        setState(() {
          tempFituredList = event.rateListItem!;
        });
      });
      init = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // _storeBloc = BlocProvider.of<StoreBloc>(context);
    // _orderBloc = BlocProvider.of<OrderBloc>(context);
    // final String args = ModalRoute.of(context).settings.arguments as String;
    // _storeBloc.mapEventToState(GetSingleStore(storeID: args));
    // _storeBloc.mapEventToState(FetchRateList(storeID: args));
    // _storeBloc.mapEventToState(GetStoreReview(storeId: args));

    var connectionStatus = Provider.of<ConnectivityStatus>(context);

    // _storeBloc.singleRateListStream.listen((event) {
    //   setState(() {
    //     tempFituredList = event.rateListItem;
    //   });
    // });

    return StreamBuilder<Store>(
        initialData: _storeBloc!.getSingleStore,
        stream: _storeBloc!.singleStoreStream,
        builder: (context, AsyncSnapshot<Store> snapshot) {
          if (snapshot.hasData) {
            Store loadedStore = snapshot.data!;
            return Scaffold(
              backgroundColor: Colors.white,
              // appBar: buildStoreDescriptionAppBar(_storeBloc),
              // extendBodyBehindAppBar: true,
              body: connectionStatus == ConnectivityStatus.offline
                  ? NoNetwork()
                  : CustomScrollView(
                      slivers: <Widget>[
                        SliverAppBar(
                          backgroundColor: Colors.white,
                          floating: false,
                          pinned: true,
                          leading: Container(),
                          flexibleSpace: FlexibleSpaceBar(
                            titlePadding: EdgeInsets.all(5),
                            title: loadedStore.storeType == "Grocery Vendor"
                                ? tempFituredList.length != 0
                                    ? buildSearchWidget(
                                        tempFituredList, context)
                                    : IconButton(
                                        icon: Icon(Icons.arrow_back_ios,
                                            color: Colors.black),
                                        onPressed: () =>
                                            Navigator.of(context).pop())
                                : IconButton(
                                    icon: Icon(Icons.arrow_back_ios,
                                        color: Colors.black),
                                    onPressed: () =>
                                        Navigator.of(context).pop()),
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildListDelegate([
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                /// Gallery View
                                loadedStore.myGallery != null &&
                                        loadedStore.myGallery!.isNotEmpty
                                    ? StoreGallery(loadedStore: loadedStore)
                                    : Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.4,
                                        child: Image.asset(
                                          "assets/Images/machine.png",
                                          fit: BoxFit.cover,
                                          scale: 1,
                                        ), //change this image new graphics design
                                      ),

                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    children: <Widget>[
                                      /// Store Names Section.
                                      StoreNameReviewText(
                                          loadedStore: loadedStore),
                                      SizedBox(height: 10),
                                      StoreTimingText(loadedStore: loadedStore),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.call,
                                                size: 16,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "${loadedStore.phoneNumbers![0].countryCode} ${loadedStore.phoneNumbers![0].number}",
                                                style: TextStyle(fontSize: 14),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Text("Minimum Billing : "),
                                              CircleAvatar(
                                                radius: 9,
                                                backgroundColor: Colors.green,
                                                child: Text(
                                                  "\u{20B9}",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              loadedStore.storeType == "Laundry"
                                                  ? Text(
                                                      "${loadedStore.minOrderAmount}",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                      ),
                                                    )
                                                  : Text(
                                                      "${loadedStore.minOrderServiceCharge}",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),

                                      /// Phone and Service Section
                                      //StoreServices(loadedStore: loadedStore),
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            //ratelist block
                                            Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.blue)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  //TODO:: here ratelist update
                                                  Builder(
                                                      builder: (context) =>
                                                          Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8),
                                                              child: InkWell(
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: <
                                                                        Widget>[
                                                                      Icon(
                                                                        Icons
                                                                            .attach_money,
                                                                        color: Colors
                                                                            .black,
                                                                        size:
                                                                            25,
                                                                      ),
                                                                      Text(
                                                                          "Ratelist"),
                                                                    ],
                                                                  ),
                                                                  onTap: () {
                                                                    Scaffold.of(
                                                                            context)
                                                                        .showBottomSheet(
                                                                            (context) {
                                                                      _storeBloc!.mapEventToState(GetRateListOfType(
                                                                          rateListType:
                                                                              "All",
                                                                          storeID: _storeBloc!
                                                                              .getSingleStore
                                                                              .uid!));

                                                                      return Padding(
                                                                          padding: const EdgeInsets.all(
                                                                              8.0),
                                                                          child:
                                                                              StatefulBuilder(builder: (BuildContext context, StateSetter mySetState) {
                                                                            return SingleChildScrollView(
                                                                              child: Container(
                                                                                  height: MediaQuery.of(context).size.height * 0.67,
                                                                                  width: MediaQuery.of(context).size.width,
                                                                                  child: Column(children: <Widget>[
                                                                                    StreamBuilder<List<String>>(
                                                                                        initialData: _storeBloc!.getCategoryRateList,
                                                                                        stream: _storeBloc!.categoryListOfStoreStream,
                                                                                        builder: (context, snapshot) {
                                                                                          if (snapshot.hasData) {
                                                                                            if (snapshot.hasError) {
                                                                                              return Text("Something went wrong in Cate");
                                                                                            } else {
                                                                                              List<String> items = snapshot.data!;
                                                                                              print(items.toString());
                                                                                              if (!items.contains("All")) {
                                                                                                items.add("All");
                                                                                              }
                                                                                              return Container(
                                                                                                padding: const EdgeInsets.only(left: 10, right: 10),
                                                                                                decoration: BoxDecoration(
                                                                                                  borderRadius: BorderRadius.circular(5),
                                                                                                  border: Border.all(color: Colors.grey),
                                                                                                ),
                                                                                                child: DropdownButton<String>(
                                                                                                  isDense: true,
                                                                                                  value: dropDownValue,
                                                                                                  onChanged: (String? val) {
                                                                                                    mySetState(() {
                                                                                                      dropDownValue = val!;
                                                                                                    });
                                                                                                    _storeBloc!.mapEventToState(GetRateListOfType(rateListType: dropDownValue, storeID: _storeBloc!.getSingleStore.uid!));
                                                                                                  },
                                                                                                  items: items.map<DropdownMenuItem<String>>((String value) {
                                                                                                    return DropdownMenuItem<String>(
                                                                                                      value: value,
                                                                                                      child: Text(value),
                                                                                                    );
                                                                                                  }).toList(),
                                                                                                ),
                                                                                              );
                                                                                            }
                                                                                          } else {
                                                                                            return Text("Loading... 1");
                                                                                          }
                                                                                        }),
                                                                                    StreamBuilder<RateList>(
                                                                                        initialData: _storeBloc!.getInitialRateList,
                                                                                        stream: _storeBloc!.singleRateListStream,
                                                                                        builder: (BuildContext context, AsyncSnapshot<RateList> snapshot) {
                                                                                          print("\nRebuilded\n");
                                                                                          if (snapshot.hasData) {
                                                                                            return Container(
                                                                                              height: MediaQuery.of(context).size.height * 0.62,
                                                                                              child: ListView(
                                                                                                children: snapshot.data!.cumulativeRateList.keys.map((category) {
                                                                                                  return GFAccordion(
                                                                                                    key: ObjectKey(category),
                                                                                                    title: "$category",
                                                                                                    contentChild: Column(children: <Widget>[
                                                                                                      Row(
                                                                                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                                        children: <Widget>[
                                                                                                          Text(
                                                                                                            "Service",
                                                                                                            style: TextStyle(fontWeight: FontWeight.bold),
                                                                                                          ),
                                                                                                          Text(
                                                                                                            "Price",
                                                                                                            style: TextStyle(fontWeight: FontWeight.bold),
                                                                                                          )
                                                                                                        ],
                                                                                                      ),
                                                                                                      Divider(
                                                                                                        color: Colors.black,
                                                                                                      ),
                                                                                                      Column(
                                                                                                        children: snapshot.data!.cumulativeRateList[category]!.map((RateListItem rateListItem) {
                                                                                                          return Row(
                                                                                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                                            children: <Widget>[
                                                                                                              Text(
                                                                                                                "${rateListItem.serviceName}",
                                                                                                              ),
                                                                                                              Text(
                                                                                                                rateListItem.serviceRate!.isFixed! ? "\u{20B9} ${rateListItem.serviceRate?.fixed} (FIX)" : "\u{20B9} ${rateListItem.serviceRate?.low} - \u{20B9} ${rateListItem.serviceRate?.high}",
                                                                                                              )
                                                                                                            ],
                                                                                                          );
                                                                                                        }).toList(),
                                                                                                      ),
                                                                                                    ]),
                                                                                                  );
                                                                                                }).toList(),
                                                                                              ),
                                                                                            );
                                                                                            // List<RateListItem> temp = snapshot.data;
                                                                                            // return Container(
                                                                                            //   height: MediaQuery.of(context).size.height * 0.6,
                                                                                            //   child: ListView.builder(
                                                                                            //     shrinkWrap: true,
                                                                                            //     physics: ClampingScrollPhysics(),
                                                                                            //     itemCount: temp.length,
                                                                                            //     itemBuilder: (context, count) {
                                                                                            //       return RateListContainer(temp, count);
                                                                                            //     },
                                                                                            //   ),
                                                                                            // );
                                                                                          } else {
                                                                                            return Center(
                                                                                              child: Text("Something went Wrong in Items"),
                                                                                            );
                                                                                          }
                                                                                        })
                                                                                  ])),
                                                                            );
                                                                          }));
                                                                    });
                                                                  }))),
                                                  Builder(
                                                    builder: (context) =>
                                                        InkWell(
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: <Widget>[
                                                          Icon(
                                                            Icons.local_offer,
                                                            color: Colors.black,
                                                            size: 25,
                                                          ),
                                                          Text("Offers"),
                                                        ],
                                                      ),
                                                      onTap: () {
                                                        showBottomSheet(
                                                            context: context,
                                                            builder: (context) {
                                                              return StreamBuilder<
                                                                      Store>(
                                                                  initialData:
                                                                      _storeBloc
                                                                          !.getSingleStore,
                                                                  stream: _storeBloc
                                                                      !.singleStoreStream,
                                                                  builder: (context,
                                                                      snapshot) {
                                                                    if (snapshot
                                                                        .hasData) {
                                                                      if (snapshot
                                                                          .hasError) {
                                                                        return Text(
                                                                            "Something went wrong.");
                                                                      } else {
                                                                        print(
                                                                            "Offers is : ${snapshot.data!.offers?.length}");
                                                                        List<Offer>
                                                                            offers =
                                                                            snapshot.data!.offers!;
                                                                        return snapshot.data!.offers?.length ==
                                                                                0
                                                                            ? Container(
                                                                                height: MediaQuery.of(context).size.height * 0.30,
                                                                                width: MediaQuery.of(context).size.width,
                                                                                child: Center(child: Text("No Offers Available")),
                                                                              )
                                                                            : Container(
                                                                                height: MediaQuery.of(context).size.height * 0.67,
                                                                                width: MediaQuery.of(context).size.width,
                                                                                child: ListView.builder(
                                                                                  shrinkWrap: true,
                                                                                  physics: ClampingScrollPhysics(),
                                                                                  itemCount: offers.length,
                                                                                  itemBuilder: (context, count) {
                                                                                    return offers[count].isActive! ? StoreOfferContainer(offers, count) : Container();
                                                                                  },
                                                                                ),
                                                                              );
                                                                      }
                                                                    } else {
                                                                      return Center(
                                                                        child:
                                                                            CircularProgressIndicator(),
                                                                      );
                                                                    }
                                                                  });
                                                            });
                                                      },
                                                    ),
                                                  ),
                                                  Builder(
                                                    builder: (context) =>
                                                        InkWell(
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: <Widget>[
                                                          Icon(
                                                            Icons.insert_chart,
                                                            color: Colors.black,
                                                            size: 25,
                                                          ),
                                                          Text("Compare")
                                                        ],
                                                      ),
                                                      onTap: () {
                                                        showBottomSheet(
                                                            context: context,
                                                            builder: (context) {
                                                              return Container(
                                                                height: 250,
                                                                margin:
                                                                    const EdgeInsets
                                                                        .all(30),
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                child: StreamBuilder<
                                                                        List<
                                                                            Store>>(
                                                                    initialData:
                                                                        _storeBloc
                                                                            !.getInitialStore,
                                                                    stream: _storeBloc
                                                                        !.storeTypeListStream,
                                                                    builder:
                                                                        (context,
                                                                            snapshot) {
                                                                      List<Store>
                                                                          loadedStores =
                                                                          snapshot
                                                                              .data!;
                                                                      List<ComparisionChartData> myData = [];
                                                                      loadedStores
                                                                          .forEach(
                                                                              (store) {
                                                                        myData.add(ComparisionChartData(
                                                                            minOrderAmount:
                                                                                store.minOrderAmount!,
                                                                            storeName: store.name!));
                                                                      });
                                                                      List<charts.Series<ComparisionChartData, String>>
                                                                          seriesList =
                                                                          [
                                                                        charts.Series<
                                                                            ComparisionChartData,
                                                                            String>(
                                                                          id: 'Chart',
                                                                          colorFn: (_, __) => charts
                                                                              .MaterialPalette
                                                                              .cyan
                                                                              .shadeDefault,
                                                                          domainFn: (ComparisionChartData comp, _) =>
                                                                              comp.storeName,
                                                                          measureFn: (ComparisionChartData comp, _) =>
                                                                              comp.minOrderAmount,
                                                                          data:
                                                                              myData,
                                                                        )
                                                                      ];
                                                                      if (snapshot
                                                                          .hasData) {
                                                                        return charts
                                                                            .BarChart(
                                                                          seriesList,
                                                                          animate:
                                                                              false,
                                                                          behaviors: [
                                                                            charts.SeriesLegend(),
                                                                          ],
                                                                          domainAxis: charts.OrdinalAxisSpec(
                                                                              renderSpec: charts.SmallTickRendererSpec(
                                                                                  minimumPaddingBetweenLabelsPx: 0,
                                                                                  labelAnchor: charts.TickLabelAnchor.centered,
                                                                                  labelStyle: charts.TextStyleSpec(
                                                                                    fontSize: 10,
                                                                                    color: charts.MaterialPalette.black,
                                                                                  ),
                                                                                  labelRotation: 10,
                                                                                  // Change the line colors to match text color.
                                                                                  lineStyle: charts.LineStyleSpec(color: charts.MaterialPalette.black))),
                                                                        );
                                                                      } else {
                                                                        return Text(
                                                                            "Loading");
                                                                      }
                                                                    }),
                                                              );
                                                            });
                                                      },
                                                    ),
                                                  ),
                                                  InkWell(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        Icon(
                                                          Icons.location_on,
                                                          color: Colors.black,
                                                          size: 25,
                                                        ),
                                                        Text("Location"),
                                                      ],
                                                    ),
                                                    onTap: () async {
                                                      Store myStore = _storeBloc
                                                          !.getSingleStore;
                                                      String googleUrl =
                                                          'https://www.google.com/maps/search/?api=1&query=${myStore.storeCoordinates?.latitude},${myStore.storeCoordinates?.longitude}';
                                                      if (await canLaunch(
                                                          googleUrl)) {
                                                        await launch(googleUrl);
                                                      } else {
                                                        throw 'Could not open the map.';
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 10),

                                            SizedBox(height: 10),

                                            /// Services Section
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  "Select Services",
                                                  style: GoogleFonts.openSans(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17,
                                                  ),
                                                ),
                                                Text(
                                                  "Selected Services: ${_selectedText.length}",
                                                  style: GoogleFonts.openSans(
                                                      color: Colors.black),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 15),

                                            loadedStore.storeType !=
                                                    "Grocery Vendor"
                                                ? StreamBuilder<List<String>>(
                                                    stream: _storeBloc
                                                        !.allServicesStream,
                                                    initialData: _storeBloc
                                                        !.getAllServices,
                                                    builder:
                                                        (context, snapshot) {
                                                      return Container(
                                                          child: snapshot.data
                                                                      !.length ==
                                                                  0

                                                              ///if no data
                                                              ? Center(
                                                                  child: Text(
                                                                      "No Services Available"),
                                                                )
                                                              :

                                                              ///for other categories
                                                              Center(
                                                                  child:
                                                                  TextButton(
                                                                    // color: Colors
                                                                    //     .blueGrey,
                                                          style: ButtonStyle(
                                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                              RoundedRectangleBorder(
                                                                  borderRadius:
                                                                  BorderRadius.circular(
                                                                      0.0),
                                                                  side: BorderSide(
                                                                      color:
                                                                      Colors.lightBlueAccent)),
                                                            )),

                                                                    child: Text(
                                                                      "Select Services",
                                                                      style: GoogleFonts
                                                                          .openSans(
                                                                        fontSize:
                                                                            18,
                                                                        color: Colors
                                                                            .lightBlueAccent,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        letterSpacing:
                                                                            0.5,
                                                                      ),
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      showDialog(
                                                                        barrierDismissible:
                                                                            false,
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
                                                                          return AlertDialog(
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                            content:
                                                                                StatefulBuilder(
                                                                              builder: (context, setState) {
                                                                                return Padding(
                                                                                  padding: const EdgeInsets.all(5.0),
                                                                                  child: Column(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    children: <Widget>[
                                                                                      Text(
                                                                                        "Category Selected: ${_selectedText.length} / 10",
                                                                                      ),
                                                                                      Wrap(
                                                                                        children: snapshot.data!.map((item) {
                                                                                          return Padding(
                                                                                            padding: const EdgeInsets.all(5.0),
                                                                                            child: FilterChip(
                                                                                              backgroundColor: _selectedText.contains(item) ? Colors.amber : Colors.white30,
                                                                                              label: Text(
                                                                                                item,
                                                                                              ),
                                                                                              avatar: _selectedText.contains(item) ? Icon(Icons.done) : Icon(Icons.add),
                                                                                              onSelected: (value) {
                                                                                                setState(() {
                                                                                                  _selectedText.contains(item) ? _selectedText.remove(item) : _selectedText.length < 10 ? _selectedText.add(item) : Fluttertoast.showToast(msg: "You Can't Select More than 10 Categories");
                                                                                                });
                                                                                              },
                                                                                            ),
                                                                                          );
                                                                                        }).toList(),
                                                                                      ),
                                                                                      SizedBox(height: 10),
                                                                                      Row(
                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                        children: <Widget>[
                                                                                          GFButton(
                                                                                            child: Text("Close & Save"),
                                                                                            shape: GFButtonShape.standard,
                                                                                            onPressed: () {
                                                                                              super.setState(() {});
                                                                                              Navigator.pop(context);
                                                                                            },
                                                                                          ),
                                                                                        ],
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                );
                                                                              },
                                                                            ),
                                                                          );
                                                                        },
                                                                      );
                                                                    },
                                                                  ),
                                                                )
//                                              StaggeredGridView
//                                                      .countBuilder(
//                                                          crossAxisCount: 2,
//                                                          itemCount: snapshot
//                                                              .data.length,
//                                                          shrinkWrap: true,
//                                                          padding:
//                                                              EdgeInsets.all(2),
//                                                          // scrollDirection: Axis.horizontal,
//                                                          // itemCount: snapshot.data.length,
//                                                          staggeredTileBuilder:
//                                                              (int index) =>
//                                                                  StaggeredTile
//                                                                      .fit(
//                                                                    1,
//                                                                  ),
//                                                          primary: false,
//                                                          mainAxisSpacing: 1.0,
//                                                          crossAxisSpacing: 1.0,
//                                                          itemBuilder:
//                                                              (context, count) {
//                                                            return GestureDetector(
//                                                                onTap: () {
//                                                                  setState(() {
//                                                                    _selectedText.contains(snapshot.data[count])
//                                                                        ? _selectedText.remove(snapshot.data[
//                                                                            count])
//                                                                        : _selectedText
//                                                                            .add(snapshot.data[count]);
//                                                                  });
//                                                                },
//                                                                child:
//                                                                    ServiceChip(
//                                                                  text: snapshot
//                                                                          .data[
//                                                                      count],
//                                                                  isSelected: _selectedText
//                                                                      .contains(
//                                                                          snapshot
//                                                                              .data[count]),
//                                                                ));
//                                                          })
                                                          );
                                                    })
                                                : Container(),

                                            /// Add-on Services Section
                                            StreamBuilder<List<String>>(
                                                stream: _storeBloc!
                                                    .addOnServicesStream,
                                                initialData:
                                                    _storeBloc!.getAddOnServices,
                                                builder: (context, snapshot) {
                                                  return Visibility(
                                                      visible: snapshot.data
                                                                  !.length !=
                                                              0
                                                          ? true
                                                          : false,
                                                      child: ListView(
                                                          padding:
                                                              EdgeInsets.all(0),
                                                          primary: false,
                                                          shrinkWrap: true,
                                                          children: <Widget>[
                                                            Text(
                                                              "Add-on Services",
                                                              style: GoogleFonts
                                                                  .openSans(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 17,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                height: 15),
                                                            Container(
                                                                height: 100,
                                                                child: StaggeredGridView
                                                                    .countBuilder(
                                                                        crossAxisCount:
                                                                            2,
                                                                        itemCount: snapshot
                                                                            .data
                                                                            !.length,
                                                                        shrinkWrap:
                                                                            true,
                                                                        padding:
                                                                            EdgeInsets.all(
                                                                                2),
                                                                        staggeredTileBuilder: (int index) =>
                                                                            StaggeredTile
                                                                                .fit(
                                                                              1,
                                                                            ),
                                                                        primary:
                                                                            false,
                                                                        mainAxisSpacing:
                                                                            1.0,
                                                                        crossAxisSpacing:
                                                                            1.0,
                                                                        itemBuilder:
                                                                            (context,
                                                                                count) {
                                                                          return GestureDetector(
                                                                              onTap: () {
                                                                                setState(() {
                                                                                  _selectedText.contains(snapshot.data![count]) ? _selectedText.remove(snapshot.data![count]) : _selectedText.add(snapshot.data![count]);
                                                                                });
                                                                              },
                                                                              child: ServiceChip(
                                                                                text: snapshot.data![count],
                                                                                isSelected: _selectedText.contains(snapshot.data![count]),
                                                                              ));
                                                                        }))
                                                          ]));
                                                }),

//                                    SizedBox(height: 10),
                                          ],
                                        ),
                                      ),

                                      loadedStore.storeType == "Grocery Vendor"
                                          ?

                                          ///for grocery vendor
                                          StreamBuilder<RateList>(
                                              stream: _storeBloc
                                                  !.singleRateListStream,
//                                        initialData: _storeBloc.getInitialRateList,
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  RateList fetchedRateList =
                                                      snapshot.data!;
                                                  List<RateListItem>
                                                      fetchedList =
                                                      fetchedRateList
                                                          .rateListItem!;
                                                  return fetchedList.length == 0

                                                      ///if no data
                                                      ? Center(
                                                          child: Text(
                                                              "No Services Available"),
                                                        )
                                                      : Container(
                                                          height: fetchedList
                                                                          .length %
                                                                      2 ==
                                                                  0
                                                              ? max(
                                                                  (fetchedList
                                                                          .length) /
                                                                      2 *
                                                                      250,
                                                                  270)
                                                              : max(
                                                                  (fetchedList.length +
                                                                          1) /
                                                                      2 *
                                                                      250,
                                                                  270),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: <Widget>[
                                                              Expanded(
                                                                child: GridView
                                                                    .count(
                                                                  physics:
                                                                      NeverScrollableScrollPhysics(),
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                              top: 0.0),
                                                                  crossAxisCount:
                                                                      2,
                                                                  primary: true,
                                                                  crossAxisSpacing:
                                                                      10,
                                                                  mainAxisSpacing:
                                                                      10,
                                                                  childAspectRatio:
                                                                      0.9,
                                                                  children: () {
                                                                    List<Widget>
                                                                        cards =
                                                                        [];
                                                                    fetchedList
                                                                        .forEach(
                                                                            (item) {
                                                                      ServiceRate
                                                                          rate =
                                                                          item.serviceRate!;
                                                                      bool
                                                                          toAdd =
                                                                          _selectedText
                                                                              .contains(item.serviceName);
                                                                      if (_selectedText
                                                                              .length ==
                                                                          0) {
                                                                        _numberOfItems[
                                                                            item.serviceName!] = 0;
                                                                        _prices[
                                                                            item
                                                                                .serviceName!] = rate
                                                                            .fixed!;
                                                                      }
                                                                      if (_searchField ==
                                                                              "All" ||
                                                                          _searchField ==
                                                                              item.serviceName) {
                                                                        Widget card = buildCard(
                                                                            item.serviceName!,
                                                                            rate.fixed!,
                                                                            item.imageUrl!,
                                                                            toAdd,
                                                                            context,
                                                                            _numberOfItems![item.serviceName!]!);
                                                                        cards.add(
                                                                            card);
                                                                      }
                                                                    });
//                                                print(cards.toString());
                                                                    return cards;
                                                                  }(),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                } else {
                                                  return Container(
                                                    child: Center(
                                                      child: Text(
                                                          "No Data Available"),
                                                    ),
                                                  );
                                                }
                                              })
                                          : Container(),
                                      SizedBox(height: 10),

                                      /// Reviews Section
                                      Text(
                                        "Reviews",
                                        style: GoogleFonts.openSans(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      StoreReview(),
                                      SizedBox(height: 20),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ]),
                        ),
                      ],
                    ),
              bottomNavigationBar: BottomAppBar(
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  height: 60,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        loadedStore.storeType == "Grocery Vendor"
                            ? Text(
                                () {
                                  double totalAmount = 0;
                                  _selectedText.forEach((element) {
                                    totalAmount += _numberOfItems[element]! *
                                        _prices[element]!;
                                  });
                                  // if(totalAmount >= 0) {
                                  //   setState(() {
                                  //     visibilityText = true;
                                  //   });

                                  // }
                                  return totalAmount > 0
                                      ? "Total Amount ₹ " +
                                          totalAmount.toString()
                                      : '';
                                }(),
                                style: GoogleFonts.openSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            : Container(),

                        ///Place order
                        Container(
                          // width: MediaQuery.of(context)
                          //     .size
                          //     .width,
                          height: MediaQuery.of(context).size.height / 16,
                          decoration: BoxDecoration(
                            color: Colors.lightBlueAccent,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: TextButton(
                            onPressed: _selectedText.isEmpty
                                ? () {
                                    Fluttertoast.showToast(
                                        msg: "Please Select Services",
                                        toastLength: Toast.LENGTH_LONG);
                                  }
                                : () {
                                    List<String> selectedServices =
                                        [];
                                    _selectedText.forEach((service) {
                                      selectedServices.add(service);
                                    });
                                    _orderBloc!.selectedServicesSink
                                        .add(selectedServices);
                                    // ServicesScreenArgs args =
                                    //     ServicesScreenArgs(
                                    //   services: selectedServices,
                                    // );
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CheckoutScreen(
                                          selectedServices: selectedServices,
                                          selectedServicesItems: _numberOfItems,
                                        ),
                                      ),
                                    );
                                  },
                            child: Text(
                              "Place Order",
                              style: GoogleFonts.openSans(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ]),
                ),
                color: Colors.white,
              ),
            );
          } else {
            return Center(
              child: Text("Loading....!"),
            );
          }
        });
  }

  SearchWidget<String> buildSearchWidget(
      List<RateListItem> fetchedList, BuildContext context) {
    return SearchWidget<String>(
      dataList: () {
        List<String> services;
        services = fetchedList.map((item) => item.serviceName!).toList();
        services.add("All");
        return services;
      }(),
      hideSearchBoxWhenItemSelected: false,
      listContainerHeight: MediaQuery.of(context).size.height / 4,
      queryBuilder: (String query, List<String> list) {
        return list
            .where((String item) =>
                item.toLowerCase().contains(query.toLowerCase()))
            .toList();
      },
      popupListItemBuilder: (String item) {
        return PopupListItemWidget(item);
      },
      selectedItemBuilder:
          (String selectedItem, VoidCallback deleteSelectedItem) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            _searchField = selectedItem;
            // _selectedText
            //     .clear();
          });
        });
        print(selectedItem);
        return null;
      },
      // widget customization
      noItemsFoundWidget: NoItemsFound(),
      textFieldBuilder:
          (TextEditingController controller, FocusNode focusNode) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0x4437474F),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
              suffixIcon: Icon(Icons.search),
              border: InputBorder.none,
              hintText: "Search here...",
              contentPadding: const EdgeInsets.only(
                left: 16,
                right: 20,
                top: 14,
                bottom: 14,
              ),
            ),
          ),
        );
      },
    );
  }

  // SliverAppBar buildStoreDescriptionAppBar(StoreBloc storeBloc) {
  //   return SliverAppBar(
  //     expandedHeight: 300,
  //     pinned: true,
  //     backgroundColor: Colors.transparent,
  //     elevation: 0,
  //     leading: IconButton(
  //       icon: Icon(
  //         Icons.keyboard_arrow_left,
  //         color: Colors.white,
  //       ),
  //       onPressed: () {
  //         Navigator.pop(context);
  //       },
  //       //
  //       // color: Colors.black,
  //       // size: 25,
  //     ),
  //     centerTitle: true,
  //   );
  // }

  Widget buildCard(String name, double price, String imgPath, bool added,
      context, int numberOfItems) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 1,
      child: Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              // boxShadow: [
              //   BoxShadow(
              //       color: Colors.grey.withOpacity(0.2),
              //       spreadRadius: 10,
              //       blurRadius: 5.0
              //   )
              // ],
              color: Colors.white),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: imgPath != "" && imgPath != null
                    ? Image.network(imgPath,
                        width: 75, height: 75, fit: BoxFit.fill)
                    : Center(
                        child: Icon(
                        Icons.tag_faces,
                        color: Colors.red,
                      )),
                height: 75,
                width: 75,
                color: Colors.yellow,
              ),
              SizedBox(
                height: 7,
              ),
              Text(
                "₹ " + price.toString(),
                style: TextStyle(
                    color: Color(0xFFCC8053),
                    fontFamily: 'Varela',
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                name,
                style: TextStyle(
                    color: Color(0xFF575E67),
                    fontFamily: 'Varela',
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Container(
                  color: Color(0xFFEBEBEB),
                  height: 1,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (!added) ...[
                    GestureDetector(
                      child: Icon(Icons.shopping_basket,
                          color: Color(0xFFD17E50), size: 20),
                      onTap: () {
                        setState(() {
                          _numberOfItems[name] = _numberOfItems[name]! +1;
                          if (!_selectedText.contains(name))
                            _selectedText.add(name);
                        });
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      child: Text('Add to Cart',
                          style: TextStyle(
                              fontFamily: 'Varela',
                              color: Color(0xFFD17E50),
                              fontSize: 15)),
                      onTap: () {
                        setState(() {
                          _numberOfItems[name] = _numberOfItems[name]! + 1;
                          if (!_selectedText.contains(name))
                            _selectedText.add(name);
                        });
                      },
                    )
                  ],
                  if (added) ...[
                    GestureDetector(
                      child: Icon(Icons.remove_circle_outline,
                          color: Colors.red, size: 20),
                      onTap: () {
                        setState(() {
                          _numberOfItems[name] = _numberOfItems[name]! -1;
                          if (_numberOfItems[name] == 0) {
                            _selectedText.remove(name);
                          }
                        });
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(_numberOfItems[name].toString(),
                        style: TextStyle(
                            fontFamily: 'Varela',
                            color: Color(0xFFD17E50),
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                        child: Icon(Icons.add_circle_outline,
                            color: Colors.green, size: 20),
                        onTap: () {
                          setState(() {
                            _numberOfItems[name] = _numberOfItems[name]! + 1;
                          });
                        }),
                  ]
                ],
              ),
            ],
          )),
    );
  }
}

class ServiceChip extends StatelessWidget {
  final bool isSelected;
  final String text;
  ServiceChip({
    Key? key,
    required this.text,
    required this.isSelected,
  });
  @override
  Widget build(BuildContext context) {
    return Wrap(
      //runAlignment: WrapAlignment.start,
      //verticalDirection: VerticalDirection.down,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Chip(
            labelPadding: EdgeInsets.all(5.0),
            avatar: CircleAvatar(
              backgroundColor: isSelected ? Colors.green : Colors.lightBlue,
              child: Text(
                text[0].toUpperCase(),
                style: TextStyle(color: Colors.black),
              ),
            ),
            label: Text(
              text,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 2.0,
            shadowColor: Colors.grey[60],
            padding: EdgeInsets.all(6.0),
          ),
        ),
      ],
    );
  }
}

class ComparisionChartData {
  String storeName;
  double minOrderAmount;
  ComparisionChartData({required this.storeName, required this.minOrderAmount});

  @override
  String toString() {
    return 'ComparisionChartData{storeName: $storeName, minOrderAmount: $minOrderAmount}';
  }
}

class NoItemsFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(
          Icons.folder_open,
          size: 24,
          color: Colors.grey[900]!.withOpacity(0.7),
        ),
        const SizedBox(width: 10),
        Text(
          "No Items Found",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[900]!.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}

class PopupListItemWidget extends StatelessWidget {
  const PopupListItemWidget(this.item);

  final String item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Text(
        item,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}

// class ServicesScreenArgs {
//   final List<Service> services;
//   ServicesScreenArgs({this.services});

//   @override
//   String toString() {
//     return 'ServicesScreenArgs{services: $services}';
//   }
// }
