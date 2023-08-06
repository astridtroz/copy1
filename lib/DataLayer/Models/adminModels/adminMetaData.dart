import 'package:cloud_firestore/cloud_firestore.dart';

import '/DataLayer/Models/adminModels/faq.dart';
import '/DataLayer/Models/adminModels/reward.dart';
import '/DataLayer/Models/adminModels/socialLinkAdmin.dart';

class AdminMetaData {
  /// Boolean to determine how to calculate order discount.
  /// If it is true, then the discount is calculated only
  /// on the basis of order amount entered by the store.
  /// Otherwise the discount is calculated on on the net
  /// sum of order and delivery charge.
  bool? discountOnOrderOnly;

  /// The API key to be used for all razor pay operations
  String? razorAPIKey;
  double? razorPayFees;
  double? razorPayTax;

  /// T&C and legal aggreement links
  String? tc;
  String? agreement;
  int? customerCare;

  ///Application url
  String? androidAppUrl;
  String? iOSAppUrl;

  List<FAQ>? faq;

  /// Provides the list of possible store categories(types of stores)
  /// for the store creation page
  // @deprecated
  // List<String> storeCategories;
  List<StoreType>? storeTypes;

  List<String>? dashboradImage;

  List<SocialLinksAdmin>? social;
  Reward? reward;
  List<String>? superUser;
  List<String>? user;

  /// For each [storeCategories], provides a list of commonly used
  /// For each [storeTypes], provides a list of commonly used
  /// services which the stores can directly use while creating a
  /// rate list. The purpose of creating this value is to make sure
  /// the stores use a generalized rate list for all the major service
  /// types to enforce consistency.
  Map<String, List<String>>? rateListCategory;

  /// The percent of commission to take from stores if the store is
  /// not subscription based
  double? commissionPercent;

  /// The amount of fixed commission to charge from stores if the
  /// store is subscription based
  double? fixedSubscriptionCommission;

  List<FeaturedOffer>? featureOffer = [];

  AdminMetaData.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    this.featureOffer = [];
    if (snapshot.data()!["featureOffer"] != null) {
      for (var i = 0; i < snapshot.data()!["featureOffer"].length; i++) {
        this
            .featureOffer
            ?.add(FeaturedOffer.fromMap(snapshot.data()!["featureOffer"][i]));
      }
    }
    this.dashboradImage = [];
    if (snapshot.data()!["dashboardImage"] != null) {
      for (var i = 0; i < snapshot.data()!["dashboardImage"].length; i++) {
        this.dashboradImage?.add(snapshot.data()!["dashboardImage"][i]);
      }
    }
    this.razorPayFees = snapshot.data()!["razorPayFees"].toDouble();
    this.razorPayTax = snapshot.data()!["razorPayTax"].toDouble();
    this.androidAppUrl = snapshot.data()!["androidAppUrl"] ?? "";
    this.iOSAppUrl = snapshot.data()!["iOSAppUrl"] ?? "";
    this.discountOnOrderOnly = snapshot.data()!["discountOnOrderOnly"];
    this.tc = snapshot.data()!["T&C"] ?? "unknown";
    this.agreement = snapshot.data()!["legalAgreement"] ?? "unknown";
    // this.commission = (snapshot.data["commission"]).toDouble();
    this.razorAPIKey = snapshot.data()!["razorAPIKey"] ?? "unknown";
    this.storeTypes = [];
    for (var i = 0; i < snapshot.data()!["storeTypes"].length; i++) {
      this
          .storeTypes
          ?.add(StoreType.fromMap(snapshot.data()!["storeTypes"][i]));
    }
    // this.storeCategories = List<String>.from(snapshot.data["storeCategories"]);
    // print("admin meta data: $storeCategories");
    this.reward = Reward.fromMap(snapshot.data()!["reward"]);
    this.social = [];
    for (var i = 0; i < snapshot.data()!["socialLinks"].length; i++) {
      social?.add(SocialLinksAdmin.fromMap(snapshot.data()!["socialLinks"][i]));
    }
    this.faq = [];
    for (var i = 0; i < snapshot.data()!["FAQ"].length; i++) {
      faq?.add(FAQ.fromMap(snapshot.data()!["FAQ"][i]));
    }
    this.superUser = List<String>.from(snapshot.data()!["superUser"]);
    this.user = List<String>.from(snapshot.data()!["user"]);
    this.rateListCategory = Map<String, List<String>>();
    this.storeTypes?.forEach((category) {
      this.rateListCategory?.putIfAbsent(category.name!, () {
        return List<String>.from(
            snapshot.data()!["rateListCategory"][category.name] ?? []);
      });
    });
    this.customerCare = snapshot.data()!["customerCare"];
    this.commissionPercent =
        (snapshot.data()!["commissionPercent"] ?? 10).toDouble();
    assert(this.commissionPercent! >= 0 && this.commissionPercent! <= 100);
    this.fixedSubscriptionCommission =
        (snapshot.data()!["fixedSubscriptionCommission"] ?? 80).toDouble();
    // print("Admin data: ${this.toJson()}");
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     "T&C": this.tc,
  //     "legalAgreement": this.agreement,
  //     "iOSAppUrl": this.iOSAppUrl,
  //     "androidAppUrl": this.androidAppUrl,
  //     "discountOnOrderOnly": this.discountOnOrderOnly,
  //     "commissionPercent": this.commissionPercent,
  //     "razorAPIKey": this.razorAPIKey,
  //     "rateListCategory": this.rateListCategory,
  //     "reward": this.reward.toJson(),
  //     "featureOffer":
  //         List<dynamic>.from(this.featureOffer.map((e) => e.toJson())),
  //     "FAQ": List<dynamic>.from(this.faq.map((o) => o.toJson())),
  //     "socialLinks": List<dynamic>.from(this.social.map((o) => o.toJson())),
  //     "superUser": List<String>.from(this.superUser),
  //     "user": List<String>.from(this.user),
  //     "customerCare": this.customerCare,
  //     "storeTypes": List<dynamic>.from(this.storeTypes.map((e) => e.toJson())),
  //     // "storeCategories": List<String>.from(this.storeCategories),
  //   };
  // }
}

class StoreType {
  String? name;
  String? icon;

  StoreType({
    this.name,
    this.icon,
  });

  StoreType.fromMap(Map<String, dynamic> map) {
    this.name = map["name"];
    this.icon = map["icon"];
  }

  toJson() {
    return {
      "name": this.name,
      "icon": this.icon,
    };
  }
}

class FeaturedOffer {
  String? storeId;
  String? status;

  FeaturedOffer({
    this.status,
    this.storeId,
  });

  FeaturedOffer.fromMap(Map<String, dynamic> map) {
    this.storeId = map["storeId"];
    this.status = map["status"];
  }

  toJson() {
    return {
      "storeId": this.storeId,
      "status": this.status,
    };
  }
}
