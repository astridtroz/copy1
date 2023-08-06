class Wallet {
  String? userId;
  List<PietyCoins>? pietyCoins;
  List<ReferralReward>? referralReward;
}

class PietyCoins {
  String? orderId;
  int? coinsEarned;
}

class ReferralReward {
  String? referUid;
  String? reward;
}
