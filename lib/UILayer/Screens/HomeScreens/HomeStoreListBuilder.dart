import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_picker/flutter_map_picker.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/rating/gf_rating.dart';
import 'package:getwidget/components/search_bar/gf_search_bar.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '/BloCLayer/StoreEvent.dart';
import '/BloCLayer/UserBloc.dart';
import '/BloCLayer/UserEvent.dart';
import '/DataLayer/Models/UserModels/User.dart';
import '/DataLayer/Models/UserModels/UserAddress.dart';
import '../../../BloCLayer/StoreBloc.dart';
import '../../../DataLayer/Models/StoreModels/Store.dart';
import '../../../const.dart';
import '../../Widgets/CustomContainer.dart';
import '../StoreDescriptionScreens/StoreDescriptionScreen.dart';

class HomeStoreListBuilder extends StatefulWidget {
  @override
  _HomeStoreListBuilderState createState() => _HomeStoreListBuilderState();
}

getUserLocationIndex() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  int userAddressIndex = preferences.getInt("userAddressIndex") ?? 0;
  return userAddressIndex;
}

setUserLocationIndex(int selectedAddress) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setInt("userAddressIndex", selectedAddress);
}

class _HomeStoreListBuilderState extends State<HomeStoreListBuilder> {
  UserBloc? _userBloc;
  StoreBloc? storeBloc;
  PlacePickerResult? _pickedLocation;
  var _isSelected = false;
  double rating = 3;
  int selectedAddress = 0;

