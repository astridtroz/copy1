import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../DataLayer/Models/UserModels/User.dart';
import '../DataLayer/Models/UserModels/UserAddress.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();
  @override
  List<Object>? get props => null;
}

class UpdateFcmToken extends UserEvent {
  final String fcmToken;
  final String userId;

  UpdateFcmToken({
    required this.fcmToken,
    required this.userId,
  });
}

class AddUserDetails extends UserEvent {
  final User2 user;
  AddUserDetails({required this.user}) : assert(user != null);
  @override
  List<Object> get props => [user];
}

class GetUserLocation extends UserEvent {}

class GetUserDetails extends UserEvent {}

class AddUserAddress extends UserEvent {
  final UserAddress address;
  final User2 user;
  AddUserAddress({required this.address, required this.user});
  @override
  List<Object> get props => [address, user];
}

class ChangeUserName extends UserEvent {
  final String name;
  ChangeUserName({required this.name});
  @override
  List<Object> get props => [name];
}

class SelectUserAddress extends UserEvent {
  final int index;
  SelectUserAddress({required this.index});
  @override
  List<Object> get props => [index];
}

class AddAddressByLatLng extends UserEvent {
  final LatLng latLng;
  AddAddressByLatLng({required this.latLng});
  @override
  List<Object> get props => [latLng];
}

class AddAddress extends UserEvent {
  final UserAddress newAddress;
  AddAddress({required this.newAddress});
}

class ShareOnWhatsapp extends UserEvent {}

class UpdateAddress extends UserEvent {
  final UserAddress deleteAddress;
  final UserAddress address;
  UpdateAddress({
    required this.deleteAddress,
    required this.address,
  });
}

@Deprecated(
    "This event is of no use in customer app. It's specific to store app")
class PhoneSignedIn extends UserEvent {}

class UpdatePhoneNumber extends UserEvent {
  final String phoneNumber;
  final String countryCode;

  UpdatePhoneNumber({
    required this.phoneNumber,
    this.countryCode = "+91",
  });
}

class SignOut extends UserEvent {}
