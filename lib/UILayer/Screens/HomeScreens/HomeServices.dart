import 'dart:math';

import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

import '/BloCLayer/StoreBloc.dart';
import '/BloCLayer/StoreEvent.dart';
import '/BloCLayer/UserBloc.dart';
import '/DataLayer/Models/adminModels/adminMetaData.dart';
import '/UILayer/Screens/HomeScreens/HomeStoreListBuilder.dart';

class HomeServices extends StatefulWidget {
  @override
  _HomeServicesState createState() => _HomeServicesState();
}

class _HomeServicesState extends State<HomeServices> {
  int itemIndex = 0;
  // int getUserLocationIndex;

  // List<Color> colors = [
  //   Colors.amber[50],
  //   Colors.grey[50],
  //   Colors.blue[50],
  //   Colors.red[50],
  //   Colors.cyan[50],
  // ];

  // setAdressIndex() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   int userLocationIndex = preferences.getInt("userAddressIndex") ?? 0;
  //   setState(() {
  //     getUserLocationIndex = userLocationIndex;
  //   });
  //   print("location Index ::::: $userLocationIndex");
  // }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    // setAdressIndex();
  }

  @override
  Widget build(BuildContext context) {
    StoreBloc storeBloc = BlocProvider.of<StoreBloc>(context);
    UserBloc userBloc = BlocProvider.of<UserBloc>(context);
    var rng = new Random();

    return StreamBuilder<List<StoreType>>(
        initialData: storeBloc.storeTypes,
        stream: storeBloc.storeTypeStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            } else {
              return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.count(
                      childAspectRatio: 1.0,
                      padding: EdgeInsets.all(16),
                      crossAxisCount: 2,
                      crossAxisSpacing: 18,
                      mainAxisSpacing: 18,
                      children: snapshot.data!.map((
                        item,
                      ) {
                        return GestureDetector(
                          onTap: () {
                            storeBloc.mapEventToState(
                              SelectedStore(
                                isFeatured: false,
                                selectedStore: item.name,
                              ),
                            );
                            // userBloc.positionStream
                            //     .listen((place) {
                            //   storeBloc.mapEventToState(InitialData(
                            //       currentPosition: place));
                            // });
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    HomeStoreListBuilder()));
                          },
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10, bottom: 5, top: 20),
                            child: Card(
                              //color: data.colors,
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                side: BorderSide(color: Colors.white),
                              ),

//("Super Hero");("Games");

                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.network(
                                      item.icon!,
                                      width: 60.0,
                                      height: 60,
                                      fit: BoxFit.fill,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 5.0),
                                      child: Text(
                                        item.name!,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.0),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList())

                  // Column(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: <Widget>[
                  //     Text(
                  //       "Services",
                  //       style: TextStyle(
                  //         fontSize: 18,
                  //         color: Colors.grey[700],
                  //       ),
                  //     ),
                  //     Divider(
                  //       thickness: 1,
                  //     ),
                  //     Container(
                  //       padding: const EdgeInsets.all(4.0),
                  //       height: 200,
                  //       child: GridView.builder(
                  //           shrinkWrap: true,
                  //           gridDelegate:
                  //               SliverGridDelegateWithFixedCrossAxisCount(
                  //             crossAxisCount: 2,
                  //             mainAxisSpacing: 1,
                  //             crossAxisSpacing: 1,
                  //             childAspectRatio: 2 / 1,
                  //           ),
                  //           itemCount: snapshot.data.length,
                  //           itemBuilder: (context, index) {
                  //             return Column(
                  //               children: <Widget>[
                  //                 Card(
                  //                     elevation: 4,
                  //                     color: colors[rng.nextInt(4)],
                  //                     child: InkWell(
                  //                       onTap: () {
                  //                         storeBloc.mapEventToState(
                  //                           SelectedStore(
                  //                             isFeatured: false,
                  //                             selectedStore:
                  //                                 snapshot.data[index].name,
                  //                           ),
                  //                         );
                  //                         // userBloc.positionStream
                  //                         //     .listen((place) {
                  //                         //   storeBloc.mapEventToState(InitialData(
                  //                         //       currentPosition: place));
                  //                         // });
                  //                         Navigator.of(context).push(
                  //                             MaterialPageRoute(
                  //                                 builder: (BuildContext
                  //                                         context) =>
                  //                                     HomeStoreListBuilder()));
                  //                       },
                  //                       child: ServiceChip(
                  //                         imageUrl: snapshot.data[index].icon,
                  //                         text: snapshot.data[index].name,
                  //                       ),
                  //                     )),
                  //               ],
                  //             );
                  //           }),
                  //     ),
                  //   ],
                  // ),
                  );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