  setAdressIndex() async {
    int userLocationIndex = await getUserLocationIndex();
    print("location Index ::::: $userLocationIndex");
    setState(() {
      selectedAddress = userLocationIndex;
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    List<String> storeNameList = [];
    storeBloc = BlocProvider.of<StoreBloc>(context);
    _userBloc = BlocProvider.of<UserBloc>(context);
    _userBloc!.mapEventToState(SelectUserAddress(index: selectedAddress));
    _userBloc!.positionStream.listen((place) {
      storeBloc!.mapEventToState(InitialData(currentPosition: place));
    });

    storeBloc!.selectedStore?.forEach((store) {
      storeNameList.add(store.name!);
    });

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.cyan[200],
          elevation: 0.0,
          title: GestureDetector(
            onTap: () {
              showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (BuildContext context) {
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      elevation: 5,
                      child: Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.45,
                        padding: EdgeInsets.only(
                          top: 10,
                          left: 10,
                          right: 10,
                          bottom: MediaQuery.of(context).viewInsets.bottom + 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Change Delivery Location",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15.0),
                            ),
                            Text(
                              "Select a delivery location to see Store Availability",
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 12.0,
                              ),
                            ),
                            StatefulBuilder(
                              builder: (BuildContext context,
                                      StateSetter mySetState) =>
                                  StreamBuilder<User2>(
                                initialData: _userBloc!.getUser,
                                stream: _userBloc!.getUserStream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    if (snapshot.hasError) {
                                      return Text("Something went wrong");
                                    } else {
                                      // savedAddress = snapshot.data.addresses;
                                      return Container(
                                        width: double.infinity,
                                        height: 100,
                                        child: ListView.separated(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          primary: false,
                                          physics: ClampingScrollPhysics(),
                                          // reverse: true,
                                          separatorBuilder: (context, count) {
                                            return SizedBox(width: 5);
                                          },
                                          itemCount:
                                              snapshot.data!.addresses!.length,
                                          itemBuilder: (context, count) {
                                            // print(snapshot.data);
                                            return Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              elevation: 2,
                                              margin: const EdgeInsets.all(5.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                                child: InkWell(
                                                  splashColor:
                                                      Colors.amberAccent,
                                                  onTap: () {
                                                    mySetState(() {
                                                      _isSelected =
                                                          !_isSelected;
                                                      // _selectedIndex = count;
                                                      selectedAddress = count;
                                                      setUserLocationIndex(
                                                          count);
                                                    });

                                                    _userBloc!.mapEventToState(
                                                        SelectUserAddress(
                                                            index: count));

                                                    // print(
                                                    //     "Index is : $selectedAddress");
                                                  },
                                                  child: StreamBuilder<
                                                      UserAddress>(
                                                    stream: _userBloc!
                                                        .selectedAddressStream,
                                                    initialData: _userBloc!
                                                        .getSelectedUserAddress,
                                                    builder: (context,
                                                        selectedAddress) {
                                                      if (snapshot.hasData) {
                                                        if (snapshot.hasError) {
                                                          return Center(
                                                              child: Text(
                                                                  "Something went wrong"));
                                                        } else {
                                                          return Container(
                                                            color: selectedAddress
                                                                        .data ==
                                                                    snapshot
                                                                        .data!
                                                                        .addresses![count]
                                                                ? Colors.amber
                                                                : Colors.white,
                                                            width: 100.0,
                                                            height: 100.0,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: FittedBox(
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                      "${snapshot.data!.addresses![count].locality}",
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      "${snapshot.data!.addresses![count].city} , ${snapshot.data!.addresses![count].state}",
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      "${snapshot.data!.addresses![count].postalCode} ",
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                      }
                                                      return Center(
                                                          child: Text(
                                                              "No Address Found"));
                                                    },
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    }
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                },
                              ),
                            ),
                            // CupertinoButton.filled.icon(
                            //   icon: Icon(
                            //     Icons.my_location,
                            //     size: 15.0,
                            //   ),
                            //   label: Text("Set this Address",
                            //       style: TextStyle(fontSize: 15.0)),
                            //   onPressed: () {
                            //     _userBloc.mapEventToState(
                            //         SelectUserAddress(
                            //             index: selectedAddress));
                            //     print("Index is : $selectedAddress");
                            //     Navigator.of(context).pop();
                            //   },
                            // ),
                            TextButton.icon(
                              icon: Icon(
                                Icons.location_searching,
                                size: 15.0,
                              ),
                              label: Text("Add Another location",
                                  style: TextStyle(fontSize: 15.0)),
                              onPressed: () async {
                                Position position = await Geolocator()
                                    .getCurrentPosition(
                                        desiredAccuracy: LocationAccuracy.high);
                                _pickedLocation = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PlacePickerScreen(
                                      googlePlacesApiKey: Constants.mapsAPIkey,
                                      initialPosition: LatLng(position.latitude,
                                          position.longitude),
                                      mainColor: Colors.blue[200],
                                      mapStrings: MapPickerStrings.english(),
                                      placeAutoCompleteLanguage: 'en',
                                    ),
                                  ),
                                );
                                if (_pickedLocation != null) {
                                  // print("Picked location:: " +
                                  //     _pickedLocation.address);
                                  // _userBloc.mapEventToState(
                                  //     SelectUserAddress(index: ));
                                  _userBloc!.mapEventToState(AddAddressByLatLng(
                                      latLng: _pickedLocation!.latLng));
                                }
                                setState(() {
                                  // print(_isSelected);
                                  _isSelected = false;
                                });
                                Navigator.pop(context);
                              },
                            )
                          ],
                        ),
                      ),
                    );
                  });
            },
            child: StreamBuilder<UserAddress>(
                initialData: _userBloc!.getSelectedUserAddress,
                stream: _userBloc!.selectedAddressStream,
                builder: (context, snapshot) {
                  print("Print My Location ${snapshot.data}");
                  if (snapshot.hasData) {
                    if (snapshot.hasError) {
                      return Text("Something went wrong");
                    } else {
                      // _place = snapshot.data;
                      // print(_place.locality);
                      // currentAddress =
                      //     "${snapshot.data.locality}, ${snapshot.data.city}, ${snapshot.data.state}, ${snapshot.data.postalCode}";
                      return Container(
                        height: 75,
                        margin: EdgeInsets.only(left: 20),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 10, 10, 10),
                                        child: CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Colors.amber[400],
                                          child: Icon(
                                            Icons.location_on,
                                            color: Colors.black,
                                            size: 22,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "Other",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                child: Text(
                                  "[ ${snapshot.data!.displayAddress()} ]",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          ),
          centerTitle: true,
        ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GFButton(
                    text: "Filter",
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (builder) {
                            return SimpleDialog(
                                contentPadding: EdgeInsets.all(8.0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 12,
                                      ),
                                      Text(
                                        "FILTER",
                                        style: TextStyle(
                                            color: Colors.cyan,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      Container(
                                        width: 300,
                                        child: GFSearchBar(
                                            searchList: storeNameList,
                                            searchQueryBuilder: (query, list) {
                                              return list
                                                  .where((item) => item
                                                      .toLowerCase()
                                                      .contains(
                                                          query.toLowerCase()))
                                                  .toList();
                                            },
                                            overlaySearchListItemBuilder:
                                                (item) {
                                              return Container(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: Text(
                                                  item,
                                                  style: const TextStyle(
                                                      fontSize: 18),
                                                ),
                                              );
                                            },
                                            onItemSelected: (item) {
                                              if (item
                                                      .toString()
                                                      .trim()
                                                      .isEmpty ||
                                                  item == null) {
                                                return;
                                              } else {
                                                storeBloc!.mapEventToState(
                                                    FilterBasedStore(
                                                        searchStoreName: item,
                                                        isRatingFilter: false));

                                                Navigator.of(context)
                                                    .pushReplacement(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                HomeStoreListBuilder()));
                                              }
                                            }),
                                      ),

                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text("Rating Based"),
                                          ),
                                          StatefulBuilder(
                                            builder: (BuildContext context,
                                                    StateSetter mySetState) =>
                                                GFRating(
                                              value: rating,
                                              allowHalfRating: false,
                                              onChanged: (value) {
                                                mySetState(() {
                                                  rating = value;
                                                });
                                                storeBloc!.mapEventToState(
                                                    FilterBasedStore(
                                                        rating: rating,
                                                        isRatingFilter: true));
                                              },
                                            ),
                                          ),
                                        ],
                                      ),

                                      Divider(
                                        thickness: 1,
                                        height: 15,
                                      ),
                                      // Container(
                                      //   width: double.infinity,
                                      //   height: 175,
                                      //   alignment: Alignment.center,
                                      //   margin: const EdgeInsets.all(10),
                                      //   child: GridView.builder(
                                      //     shrinkWrap: true,
                                      //     itemCount: filterList.length,
                                      //     gridDelegate:
                                      //         SliverGridDelegateWithFixedCrossAxisCount(
                                      //       crossAxisCount: 2,
                                      //       mainAxisSpacing: 10,
                                      //       crossAxisSpacing: 10,
                                      //       childAspectRatio: 70 / 20,
                                      //     ),
                                      //     itemBuilder: (context, count) {
                                      //       return InkWell(
                                      //         splashColor: Colors.blueAccent,
                                      //         onTap: () {
                                      //           // _storeBloc.mapEventToState(
                                      //           //     GetFilterBasedStore(
                                      //           //         storeCategory:
                                      //           //             filterList[count]
                                      //           //                 ['title']));
                                      //           setState(() {
                                      //             filterList.forEach((element) =>
                                      //                 element['isSelected'] =
                                      //                     false);
                                      //             filterList[count]['isSelected'] =
                                      //                 true;
                                      //             Navigator.of(context).pop();
                                      //           });
                                      //           print(filterList[count]
                                      //               ['isSelected']);
                                      //         },
                                      //         child: Container(
                                      //           width: 70,
                                      //           height: 20,
                                      //           alignment: Alignment.center,
                                      //           decoration: BoxDecoration(
                                      //             color: filterList[count]
                                      //                     ['isSelected']
                                      //                 ? Colors.blue
                                      //                 : Colors.white,
                                      //             borderRadius:
                                      //                 BorderRadius.circular(10),
                                      //             border: Border.all(
                                      //               width: 1.0,
                                      //               color: Colors.blue,
                                      //             ),
                                      //           ),
                                      //           child: Text(
                                      //             filterList[count]['title'],
                                      //             style: TextStyle(
                                      //               color: filterList[count]
                                      //                       ['isSelected']
                                      //                   ? Colors.white
                                      //                   : Colors.black,
                                      //             ),
                                      //           ),
                                      //         ),
                                      //       );
                                      //     },
                                      //   ),
                                      // ),
                                      // SizedBox(
                                      //   height: 10,
                                      // ),
                                      ElevatedButton(
                                        child: Text(
                                          "Apply",
                                        ),

                                        // color: Colors.amber,
                                        // splashColor: Colors.amberAccent,
                                        onPressed: () {
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomeStoreListBuilder()));
                                        },
                                      ),
                                    ],
                                  )
                                ]);
                          });
                    },
                    type: GFButtonType.outline,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 75, 0, 0),
              child: StreamBuilder<List<Store>>(
                initialData: storeBloc!.getInitialStore,
                stream: storeBloc!.storeTypeListStream,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Store>> snapshot) {
                  if (!snapshot.hasData) {
                    return ListView.separated(
                      itemCount: 3,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      separatorBuilder: (context, count) {
                        return SizedBox(height: 20);
                      },
                      itemBuilder: (context, index) {
                        return Shimmer.fromColors(
                            child: Container(
                              height: 130,
                              margin: const EdgeInsets.only(
                                left: 0,
                                right: 0,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(0),
                                //color: Colors.grey,
                              ),
                            ),
                            baseColor: Colors.grey[400]!,
                            highlightColor: Colors.white);
                      },
                    );
                  } else {
                    if (snapshot.hasError) {
                      return Text("Loading Error");
                    } else {
                      List<Store> loadedStores = snapshot.data!;

                      return snapshot.data!.length != 0
                          ? ListView.separated(
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemCount: snapshot.data!.length,
                              separatorBuilder: (context, count) {
                                return SizedBox(height: 20);
                              },
                              itemBuilder: (context, count) {
                                // String concatenateServices;
                                // if (storeBloc.getInitialRateList.categoryList != null &&
                                //     loadedStores[count].services.isNotEmpty) {
                                //   concatenateServices =
                                //       loadedStores[count].services[0].name ?? "";
                                //   for (int i = 0; i < 1; i++) {
                                //     concatenateServices = concatenateServices +
                                //         " ," +
                                //         loadedStores[count].services[i].name;
                                //   }
                                //   concatenateServices = concatenateServices + "...";
                                // }
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, StoreDescriptionScreen.route,
                                        arguments: loadedStores[count].uid);
                                  },
                                  child: CustomContainer(
                                    // customerLocation: _userBloc.getUserCoordinate,
                                    storeLocation:
                                        loadedStores[count].storeCoordinates!,
                                    isLaundry: loadedStores[count].storeType ==
                                            "Laundry"
                                        ? true
                                        : false,
                                    storeName: loadedStores[count].name!,
                                    storeAddress: loadedStores[count]
                                        .address!
                                        .getDisplayAddress(),
                                    rating: loadedStores[count].rating!,
                                    price: loadedStores[count].storeType ==
                                            "Laundry"
                                        ? loadedStores[count]
                                            .minOrderAmount
                                            .toString()
                                        : loadedStores[count]
                                            .minOrderServiceCharge
                                            .toString(),
                                    image: loadedStores[count].storeLogo != null
                                        ? CachedNetworkImage(
                                            placeholder: (context, url) =>
                                                Image.asset(
                                                    "assets/Images/machine.png"),
                                            imageUrl:
                                                loadedStores[count].storeLogo,
                                            fit: BoxFit.cover,
                                            errorWidget:
                                                (context, url, error) =>
                                                    Text("Error Loading"),
                                          )
                                        : null,
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: Text(
                                "Sorry, We could not find the Store in your Selected Location",
                                textAlign: TextAlign.center,
                              ),
                            );
                    }
                  }
                },
              ),
            )
          ],
        )

        // ListView(
        //   children: <Widget>[
        //     InkWell(
        //       onTap: () {
        //         showModalBottomSheet(
        //             backgroundColor: Colors.transparent,
        //             context: context,
        //             builder: (BuildContext context) {
        //               return Card(
        //                 margin: const EdgeInsets.all(8.0),
        //                 elevation: 5,
        //                 child: Container(
        //                   width: double.infinity,
        //                   height: MediaQuery.of(context).size.height * 0.45,
        //                   padding: EdgeInsets.only(
        //                     top: 10,
        //                     left: 10,
        //                     right: 10,
        //                     bottom: MediaQuery.of(context).viewInsets.bottom + 10,
        //                   ),
        //                   child: Column(
        //                     crossAxisAlignment: CrossAxisAlignment.start,
        //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                     children: <Widget>[
        //                       Text(
        //                         "Change Delivery Location",
        //                         style: TextStyle(
        //                             fontWeight: FontWeight.bold, fontSize: 15.0),
        //                       ),
        //                       Text(
        //                         "Select a delivery location to see Store Availability",
        //                         style: TextStyle(
        //                           color: Colors.grey[700],
        //                           fontSize: 12.0,
        //                         ),
        //                       ),
        //                       StatefulBuilder(
        //                         builder: (BuildContext context,
        //                                 StateSetter mySetState) =>
        //                             StreamBuilder<User>(
        //                           initialData: _userBloc.getUser,
        //                           stream: _userBloc.getUserStream,
        //                           builder: (context, snapshot) {
        //                             if (snapshot.hasData) {
        //                               if (snapshot.hasError) {
        //                                 return Text("Something went wrong");
        //                               } else {
        //                                 // savedAddress = snapshot.data.addresses;
        //                                 return Container(
        //                                   width: double.infinity,
        //                                   height: 100,
        //                                   child: ListView.separated(
        //                                     shrinkWrap: true,
        //                                     scrollDirection: Axis.horizontal,
        //                                     primary: false,
        //                                     physics: ClampingScrollPhysics(),
        //                                     // reverse: true,
        //                                     separatorBuilder: (context, count) {
        //                                       return SizedBox(width: 5);
        //                                     },
        //                                     itemCount:
        //                                         snapshot.data.addresses.length,
        //                                     itemBuilder: (context, count) {
        //                                       // print(snapshot.data);
        //                                       return Card(
        //                                         shape: RoundedRectangleBorder(
        //                                           borderRadius:
        //                                               BorderRadius.circular(12.0),
        //                                         ),
        //                                         elevation: 2,
        //                                         margin: const EdgeInsets.all(5.0),
        //                                         child: ClipRRect(
        //                                           borderRadius:
        //                                               BorderRadius.circular(12.0),
        //                                           child: InkWell(
        //                                             splashColor:
        //                                                 Colors.amberAccent,
        //                                             onTap: () {
        //                                               mySetState(() {
        //                                                 _isSelected =
        //                                                     !_isSelected;
        //                                                 // _selectedIndex = count;
        //                                                 selectedAddress = count;
        //                                                 setUserLocationIndex(
        //                                                     count);
        //                                               });
        //
        //                                               _userBloc.mapEventToState(
        //                                                   SelectUserAddress(
        //                                                       index: count));
        //
        //                                               // print(
        //                                               //     "Index is : $selectedAddress");
        //                                             },
        //                                             child: StreamBuilder<
        //                                                 UserAddress>(
        //                                               stream: _userBloc
        //                                                   .selectedAddressStream,
        //                                               initialData: _userBloc
        //                                                   .getSelectedUserAddress,
        //                                               builder: (context,
        //                                                   selectedAddress) {
        //                                                 if (snapshot.hasData) {
        //                                                   if (snapshot.hasError) {
        //                                                     return Center(
        //                                                         child: Text(
        //                                                             "Something went wrong"));
        //                                                   } else {
        //                                                     return Container(
        //                                                       color: selectedAddress
        //                                                                   .data ==
        //                                                               snapshot.data
        //                                                                       .addresses[
        //                                                                   count]
        //                                                           ? Colors.amber
        //                                                           : Colors.white,
        //                                                       width: 100.0,
        //                                                       height: 100.0,
        //                                                       child: Padding(
        //                                                         padding:
        //                                                             const EdgeInsets
        //                                                                 .all(8.0),
        //                                                         child: FittedBox(
        //                                                           child: Column(
        //                                                             crossAxisAlignment:
        //                                                                 CrossAxisAlignment
        //                                                                     .start,
        //                                                             children: <
        //                                                                 Widget>[
        //                                                               Text(
        //                                                                 "${snapshot.data.addresses[count].locality}",
        //                                                                 style:
        //                                                                     TextStyle(
        //                                                                   fontSize:
        //                                                                       18,
        //                                                                   color: Colors
        //                                                                       .black,
        //                                                                 ),
        //                                                               ),
        //                                                               Text(
        //                                                                 "${snapshot.data.addresses[count].city} , ${snapshot.data.addresses[count].state}",
        //                                                                 style:
        //                                                                     TextStyle(
        //                                                                   fontSize:
        //                                                                       15,
        //                                                                   color: Colors
        //                                                                       .black,
        //                                                                 ),
        //                                                               ),
        //                                                               Text(
        //                                                                 "${snapshot.data.addresses[count].postalCode} ",
        //                                                                 style:
        //                                                                     TextStyle(
        //                                                                   fontSize:
        //                                                                       15,
        //                                                                   color: Colors
        //                                                                       .black,
        //                                                                 ),
        //                                                               ),
        //                                                             ],
        //                                                           ),
        //                                                         ),
        //                                                       ),
        //                                                     );
        //                                                   }
        //                                                 }
        //                                                 return Center(
        //                                                     child: Text(
        //                                                         "No Address Found"));
        //                                               },
        //                                             ),
        //                                           ),
        //                                         ),
        //                                       );
        //                                     },
        //                                   ),
        //                                 );
        //                               }
        //                             } else {
        //                               return Center(
        //                                 child: CircularProgressIndicator(),
        //                               );
        //                             }
        //                           },
        //                         ),
        //                       ),
        //                       // CupertinoButton.filled.icon(
        //                       //   icon: Icon(
        //                       //     Icons.my_location,
        //                       //     size: 15.0,
        //                       //   ),
        //                       //   label: Text("Set this Address",
        //                       //       style: TextStyle(fontSize: 15.0)),
        //                       //   onPressed: () {
        //                       //     _userBloc.mapEventToState(
        //                       //         SelectUserAddress(
        //                       //             index: selectedAddress));
        //                       //     print("Index is : $selectedAddress");
        //                       //     Navigator.of(context).pop();
        //                       //   },
        //                       // ),
        //                       CupertinoButton.filled.icon(
        //                         icon: Icon(
        //                           Icons.location_searching,
        //                           size: 15.0,
        //                         ),
        //                         label: Text("Add Another location",
        //                             style: TextStyle(fontSize: 15.0)),
        //                         onPressed: () async {
        //                           Position position = await Geolocator()
        //                               .getCurrentPosition(
        //                                   desiredAccuracy: LocationAccuracy.high);
        //                           _pickedLocation = await Navigator.push(
        //                             context,
        //                             MaterialPageRoute(
        //                               builder: (context) => PlacePickerScreen(
        //                                 googlePlacesApiKey: Constants.mapsAPIkey,
        //                                 initialPosition: LatLng(position.latitude,
        //                                     position.longitude),
        //                                 mainColor: Colors.blue[200],
        //                                 mapStrings: MapPickerStrings.english(),
        //                                 placeAutoCompleteLanguage: 'en',
        //                               ),
        //                             ),
        //                           );
        //                           if (_pickedLocation != null) {
        //                             // print("Picked location:: " +
        //                             //     _pickedLocation.address);
        //                             // _userBloc.mapEventToState(
        //                             //     SelectUserAddress(index: ));
        //                             _userBloc.mapEventToState(AddAddressByLatLng(
        //                                 latLng: _pickedLocation.latLng));
        //                           }
        //                           setState(() {
        //                             // print(_isSelected);
        //                             _isSelected = false;
        //                           });
        //                           Navigator.pop(context);
        //                         },
        //                       )
        //                     ],
        //                   ),
        //                 ),
        //               );
        //             });
        //       },
        //       child: StreamBuilder<UserAddress>(
        //           initialData: _userBloc.getSelectedUserAddress,
        //           stream: _userBloc.selectedAddressStream,
        //           builder: (context, snapshot) {
        //             print("Print My Location ${snapshot.data}");
        //             if (snapshot.hasData) {
        //               if (snapshot.hasError) {
        //                 return Text("Something went wrong");
        //               } else {
        //                 // _place = snapshot.data;
        //                 // print(_place.locality);
        //                 // currentAddress =
        //                 //     "${snapshot.data.locality}, ${snapshot.data.city}, ${snapshot.data.state}, ${snapshot.data.postalCode}";
        //                 return Container(
        //                   height: 75,
        //                   margin: EdgeInsets.only(left: 20),
        //                   child: SingleChildScrollView(
        //                     scrollDirection: Axis.horizontal,
        //                     child: Row(
        //                       children: <Widget>[
        //                         Row(
        //                           mainAxisAlignment:
        //                               MainAxisAlignment.spaceBetween,
        //                           children: <Widget>[
        //                             Row(
        //                               children: <Widget>[
        //                                 Padding(
        //                                   padding: const EdgeInsets.fromLTRB(
        //                                       0, 10, 10, 10),
        //                                   child: CircleAvatar(
        //                                     radius: 20,
        //                                     backgroundColor: Colors.amber[400],
        //                                     child: Icon(
        //                                       Icons.location_on,
        //                                       color: Colors.black,
        //                                       size: 22,
        //                                     ),
        //                                   ),
        //                                 ),
        //                                 Text(
        //                                   "Other",
        //                                   style: TextStyle(
        //                                       fontSize: 18,
        //                                       color: Colors.black,
        //                                       fontWeight: FontWeight.bold),
        //                                 ),
        //                               ],
        //                             ),
        //                           ],
        //                         ),
        //                         Padding(
        //                           padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        //                           child: Text(
        //                             "[ ${snapshot.data.displayAddress()} ]",
        //                             overflow: TextOverflow.ellipsis,
        //                             style: TextStyle(
        //                               fontSize: 15,
        //                               color: Colors.black,
        //                             ),
        //                           ),
        //                         ),
        //                       ],
        //                     ),
        //                   ),
        //                 );
        //               }
        //             } else {
        //               return Center(
        //                 child: CircularProgressIndicator(),
        //               );
        //             }
        //           }),
        //     ),
        //     Divider(
        //       height: 8,
        //       thickness: 1,
        //     ),
        //     Row(
        //       mainAxisAlignment: MainAxisAlignment.end,
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       mainAxisSize: MainAxisSize.max,
        //       children: <Widget>[
        //         Padding(
        //           padding: const EdgeInsets.all(10.0),
        //           child: GFButton(
        //             text: "Filter",
        //             onPressed: () {
        //               showDialog(
        //                   context: context,
        //                   builder: (builder) {
        //                     return SimpleDialog(
        //                         contentPadding: EdgeInsets.all(8.0),
        //                         shape: RoundedRectangleBorder(
        //                             borderRadius: BorderRadius.circular(20)),
        //                         children: <Widget>[
        //                           Column(
        //                             mainAxisAlignment:
        //                                 MainAxisAlignment.spaceEvenly,
        //                             crossAxisAlignment: CrossAxisAlignment.center,
        //                             children: <Widget>[
        //                               SizedBox(
        //                                 height: 12,
        //                               ),
        //                               Text(
        //                                 "FILTER",
        //                                 style: TextStyle(
        //                                     color: Colors.cyan,
        //                                     fontSize: 15.0,
        //                                     fontWeight: FontWeight.bold),
        //                               ),
        //                               SizedBox(
        //                                 height: 12,
        //                               ),
        //                               Container(
        //                                 width: 300,
        //                                 child: GFSearchBar(
        //                                     searchList: storeNameList,
        //                                     searchQueryBuilder: (query, list) {
        //                                       return list
        //                                           .where((item) => item
        //                                               .toLowerCase()
        //                                               .contains(
        //                                                   query.toLowerCase()))
        //                                           .toList();
        //                                     },
        //                                     overlaySearchListItemBuilder: (item) {
        //                                       return Container(
        //                                         padding: const EdgeInsets.all(8),
        //                                         child: Text(
        //                                           item,
        //                                           style: const TextStyle(
        //                                               fontSize: 18),
        //                                         ),
        //                                       );
        //                                     },
        //                                     onItemSelected: (item) {
        //                                       if (item
        //                                               .toString()
        //                                               .trim()
        //                                               .isEmpty ||
        //                                           item == null) {
        //                                         return;
        //                                       } else {
        //                                         storeBloc.mapEventToState(
        //                                             FilterBasedStore(
        //                                                 searchStoreName: item,
        //                                                 isRatingFilter: false));
        //
        //                                         Navigator.of(context).pushReplacement(
        //                                             MaterialPageRoute(
        //                                                 builder: (context) =>
        //                                                     HomeStoreListBuilder()));
        //                                       }
        //                                     }),
        //                               ),
        //
        //                               SizedBox(
        //                                 height: 15,
        //                               ),
        //                               Row(
        //                                 mainAxisAlignment:
        //                                     MainAxisAlignment.spaceBetween,
        //                                 children: <Widget>[
        //                                   Padding(
        //                                     padding: const EdgeInsets.all(8.0),
        //                                     child: Text("Rating Based"),
        //                                   ),
        //                                   StatefulBuilder(
        //                                     builder: (BuildContext context,
        //                                             StateSetter mySetState) =>
        //                                         GFRating(
        //                                       value: rating,
        //                                       allowHalfRating: false,
        //                                       onChanged: (value) {
        //                                         mySetState(() {
        //                                           rating = value;
        //                                         });
        //                                         storeBloc.mapEventToState(
        //                                             FilterBasedStore(
        //                                                 rating: rating,
        //                                                 isRatingFilter: true));
        //                                       },
        //                                     ),
        //                                   ),
        //                                 ],
        //                               ),
        //
        //                               Divider(
        //                                 thickness: 1,
        //                                 height: 15,
        //                               ),
        //                               // Container(
        //                               //   width: double.infinity,
        //                               //   height: 175,
        //                               //   alignment: Alignment.center,
        //                               //   margin: const EdgeInsets.all(10),
        //                               //   child: GridView.builder(
        //                               //     shrinkWrap: true,
        //                               //     itemCount: filterList.length,
        //                               //     gridDelegate:
        //                               //         SliverGridDelegateWithFixedCrossAxisCount(
        //                               //       crossAxisCount: 2,
        //                               //       mainAxisSpacing: 10,
        //                               //       crossAxisSpacing: 10,
        //                               //       childAspectRatio: 70 / 20,
        //                               //     ),
        //                               //     itemBuilder: (context, count) {
        //                               //       return InkWell(
        //                               //         splashColor: Colors.blueAccent,
        //                               //         onTap: () {
        //                               //           // _storeBloc.mapEventToState(
        //                               //           //     GetFilterBasedStore(
        //                               //           //         storeCategory:
        //                               //           //             filterList[count]
        //                               //           //                 ['title']));
        //                               //           setState(() {
        //                               //             filterList.forEach((element) =>
        //                               //                 element['isSelected'] =
        //                               //                     false);
        //                               //             filterList[count]['isSelected'] =
        //                               //                 true;
        //                               //             Navigator.of(context).pop();
        //                               //           });
        //                               //           print(filterList[count]
        //                               //               ['isSelected']);
        //                               //         },
        //                               //         child: Container(
        //                               //           width: 70,
        //                               //           height: 20,
        //                               //           alignment: Alignment.center,
        //                               //           decoration: BoxDecoration(
        //                               //             color: filterList[count]
        //                               //                     ['isSelected']
        //                               //                 ? Colors.blue
        //                               //                 : Colors.white,
        //                               //             borderRadius:
        //                               //                 BorderRadius.circular(10),
        //                               //             border: Border.all(
        //                               //               width: 1.0,
        //                               //               color: Colors.blue,
        //                               //             ),
        //                               //           ),
        //                               //           child: Text(
        //                               //             filterList[count]['title'],
        //                               //             style: TextStyle(
        //                               //               color: filterList[count]
        //                               //                       ['isSelected']
        //                               //                   ? Colors.white
        //                               //                   : Colors.black,
        //                               //             ),
        //                               //           ),
        //                               //         ),
        //                               //       );
        //                               //     },
        //                               //   ),
        //                               // ),
        //                               // SizedBox(
        //                               //   height: 10,
        //                               // ),
        //                               ElevatedButton(
        //                                 child: Text(
        //                                   "Apply",
        //                                 ),
        //                                 color: Colors.amber,
        //                                 splashColor: Colors.amberAccent,
        //                                 onPressed: () {
        //                                   Navigator.of(context).pushReplacement(
        //                                       MaterialPageRoute(
        //                                           builder: (context) =>
        //                                               HomeStoreListBuilder()));
        //                                 },
        //                               ),
        //                             ],
        //                           )
        //                         ]);
        //                   });
        //             },
        //             type: GFButtonType.outline,
        //           ),
        //         ),
        //       ],
        //     ),
        //     Divider(
        //       height: 8,
        //       thickness: 1,
        //     ),
        //     StreamBuilder<List<Store>>(
        //       initialData: storeBloc.getInitialStore,
        //       stream: storeBloc.storeTypeListStream,
        //       builder:
        //           (BuildContext context, AsyncSnapshot<List<Store>> snapshot) {
        //         if (!snapshot.hasData) {
        //           return ListView.separated(
        //             itemCount: 3,
        //             shrinkWrap: true,
        //             physics: ClampingScrollPhysics(),
        //             separatorBuilder: (context, count) {
        //               return SizedBox(height: 20);
        //             },
        //             itemBuilder: (context, index) {
        //               return Shimmer.fromColors(
        //                   child: Container(
        //                     height: 130,
        //                     margin: const EdgeInsets.only(
        //                       left: 0,
        //                       right: 0,
        //                     ),
        //                     decoration: BoxDecoration(
        //                       borderRadius: BorderRadius.circular(0),
        //                       //color: Colors.grey,
        //                     ),
        //                   ),
        //                   baseColor: Colors.grey[400],
        //                   highlightColor: Colors.white);
        //             },
        //           );
        //         } else {
        //           if (snapshot.hasError) {
        //             return Text("Loading Error");
        //           } else {
        //             List<Store> loadedStores = snapshot.data;
        //
        //             return snapshot.data.length != 0
        //                 ? ListView.separated(
        //                     shrinkWrap: true,
        //                     physics: ClampingScrollPhysics(),
        //                     itemCount: snapshot.data.length,
        //                     separatorBuilder: (context, count) {
        //                       return SizedBox(height: 20);
        //                     },
        //                     itemBuilder: (context, count) {
        //                       // String concatenateServices;
        //                       // if (storeBloc.getInitialRateList.categoryList != null &&
        //                       //     loadedStores[count].services.isNotEmpty) {
        //                       //   concatenateServices =
        //                       //       loadedStores[count].services[0].name ?? "";
        //                       //   for (int i = 0; i < 1; i++) {
        //                       //     concatenateServices = concatenateServices +
        //                       //         " ," +
        //                       //         loadedStores[count].services[i].name;
        //                       //   }
        //                       //   concatenateServices = concatenateServices + "...";
        //                       // }
        //                       return GestureDetector(
        //                         onTap: () {
        //                           Navigator.pushNamed(
        //                               context, StoreDescriptionScreen.route,
        //                               arguments: loadedStores[count].uid);
        //                         },
        //                         child: CustomContainer(
        //                           // customerLocation: _userBloc.getUserCoordinate,
        //                           storeLocation:
        //                               loadedStores[count].storeCoordinates,
        //                           isLaundry:
        //                               loadedStores[count].storeType == "Laundry"
        //                                   ? true
        //                                   : false,
        //                           storeName: loadedStores[count].name,
        //                           storeAddress: loadedStores[count]
        //                               .address
        //                               .getDisplayAddress(),
        //                           rating: loadedStores[count].rating,
        //                           price:
        //                               loadedStores[count].storeType == "Laundry"
        //                                   ? loadedStores[count]
        //                                       .minOrderAmount
        //                                       .toString()
        //                                   : loadedStores[count]
        //                                       .minOrderServiceCharge
        //                                       .toString(),
        //                           image: loadedStores[count].storeLogo != null
        //                               ? CachedNetworkImage(
        //                                   placeholder: (context, url) =>
        //                                       Image.asset(
        //                                           "assets/Images/machine.png"),
        //                                   imageUrl: loadedStores[count].storeLogo,
        //                                   fit: BoxFit.cover,
        //                                   errorWidget: (context, url, error) =>
        //                                       Text("Error Loading"),
        //                                 )
        //                               : null,
        //                         ),
        //                       );
        //                     },
        //                   )
        //                 : Center(
        //                     child: Text(
        //                       "Sorry, We could not find the Store in your Selected Location",
        //                       textAlign: TextAlign.center,
        //                     ),
        //                   );
        //           }
        //         }
        //       },
        //     ),
        //   ],
        // ),
        );
  }
}
