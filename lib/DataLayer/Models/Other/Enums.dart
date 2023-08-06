enum DeliveryMode {
  selfPickup,
  homeDelivery,
  unknown,
}

enum PaymentMode {
  cash,
  upi,
  pietyCoins,
  unknown,
}

enum PaymentStatus {
  paid,
  pending,
  failed,
  unknown,
}

enum OrderStatus {
  awaitingConfirmation,
  orderCancelled,
  orderPending,
  onTheWay,
  inProcess,
  cleaned,
  outForDelivery,
  delivered,
  unknown,
}

enum Role {
  owner,
  manager,
  unknown,
}

enum RatelistType {
  withCategory,
  withoutCategory,
}

enum DeliveryType {
  regular,
  express,
  unknown,
}

enum AddressType {
  home,
  work,
  other,
  unknown,
}

enum ServiceType {
  laundry,
  unknown,
}

enum UserType {
  registered,
  anonymous,
}

enum ConnectivityStatus {
  online,
  offline,
}
