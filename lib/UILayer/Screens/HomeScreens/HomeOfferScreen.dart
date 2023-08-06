import 'dart:math';

import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

import '/BloCLayer/StoreBloc.dart';
import '/BloCLayer/StoreEvent.dart';
import '/DataLayer/Models/StoreModels/Offer.dart';
import 'HomeStoreListBuilder.dart';

class HomeOfferScreen extends StatelessWidget {
  final List<Offer> offers;
  final List<String> stores;
  final List<String> storeId;
  final List<String> storeType;

  HomeOfferScreen(
      {required this.offers,
      required this.storeId,
      required this.stores,
      required this.storeType});
  @override
  Widget build(BuildContext context) {
    StoreBloc _storeBloc = BlocProvider.of<StoreBloc>(context);
    List<Color> _color = [
      Colors.amber[50]!,
      Colors.grey[50]!,
      Colors.blue[50]!,
      Colors.red[50]!,
      Colors.cyan[50]!,
    ];
    var rng = new Random();
    return Container(
      padding: const EdgeInsets.all(8.0),
      height: 125,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(4),
        itemCount: offers.length,
        separatorBuilder: (context, count) {
          return SizedBox(
            width: 5,
          );
        },
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              _storeBloc.mapEventToState(
                  SelectedStore(storeName: stores[index], isFeatured: true));
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeStoreListBuilder(),
                ),
              );
            },
            child: Card(
              elevation: 5,
              color: _color[rng.nextInt(5)],
              child: Container(
                width: 180,
                height: 120,
                // alignment: Alignment.center,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: Colors.amber,
                          child: Container(
                            width: 45,
                            height: 20,
                            padding: EdgeInsets.all(5),
                            child: FittedBox(
                              child: Text(
                                "upto ${offers[index].offer}",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        FittedBox(
                          child: Text(
                            stores[index],
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.black,
                            ),
                          ),
                        )
                      ],
                    ),
                    Divider(
                      height: 0,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                            width: 160,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(5),
                              // border: Border.all(width: 1, color: Colors.grey)
                            ),
                            child: Text(
                              "${offers[index].description}",
                              style: TextStyle(
                                fontSize: 8,
                              ),
                            )),
                        SizedBox(
                          width: 5,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
