import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import '/BloCLayer/OrderBloc.dart';
import '/BloCLayer/OrderEvent.dart';
import '/DataLayer/Models/OrderModels/Activity.dart';
import '/DataLayer/Models/OrderModels/Order.dart';
import '/DataLayer/Models/OrderModels/Review.dart';
import '/UILayer/Widgets/GenericMaterialButton.dart';
import '/const.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class RatingCard extends StatefulWidget {
  final Order order;
  final Color color;

  RatingCard({
    required this.order,
    this.color = Colors.yellow,
  });

  @override
  _RatingCardState createState() => _RatingCardState();
}

class _RatingCardState extends State<RatingCard> {
  int? _rating = 0;
  TextEditingController? _feedbackController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.order.userReview != null)
      _rating = widget.order.userReview?.rating;
    _feedbackController!.text = widget.order.userReview!.message!;
  }

  @override
  void dispose() {
    _feedbackController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    OrderBloc orderBloc = BlocProvider.of<OrderBloc>(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: Constants.constBorderRadius,
      ),
      title: Text("Rate your Experience"),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SmoothStarRating(
            size: 35,
            allowHalfRating: false,
            color: widget.color,
            rating: _rating!.toDouble(),
            starCount: 5,
            spacing: 8,
            borderColor: Colors.grey,
            onRated: (double rating) {
              setState(() {
                this._rating = rating.toInt();
              });
            },
          ),
          SizedBox(height: 12),
          TextFormField(
            controller: _feedbackController,
            autocorrect: true,
            maxLength: null,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: "Please Enter your views",
            ),
          ),
          SizedBox(height: 12),
          GenericMaterialButton(
            text: "Submit",
            onPressed: () {
              if (_rating == 0) {
                Fluttertoast.showToast(msg: "Please add stars");
              } else {
                Review _review = Review(
                  rating: _rating!.toInt(),
                  dateTime: DateTime.now(),
                  message: _feedbackController!.text,
                );
                orderBloc.orderEventSink.add(
                  ReviewOrder(
                    userId: widget.order.userId!,
                    newReview: _review,
                    oldReview: widget.order.userReview,
                    orderId: widget.order.orderId!,
                    activity: Activity(
                      activity: Activities.storeReviewed,
                      timeStamp: DateTime.now(),
                    ),
                    storeId: widget.order.storeId!,
                  ),
                );
                Navigator.of(context).pop();
              }
            },
          )
        ],
      ),
    );
  }
}
