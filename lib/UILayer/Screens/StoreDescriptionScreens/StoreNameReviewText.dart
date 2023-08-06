import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../DataLayer/Models/StoreModels/Store.dart';

class StoreNameReviewText extends StatelessWidget {
  const StoreNameReviewText({
    Key? key,
    required this.loadedStore,
  }) : super(key: key);

  final Store loadedStore;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                child: Text(
                  loadedStore.name!,
                  style: GoogleFonts.openSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                child: Text(
                  "${loadedStore.address?.storeNo} ${loadedStore.address?.locality}, ${loadedStore.address?.city}, ${loadedStore.address?.state}",
                  style: GoogleFonts.openSans(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(
                    left: 8,
                    right: 8,
                    top: 2,
                    bottom: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.star,
                        color: Colors.black,
                        size: 14,
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Text(
                        loadedStore.rating.toString(),
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                      SizedBox(
                        width: 3,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    left: 3,
                    right: 3,
                    top: 2,
                    bottom: 2,
                  ),
                  child: Column(
                    children: <Widget>[
                      Text(
                        loadedStore.reviewCount.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "REVIEWS",
                        style: TextStyle(
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
