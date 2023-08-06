import 'package:flutter/cupertino.dart';

class OrderStats {
  final String month;
  final int order;
  OrderStats({required this.month, required this.order});
}

class EarningStats {
  final String month;
  final double amount;
  EarningStats({required this.month, required this.amount});
}

//Dummy Datas
final orderData = [
  OrderStats(month: '1', order: 50),
  OrderStats(month: '2', order: 30),
  OrderStats(month: '3', order: 15),
  OrderStats(month: '4', order: 20),
  OrderStats(month: '5', order: 10),
];

final earningData = [
  EarningStats(month: '1', amount: 2000),
  EarningStats(month: '2', amount: 5000),
  EarningStats(month: '3', amount: 2500),
  EarningStats(month: '4', amount: 3500),
  EarningStats(month: '5', amount: 4500),
];
