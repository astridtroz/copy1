import 'package:flutter/foundation.dart';

class PhoneNumber {
  String? countryCode;
  String? number;

  PhoneNumber({
    this.countryCode,
    required this.number,
  }) {
    assert(number!.length == 10);
    assert(countryCode!.length >= 2 && countryCode!.length <= 4);
    assert(countryCode![0] == "+");
  }

  String phoneString() {
    return countryCode! + number!;
  }

  PhoneNumber.fromMap(Map<String, dynamic> map) {
    this.number = map["number"];
    this.countryCode = map["countryCode"];
  }

  Map<String, dynamic> toJson() {
    return {
      "countryCode": this.countryCode,
      "number": this.number,
    };
  }

  @override
  String toString() {
    return '''PhoneNumber{countryCode: $countryCode, number: $number}''';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhoneNumber &&
          runtimeType == other.runtimeType &&
          countryCode == other.countryCode &&
          number == other.number;

  @override
  int get hashCode => countryCode.hashCode ^ number.hashCode;
}
