import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:getwidget/components/search_bar/gf_search_bar.dart';
import 'package:provider/provider.dart';

import '/BloCLayer/AdminBloc.dart';
import '/BloCLayer/UserBloc.dart';
import '/DataLayer/Models/Other/Enums.dart';
import '/DataLayer/Models/StoreModels/Offer.dart';
import '/DataLayer/Models/StoreModels/Store.dart';
import '/UILayer/Screens/HomeScreens/HomeOfferScreen.dart';
import '/UILayer/Widgets/noNetwork.dart';
import './HomeCustomCarousel.dart';
import './HomeServices.dart';
import './HomeStoreListBuilder.dart';
import '../../../BloCLayer/StoreBloc.dart';
import '../../../BloCLayer/StoreEvent.dart';

class HomeScreen extends StatefulWidget {
  static String route = "home_screen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int groupValue = -1;
  StoreBloc? _storeBloc;
  AdminBloc? _adminBloc;
  UserBloc? _userBloc;
  int? getUserLocationIndex;

  @override
  void initState() {
    super.initState();
    // setAdressIndex();
  }

  @override
  void didChangeDependencies() {
    _storeBloc = BlocProvider.of<StoreBloc>(context);
    _adminBloc = BlocProvider.of<AdminBloc>(context);
    _userBloc = BlocProvider.of<UserBloc>(context);
    _storeBloc!.mapEventToState(GetStoreType());
    _adminBloc!.fetchMetaData();
    _storeBloc!.mapEventToState(GetFeatureOfferList());

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _storeBloc = BlocProvider.of<StoreBloc>(context);
    _userBloc = BlocProvider.of<UserBloc>(context);
    _adminBloc!.fetchMetaData();
    _storeBloc!.mapEventToState(GetFeatureOfferList());

    var connectionStatus = Provider.of<ConnectivityStatus>(context);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text('Hiiii !!  ',
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 20.0,
                  color: Colors.white)),
          centerTitle: true,
        ),
        body: SafeArea(
          child: connectionStatus == ConnectivityStatus.offline
              ? NoNetwork()
              : ListView(
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    SizedBox(height: 12),
                    StreamBuilder<List<Store>>(
                        stream: _storeBloc!.allStoreStream,
                        initialData: _storeBloc!.getAllStore,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.hasError) {
                              return Container();
                            } else {
                              List<String> test = [];
                              snapshot.data!.forEach((element) {
                                print(
                                    "My Service list${element.services != null && element.services!.isNotEmpty ? element.services : 'Null or Empty Service found'}");
                                element.services?.forEach((serviceName) {
                                  if (!test.contains(serviceName)) {
                                    test.add(serviceName);
                                  }
                                });
                              });
                              print("Search list ::::: $test");
                              return GFSearchBar(
                                searchList: test,
                                searchQueryBuilder: (query, list) {
                                  return list
                                      .where((item) => item
                                          .toLowerCase()
                                          .contains(query.toLowerCase()))
                                      .toList();
                                },
                                overlaySearchListItemBuilder: (item) {
                                  return Container(
                                      padding: const EdgeInsets.all(8),
                                      child: ListTile(
                                        title: Text(
                                          item,
                                        ),
                                      ));
                                },
                                onItemSelected: (item) {
                                  if (item.toString().trim().isEmpty ||
                                      item == null) {
                                    return;
                                  } else {
                                    setState(() {
                                      print('$item');
                                    });
                                    _storeBloc!.mapEventToState(
                                        SearchBasedStore(serviceName: item));
                                    _userBloc!.positionStream.listen((place) {
                                      _storeBloc!.mapEventToState(
                                          InitialData(currentPosition: place));
                                    });
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                HomeStoreListBuilder()));
                                  }
                                },
                              );
                            }
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        }),
                    HomeCustomCarousel(),
                    SizedBox(height: 12),
                    StreamBuilder<List<Store>>(
                      stream: _storeBloc!.featuredOfferStoreOfferListStream,
                      initialData: _storeBloc!.getFeatureOfferList,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Text("Error"),
                            );
                          } else {
                            List<Offer> offers = [];
                            List<String> storeNameList = [];
                            List<String> storeId = [];
                            List<String> storeType = [];
                            snapshot.data?.forEach((element) {
                              element.offers?.forEach((offer) {
                                if (offer.isActive!) {
                                  offers.add(offer);
                                  storeNameList.add(element.name!);
                                  storeId.add(element.uid!);
                                  storeType.add(element.storeType!);
                                }
                              });
                            });
                            if (offers.length < 5) {
                              return Visibility(
                                visible: offers.length != 0 ? true : false,
                                child: HomeOfferScreen(
                                  storeId: storeId,
                                  stores: storeNameList,
                                  offers: offers,
                                  storeType: storeType,
                                ),
                              );
                            } else {
                              return Visibility(
                                visible: offers.length != 0 ? true : false,
                                child: HomeOfferScreen(
                                  storeId: storeId.sublist(0, 4),
                                  offers: offers.sublist(0, 4),
                                  stores: storeNameList.sublist(0, 4),
                                  storeType: storeType.sublist(0, 4),
                                ),
                              );
                            }
                          }
                        } else {
                          return Center(
                            child: Text("No Data Found"),
                          );
                        }
                      },
                    ),

                    /// Chips for the Filter Part.
                    // HomeChipBuilder(),
                    SizedBox(height: 12),
                    HomeServices(),

                    /// The List of the Store fetched from the Database.
                    // HomeStoreListBuilder(),
                    SizedBox(height: 12),
                    StreamBuilder<List<Store>>(
                      stream: _storeBloc!.selectedStoreStream,
                      initialData: _storeBloc!.getFeatureOfferList,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Text("Error"),
                            );
                          } else {
                            List<Offer> offers = [];
                            List<String> storeNameList = [];
                            List<String> storeId = [];
                            List<String> storeType = [];
                            snapshot.data!.forEach((element) {
                              element.offers?.forEach((offer) {
                                if (offer.isActive!) {
                                  offers.add(offer);
                                  storeNameList.add(element.name!);
                                  storeId.add(element.uid!);
                                  storeType.add(element.storeType!);
                                }
                              });
                            });
                            print("Length ::: " + offers.length.toString());
                            if (offers.length < 5) {
                              return Container();
                            } else if (offers.length > 10) {
                              return Visibility(
                                visible: offers.length != 0 ? true : false,
                                child: HomeOfferScreen(
                                  storeId: storeId.sublist(5, 9),
                                  offers: offers.sublist(5, 9),
                                  stores: storeNameList.sublist(5, 9),
                                  storeType: storeType.sublist(5, 9),
                                ),
                              );
                            } else {
                              return Visibility(
                                visible: offers.length != 0 ? true : false,
                                child: HomeOfferScreen(
                                  storeId: storeId.sublist(5),
                                  offers: offers.sublist(5),
                                  stores: storeNameList.sublist(5),
                                  storeType: storeType.sublist(5),
                                ),
                              );
                            }
                          }
                        } else {
                          return Center(
                            child: Text("No Data Found"),
                          );
                        }
                      },
                    ),
                  ],
                ),
        ));
  }
}
