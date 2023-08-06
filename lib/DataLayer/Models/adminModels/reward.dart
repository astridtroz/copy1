
import 'package:flutter/foundation.dart';

class Reward {
  int? minCoin;
  double? valueOfCoin;
  List<String>? instructionStore;
  Reward({
    required this.minCoin,
    required this.valueOfCoin,
    required this.instructionStore,
  });

  Reward.fromMap(Map<String, dynamic> map) {
    this.minCoin = map["minCoin"];
    this.valueOfCoin = map["valueOfCoin"];
    this.instructionStore = List<String>.from(map["instructionStore"]);
  }
  Map<String, dynamic> toJson() {
    return {
      "minCoin": this.minCoin,
      "valueOfCoin": this.valueOfCoin,
      "instructionStore": List<String>.from(this.instructionStore!),
    };
  }
}
