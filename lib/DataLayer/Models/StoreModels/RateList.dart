import 'package:cloud_firestore/cloud_firestore.dart';

class RateList {
  String? rateListType;
  String? storeId;
  List<RateListItem>? rateListItem;
  List<String>? categoryList;
  Map<String, dynamic>? _cumulativeRateList;

  Map<String, List<RateListItem>> get cumulativeRateList {
    return Map<String, List<RateListItem>>.from(this._cumulativeRateList!);
  }

  RateList({
    this.storeId,
    required this.categoryList,
    required this.rateListItem,
    required this.rateListType,
  });

  RateList.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    this.rateListType = snapshot.data()!["rateListType"];
    this.storeId = snapshot.data()!["storeId"];
    this.categoryList = [];
    if (snapshot.data()!["categoryList"] != null &&
        snapshot.data()!["categoryList"].isNotEmpty) {
      for (int i = 0; i < snapshot.data()!["categoryList"].length; i++) {
        categoryList?.add(snapshot.data()!["categoryList"][i]);
      }
    }
    // print("category: $categoryList");
    this.rateListItem = [];
    for (int i = 0; i < snapshot.data()!["rateListItem"].length; i++) {
      rateListItem
          ?.add(RateListItem.fromMap(snapshot.data()!["rateListItem"][i]));
    }

    /// Initializing cumulative ratelist
    _cumulativeRateList = Map<String, dynamic>();
    categoryList?.forEach((String category) {
      List<RateListItem> temp = [];
      temp.addAll(this.rateListItem!);
      temp.retainWhere((item) {
        // print("item.categoryName: ${item.categoryName} category: $category");
        return item.categoryName == category;
      });
      // print("rateList.dart: temp: ${temp}");
      // this._cumulativeRateList.putIfAbsent(category, () => temp);
      // print("temp after $category retain: ${temp}");
      // this._cumulativeRateList[category] = temp.map((item) {
      //   return item.toJson();
      // }).toList();
      this._cumulativeRateList![category] = List<RateListItem>.from(temp);
    });
    // print("rateList.dart Cumulative: ${_cumulativeRateList}");
    // print("rateList.dart Dry Cleaning: ${_cumulativeRateList["Dry Cleaning"][0].serviceRate.fixed}");

    // print("rateList.dart Cumulative: ${_cumulativeRateList["Dry Cleaning"][0].serviceName}");
  }

  Map<String, dynamic> toJson(String storeID) {
    return {
      "rateListType": this.rateListType,
      "storeId": storeID,
      // "categoryList": List<String>.from(this.categoryList),
      "rateListItems":
          List<dynamic>.from(this.rateListItem!.map((r) => r.toJson())),
    };
  }

  @override
  String toString() {
    return '''
      rateListType: $rateListType,
      storeId: $storeId,
      rateListItem: $rateListItem,
      categoryList: $categoryList,
      _cumulativeRateList: $_cumulativeRateList,
    ''';
  }
}

class RateListItem {
  String? categoryName;
  String? serviceName;
  ServiceRate? serviceRate;
  String? imageUrl;
  RateListItem({
    required this.categoryName,
    required this.serviceName,
    required this.serviceRate,
    this.imageUrl,
  });

  RateListItem.fromMap(Map<String, dynamic> map) {
    this.categoryName = map["categoryName"];
    this.serviceName = map["serviceName"];
    this.serviceRate = ServiceRate.fromMap(map["serviceRate"]);
    this.imageUrl = map["imageUrl"];
  }

  Map<String, dynamic> toJson() {
    return {
      "serviceRate": this.serviceRate?.toJson(),
      "serviceName": this.serviceName,
      "categoryName": this.categoryName,
      "imageUrl": this.imageUrl,
    };
  }

  @override
  String toString() {
    return 'RateListItem{categoryName: $categoryName, serviceName: $serviceName, serviceRate: $serviceRate}';
  }
}

class ServiceRate {
  bool? isFixed;
  double? low;
  double? high;
  double? fixed;

  ServiceRate({
    required this.isFixed,
    this.fixed,
    this.high,
    this.low,
  }) {
    //assert(this.isFixed == false && this.fixed == null);
    //assert(this.isFixed == true && this.fixed != null);
    assert(this.fixed != null || (this.low != null && this.high != null));
  }

  ServiceRate.fromMap(Map<String, dynamic> map) {
    this.isFixed = map["isFixed"];
    this.low = map["low"] != null ? (map["low"]).toDouble() : null;
    this.high = map["high"] != null ? (map["high"]).toDouble() : null;
    this.fixed = map["fixed"] != null ? (map["fixed"]).toDouble() : null;
  }

  Map<String, dynamic> toJson() {
    return {
      "isFixed": this.isFixed,
      "low": this.low,
      "high": this.high,
      "fixed": this.fixed,
    };
  }
}
