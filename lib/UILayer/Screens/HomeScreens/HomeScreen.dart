import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:getwidget/components/search_bar/gf_search_bar.dart';
import 'package:provider/provider.dart';

import '/BloCLayer/AdminBloc.dart';
import '/BloCLayer/UserBloc.dart';
import '/DataLayer/Models/Other/Enums.dart';
import '/DataLayer/Models/StoreModels/Store.dart';
import '/UILayer/Screens/HomeScreens/HomeServices.dart';
import '/UILayer/Screens/HomeScreens/HomeStoreListBuilder.dart';
import '/UILayer/Widgets/noNetwork.dart';
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
          backgroundColor: Colors.cyan[200],
          elevation: 0.0,
          title: SafeArea(
            child: StreamBuilder<List<Store>>(
                stream: _storeBloc!.allStoreStream,
                initialData: _storeBloc!.getAllStore,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.hasError) {
                      return Container();
                    } else {
                      List<String> test = [];
                      snapshot.data!.forEach((element) {
                        // print("My Service list${element.services != null && element.services.isNotEmpty ? element.services : 'Null or Empty Service found'}");
                        element.services?.forEach((serviceName) {
                          if (!test.contains(serviceName)) {
                            test.add(serviceName);
                          }
                        });
                      });
                      // print("Search list ::::: $test");
                      return GFSearchBar(
                        searchBoxInputDecoration: InputDecoration(
                          labelText: "Search Service ..",
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(20.0),
                            borderSide: new BorderSide(),
                          ),
                          //fillColor: Colors.green
                        ),
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
                              //padding: const EdgeInsets.all(2),
                              child: ListTile(
                            title: Text(
                              item,
                            ),
                          ));
                        },
                        onItemSelected: (item) {
                          if (item.toString().trim().isEmpty || item == null) {
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
                            Navigator.of(context).push(MaterialPageRoute(
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
          ),
          centerTitle: true,
        ),
        body: connectionStatus == ConnectivityStatus.offline
            ? NoNetwork()
            : Stack(
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
                  HomeServices()
                ],
              ));
  }
}
