import 'package:flutter/foundation.dart';

class OrderStats {
  final int month;
  final int order;
  OrderStats({required this.month, required this.order})
      : assert(month >= 1 && month <= 12);

  @override
  String toString() {
    return 'OrderStats{month: $month, order: $order}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderStats &&
          runtimeType == other.runtimeType &&
          month == other.month &&
          order == other.order;

  @override
  int get hashCode => month.hashCode ^ order.hashCode;
}
