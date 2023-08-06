import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';

import '/BloCLayer/UserBloc.dart';
import '/DataLayer/Models/Other/LatLngExtended.dart';
import '/DataLayer/Models/Other/ratingToBadge.dart';

class CustomContainer extends StatelessWidget {
  final LatLngExtended storeLocation;
  // final LatLngExtended customerLocation;
  final bool isLaundry;
  final String storeName;
  final String storeAddress;
  final double rating;
  final String price;
  final CachedNetworkImage image;
  CustomContainer({
    Key? key,
    required this.storeLocation,
    // this.customerLocation,
    required this.isLaundry,
    required this.storeName,
    required this.storeAddress,
    required this.rating,
    required this.price,
    required this.image,
  }) : super(key: key);

  final Distance distance = new Distance();

  @override
  Widget build(BuildContext context) {
    UserBloc _userBloc = BlocProvider.of<UserBloc>(context);
    return StreamBuilder<Placemark>(
        stream: _userBloc.positionStream,
        initialData: _userBloc.getUserPlace,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Something went Wrong"),
              );
            } else {
              double distanceInMeters = distance(
                LatLng(snapshot.data?.position.latitude,
                    snapshot.data?.position.longitude),
                LatLng(storeLocation.latitude, storeLocation.longitude),
              ).toDouble();
              return Container(
                //height: 120,
                margin: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      // clipBehavior: Clip.antiAlias,
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: image ??
                          Image.asset(
                            "assets/Images/machine.png",
                            fit: BoxFit.contain,
                          ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      // width: MediaQuery.of(context).size.width * 0.6,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // SizedBox(
                          //   height: 15,
                          // ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Text(
                              storeName,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: RatingToBadge.badgeColor(rating),
                                ),
                                child: Text(
                                  RatingToBadge.getStoreCategory(rating),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 10),
                                ),
                              ),
                              SizedBox(
                                width: 100,
                              ),
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.location_on,
                                    color: Colors.amber,
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Text("${distanceInMeters / 1000} KM"),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Text(
                                storeAddress ?? "",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              "--------------------------",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.amber),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon(Icons.star, size: 14),
                                  Text(
                                    rating.toString(),
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(Icons.check_circle_outline, size: 10),
                              SizedBox(
                                width: 4,
                              ),
                              Row(
                                children: <Widget>[
                                  isLaundry
                                      ? Text(
                                          "Min Amt : \u20B9$price/Kg",
                                          style: TextStyle(fontSize: 12),
                                        )
                                      : Text(
                                          "Min Amt : \u20B9$price",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          } else {
            return Center(
              child: Text("No Data Found"),
            );
          }
        });
  }
}
