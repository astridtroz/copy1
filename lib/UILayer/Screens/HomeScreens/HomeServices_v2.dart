import 'dart:math';

import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

import '/BloCLayer/StoreBloc.dart';
import '/BloCLayer/StoreEvent.dart';
import '/BloCLayer/UserBloc.dart';
import '/DataLayer/Models/adminModels/adminMetaData.dart';
import '/UILayer/Screens/HomeScreens/HomeStoreListBuilder.dart';
import '/UILayer/Widgets/chip.dart';

class HomeServices extends StatefulWidget {
  @override
  _HomeServicesState createState() => _HomeServicesState();
}

class _HomeServicesState extends State<HomeServices> {
  int itemIndex = 0;
  // int getUserLocationIndex;

  List<Color> colors = [
    Colors.amber[50]!,
    Colors.grey[50]!,
    Colors.blue[50]!,
    Colors.red[50]!,
    Colors.cyan[50]!,
  ];

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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Services",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[700],
                      ),
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    Container(
                      padding: const EdgeInsets.all(4.0),
                      height: 200,
                      child: GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 1,
                            crossAxisSpacing: 1,
                            childAspectRatio: 2 / 1,
                          ),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: <Widget>[
                                Card(
                                    elevation: 4,
                                    color: colors[rng.nextInt(4)],
                                    child: InkWell(
                                      onTap: () {
                                        storeBloc.mapEventToState(
                                          SelectedStore(
                                            isFeatured: false,
                                            selectedStore:
                                                snapshot.data![index].name,
                                          ),
                                        );
                                        // userBloc.positionStream
                                        //     .listen((place) {
                                        //   storeBloc.mapEventToState(InitialData(
                                        //       currentPosition: place));
                                        // });
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (BuildContext
                                                        context) =>
                                                    HomeStoreListBuilder()));
                                      },
                                      child: ServiceChip(
                                        imageUrl: snapshot.data![index].icon!,
                                        text: snapshot.data![index].name!,
                                        // isSelected: _selectedCategory
                                        //     .contains(adminData.storeServices[i].name)
                                        //     ? true
                                        //     : false,
                                      ),
                                      // child: Container(
                                      //   // width: 85,
                                      //   // height: 75,
                                      //   alignment: Alignment.center,
                                      //   child: Column(
                                      //     crossAxisAlignment:
                                      //         CrossAxisAlignment.center,
                                      //     // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      //     children: <Widget>[
                                      //       ServiceChip(
                                      //         imageUrl:
                                      //             snapshot.data[index].icon,
                                      //         text: snapshot.data[index].name,
                                      //         // isSelected: _selectedCategory
                                      //         //     .contains(adminData.storeServices[i].name)
                                      //         //     ? true
                                      //         //     : false,
                                      //       ),
                                      //       // CircleAvatar(
                                      //       //   //radius: 28,
                                      //       //   backgroundColor:
                                      //       //       Colors.transparent,
                                      //       //   backgroundImage: NetworkImage(
                                      //       //     snapshot.data[index].icon,
                                      //       //   ),
                                      //       // ),
                                      //       // FittedBox(
                                      //       //   child: Text(
                                      //       //     snapshot.data[index].name,
                                      //       //     style: TextStyle(
                                      //       //       fontSize: 10,
                                      //       //     ),
                                      //       //   ),
                                      //       // )
                                      //     ],
                                      //   ),
                                      // ),
                                    )),
                              ],
                            );
                          }),
                    ),
                  ],
                ),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
    // Container(
    //   height: 105,
    //   margin: EdgeInsets.only(left: 5),
    //   child: StreamBuilder<List<StoreType>>(
    //     initialData: storeBloc.storeTypes,
    //     stream: storeBloc.storeTypeStream,
    //     builder: (context, snapshot) {
    //       if (snapshot.hasData) {
    //         if (snapshot.hasError) {
    //           return Text("Something went wrong");
    //         } else {
    //           // snapshot.data.forEach((item) {
    //           //   if (!text.contains(item)) {
    //           //     text.add(item);
    //           //   }
    //           // });
    //           // print(text.toString());
    //           // storeBloc.selectedStoreStream.listen((store) {
    //           //   for (int i = 0; i < text.length; i++) {
    //           //     if (text[i] == store && mounted) {
    //           //       setState(() {
    //           //         itemIndex = i;
    //           //       });
    //           //     }
    //           //   }
    //           // });
    //           return ListView.builder(
    //             itemCount: snapshot.data.length,
    //             scrollDirection: Axis.horizontal,
    //             itemBuilder: (_, index) {
    //               return Padding(
    //                 padding: const EdgeInsets.symmetric(
    //                     horizontal: 6.0, vertical: 10),
    //                 child: GestureDetector(
    //                   onTap: () {
    //                     setState(() {
    //                       itemIndex = index;
    //                     });
    //                     storeBloc.mapEventToState(
    //                       GetStoresOfType(
    //                           storeType: text[index],
    //                           currentPosition: userBloc.userPlace),
    //                     );
    //                     storeBloc.mapEventToState(
    //                         SelectedStore(selectedStore: text[index]));
    //                   },
    //                   child: Column(
    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     children: <Widget>[
    //                       CircleAvatar(
    //                         radius: 28,
    //                         backgroundColor: index == itemIndex
    //                             ? Colors.blueGrey
    //                             : colors[index],
    //                         child: icons[index],
    //                         // Icon(
    //                         //   FontAwesomeIcons.headset,
    //                         //   color: Colors.white,
    //                         // ),
    //                       ),
    //                       Text(
    //                         text[index],
    //                         style: GoogleFonts.openSans(
    //                           fontSize: 12,
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               );
    //             },
    //           );
    //         }
    //       } else {
    //         return Center(
    //           child: CircularProgressIndicator(),
    //         );
    //       }
    //     },
    //   ),
    // );
  }
}
