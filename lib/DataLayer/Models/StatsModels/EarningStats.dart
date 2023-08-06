import 'package:flutter/foundation.dart';

class EarningStats {
  final int month;
  final double amount;
  EarningStats({required this.month, required this.amount})
      : assert(month >= 1 && month <= 12);

  @override
  String toString() {
    return 'EarningStats{month: $month, amount: $amount}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EarningStats &&
          runtimeType == other.runtimeType &&
          month == other.month &&
          amount == other.amount;

  @override
  int get hashCode => month.hashCode ^ amount.hashCode;
}
