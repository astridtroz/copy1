import 'package:cloud_firestore/cloud_firestore.dart';

import '/DataLayer/Models/OrderModels/Review.dart';

class StoreReviewList {
  String? userName;
  Review? review;
  StoreReviewList({
    this.userName,
    this.review,
  });

  StoreReviewList.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    userName = snapshot.data()!["userName"];
    review = Review.fromJson(snapshot.data()!["userReview"]);
  }
}
