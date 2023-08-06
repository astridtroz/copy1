import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '/BloCLayer/StoreBloc.dart';
import '/DataLayer/Models/StoreModels/StoreReview.dart';
import '/const.dart';

class StoreReview extends StatelessWidget {
  const StoreReview({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    StoreBloc storeBloc = BlocProvider.of<StoreBloc>(context);
    return Container(
      padding: EdgeInsets.all(8.0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: Colors.grey[350]!,
        ),
      ),
      child: StreamBuilder<List<StoreReviewList>>(
          stream: storeBloc.storeReviewListStream,
          initialData: storeBloc.storeReview,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.hasError) {
                return Text("Something Went worng");
              } else {
                return snapshot.data!.isEmpty
                    ? Container(
                        child: Text("No Reviews Yet"),
                      )
                    : MediaQuery.removePadding(
                        removeTop: true,
                        context: context,
                        child: ListView.builder(
                          //physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, count) {
                            return ListTile(
                              title: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    snapshot.data![count].userName ?? "Unknown",
                                    style: GoogleFonts.openSans(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                    ),
                                  ),
                                  RatingBar.builder(
                                    itemSize: 20,
                                    initialRating: snapshot
                                        .data![count].review!.rating
                                        !.toDouble(),
                                    direction: Axis.horizontal,
                                    allowHalfRating: false,
                                    itemCount: 5,
                                    // itemBuilder: (context, _) => Icon(
                                    //   Icons.star,
                                    //   color: Colors.amber,
                                    // ),
                                    onRatingUpdate: (rating) {
                                      print(rating);
                                    },
                                    ignoreGestures: true,
                                    itemBuilder: (context,_) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  ),
                                ],
                              ),
                              leading: CircleAvatar(
                                backgroundColor: Colors.grey[400],
                                radius: 25,
                                backgroundImage: NetworkImage(
                                    "https://randomuser.me/api/portraits/med/men/$count.jpg"),
                              ),
                              isThreeLine: true,
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    Constants.toFancyDate(snapshot
                                        .data![count].review!.dateTime!),
                                    style: GoogleFonts.openSans(
                                      color: Colors.grey[400],
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    child: Text(
                                      snapshot.data![count].review!.message!,
                                      maxLines: 4,
                                      style: GoogleFonts.openSans(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                            // return Row(
                            //   mainAxisSize: MainAxisSize.max,
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                            //   children: <Widget>[
                            //     ///TODO: we should remove it as just to show a user image we have
                            //     ///to request no of review request to just get DP.
                            //     ///currently using randomuser.me api.
                            //     CircleAvatar(
                            //       backgroundColor: Colors.grey[400],
                            //       radius: 25,
                            //       backgroundImage: NetworkImage(
                            //           "https://randomuser.me/api/portraits/med/men/$count.jpg"),
                            //     ),
                            //     Column(
                            //       crossAxisAlignment: CrossAxisAlignment.start,
                            //       mainAxisSize: MainAxisSize.min,
                            //       children: <Widget>[
                            //         SizedBox(height: 5),
                            //         Text(
                            //           snapshot.data[count].userName ?? "Unknown",
                            //           style: GoogleFonts.openSans(
                            //             fontWeight: FontWeight.w700,
                            //             fontSize: 15,
                            //           ),
                            //         ),
                            //         RatingBar(
                            //           itemSize: 20,
                            //           initialRating: snapshot
                            //               .data[count].review.rating
                            //               .toDouble(),
                            //           direction: Axis.horizontal,
                            //           allowHalfRating: false,
                            //           itemCount: 5,
                            //           itemBuilder: (context, _) => Icon(
                            //             Icons.star,
                            //             color: Colors.amber,
                            //           ),
                            //           onRatingUpdate: (rating) {
                            //             print(rating);
                            //           },
                            //           ignoreGestures: true,
                            //         ),
                            //         //SizedBox(width: 30),
                            //         Text(
                            //           Constants.toFancyDate(
                            //               snapshot.data[count].review.dateTime),
                            //           style: GoogleFonts.openSans(
                            //             color: Colors.grey[400],
                            //             fontSize: 12,
                            //           ),
                            //         ),
                            //         SizedBox(height: 8),
                            //         Container(
                            //           width:
                            //               MediaQuery.of(context).size.width * 0.7,
                            //           child: Text(
                            //             snapshot.data[count].review.message,
                            //             style: GoogleFonts.openSans(
                            //               fontSize: 13.5,
                            //               fontWeight: FontWeight.w400,
                            //             ),
                            //           ),
                            //         ),
                            //         SizedBox(height: 15),
                            //       ],
                            //     ),
                            //   ],
                            // );
                          },
                        ),
                      );
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
