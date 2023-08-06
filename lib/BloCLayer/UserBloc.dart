import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:modern_form_esys_flutter_share/modern_form_esys_flutter_share.dart';

import '/DataLayer/Models/Other/Enums.dart';
import '/DataLayer/Services/SignInMethods.dart';
import '../BloCLayer/UserEvent.dart';
import '../DataLayer/Models/UserModels/User.dart';
import '../DataLayer/Models/UserModels/UserAddress.dart';

class UserBloc extends Bloc {
  final databaseReference = FirebaseFirestore.instance;

  User? _firebaseUser;

  set setFirebaseUser(User user) {
    this._firebaseUser = user;
  }

  /// Returns the complete phone number along with country code
  String get getCompletePhone => this._firebaseUser!.phoneNumber ?? "unknown";

  /// Returns only the last 10 digits of the phone number stripping away the
  /// country code.
  String get getPhone =>
      this
          ._firebaseUser!
          .phoneNumber!
          .substring(getCompletePhone.length - 10) ??
      "unknown";

  String get getUid => this._firebaseUser!.uid ?? "unknown";
  User get firebaseUser => this._firebaseUser!;

  User2? _user;
  User2 get getUser => this._user!;

  User2? myUser;
  int index = 0;

  // getUserLocationIndex() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   int userAddressIndex = preferences.getInt("userAddressIndex") ?? 0;
  //   return userAddressIndex;
  // }

  // setUserLocationIndex(int selectedAddress) async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   preferences.setInt("userAddressIndex", selectedAddress);
  // }

  Placemark? userPlace;
  Placemark get getUserPlace => this.userPlace!;

  UserAddress? _selectedUserAddress;
  UserAddress get getSelectedUserAddress => _selectedUserAddress!;
  List<UserAddress>? _userAddressList;
  List<UserAddress> get getUserAllAddress => _userAddressList!;

  /// Event controllers
  StreamController<UserEvent> _userEventController =
      StreamController<UserEvent>.broadcast();
  StreamSink<UserEvent> get userEventSink => _userEventController.sink;
  Stream<UserEvent> get _userEventStream => _userEventController.stream;

  /// Phone sign in status controllers
  @Deprecated("Not of any use for customer app")
  StreamController<bool> _phoneSignController =
      StreamController<bool>.broadcast();
  @Deprecated("Not of any use for customer app")
  StreamSink<bool> get _phoneSignInSink => _phoneSignController.sink;
  @Deprecated("Not of any use for customer app")
  Stream<bool> get phoneSignInStream => _phoneSignController.stream;

  StreamController<User2> _userController = StreamController<User2>.broadcast();
  StreamSink<User2> get getUserSink => _userController.sink;
  Stream<User2> get getUserStream => _userController.stream;

  StreamController<Placemark> _positionController =
      StreamController<Placemark>.broadcast();
  StreamSink<Placemark> get positionSink => _positionController.sink;
  Stream<Placemark> get positionStream => _positionController.stream;

  StreamController<UserAddress> _selectedAddressController =
      StreamController<UserAddress>.broadcast();
  StreamSink<UserAddress> get selectedAddressSink =>
      _selectedAddressController.sink;
  Stream<UserAddress> get selectedAddressStream =>
      _selectedAddressController.stream;

  StreamController<List<UserAddress>> _allAddressController =
      StreamController<List<UserAddress>>.broadcast();
  StreamSink get allAddressSink => _allAddressController.sink;
  Stream get allAddressStream => _allAddressController.stream;

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  UserBloc.initialize() {
    mapEventToState(GetUserDetails());
    // mapEventToState(GetUserLocation());
    _userEventStream.listen(_mapUserEventToState);
  }

  // UserBloc.initialize() {
  //   _userEventStream.listen(_mapUserEventToState);
  // }

  void _mapUserEventToState(UserEvent event) async {
    if (event is PhoneSignedIn) {
      _phoneSignInSink.add(true);
    }

    if (event is SignOut) {
      await FirebaseAuth.instance.signOut();
    }

    if (event is UpdatePhoneNumber) {
      SignInMethods.autoVerifyPhone(
        countryCode: event.countryCode,
        phoneNumber: event.phoneNumber,
        userBloc: this,
        // userBloc: this,
      );
    }
  }

  void mapEventToState(UserEvent event) async {
    if (event is UpdateFcmToken) {
      await databaseReference.collection("customers").doc(event.userId).set(
        {
          "fcmToken": event.fcmToken,
          "uid": event.userId,
        },
        SetOptions(merge: true),
      );
    } else if (event is AddUserDetails) {
      await databaseReference
          .collection("customers")
          .doc(event.user.uid)
          .set(event.user.toJson(event.user.uid!), SetOptions(merge: true))
          .then((onValue) async {
        //_user = event.user;
        print("ADD USER DETAILS" + _user.toString());
      }).then((value) async {
        DocumentSnapshot user = await FirebaseFirestore.instance
            .collection("customers")
            .doc(event.user.uid)
            .get();
        User2 newUser = User2.fromMap(user.data());
        _user = newUser;
        getUserSink.add(newUser);
      });
    } else if (event is GetUserLocation) {
      print("Event is ${event.toString()}");
      geolocator
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
          .then((Position position) {
        geolocator
            .placemarkFromCoordinates(position.latitude, position.longitude)
            .then((p) async {
          Placemark place = p[0];
          print(
              " ${place.name}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}");
          userPlace = place;
          _selectedUserAddress = UserAddress(
              addressType: AddressType.home,
              houseNo: null,
              landmark: null,
              locality: place.subLocality,
              city: place.locality,
              state: place.administrativeArea,
              postalCode: place.postalCode);
          selectedAddressSink.add(_selectedUserAddress!);
          positionSink.add(place);

          getUserStream.listen((myUser) async {
            List<UserAddress> currentAddresses = myUser.addresses ?? [];
            //print("MY USER CALLED IN GET USER STREAM");
            if (!myUser.addresses!.contains(_selectedUserAddress)) {
              currentAddresses.add(_selectedUserAddress!);
              print("cuurent address::  " + currentAddresses.toString());
              await databaseReference
                  .collection("customers")
                  .doc(_user!.uid)
                  .update(
                {
                  "addresses": FieldValue.arrayUnion([currentAddresses])
                },
              ).then((onValue) async {
                //  _user = newUser;
                print("GET USER LOCATION" + _user.toString());
              });
            }
          });
        });
      }).catchError((e) {
        print(e);
      });
    } else if (event is GetUserDetails) {
      await FirebaseAuth.instance.authStateChanges().listen((user) async {
        await user.getIdToken()?.then((token) async {
          FirebaseFirestore.instance
              .collection("customers")
              .doc(user.uid)
              .snapshots()
              .listen((DocumentSnapshot snapshot) {
            _userAddressList = [];
            User2 newUser = User2.fromMap(snapshot.data());
            if (newUser.addresses == null && newUser.addresses!.isEmpty) {
              mapEventToState(GetUserLocation());
            } else {
              print("Else Part call");
            }
            for (var i = 0; i < newUser.addresses!.length; i++) {
              _userAddressList!.add(newUser.addresses![i]);
            }
            allAddressSink.add(_userAddressList);
            // print(newUser.toString());
            _user = newUser;
            getUserSink.add(newUser);
          });
        });
      });
    } else if (event is AddAddress) {
      FirebaseFirestore.instance.collection("customers").doc(_user!.uid).set({
        "addresses": FieldValue.arrayUnion([event.newAddress.toJson()])
      }, SetOptions(merge: true)).then(
          (value) => Fluttertoast.showToast(msg: "Address Added"));
    } else if (event is UpdateAddress) {
      FirebaseFirestore.instance.collection("customers").doc(_user!.uid).set({
        "addresses": FieldValue.arrayRemove([event.deleteAddress.toJson()])
      }, SetOptions(merge: true)).then((value) => FirebaseFirestore.instance
              .collection("customers")
              .doc(_user!.uid)
              .set({
            "addresses": FieldValue.arrayUnion([event.address.toJson()])
          }, SetOptions(merge: true)).then(
                  (value) => Fluttertoast.showToast(msg: "Address Updated")));
    } else if (event is AddUserAddress) {
      List<UserAddress> currentAddresses = _user!.addresses ?? [];
      currentAddresses.add(event.address);
      //we should remove this and just update address instread of recreating whole user document.
      User2 newUser = User2(
        uid: event.user.uid,
        name: event.user.name,
        phoneNumbers: event.user.phoneNumbers,
        joiningDate: event.user.joiningDate,
        addresses: currentAddresses,
        userType: event.user.userType,
        fcmToken: event.user.fcmToken,
        orderCount: event.user.orderCount,
        pietyCoinsEarned: event.user.pietyCoinsEarned,
        pietyCoinsRedeemed: event.user.pietyCoinsRedeemed,
        rating: event.user.rating,
        referCode: event.user.referCode,
        referredBy: event.user.referredBy,
        referredTo: event.user.referredTo,
      );
      print("Add user addess" + newUser.toString());
      await databaseReference
          .collection("customers")
          .doc(event.user.uid)
          .set(newUser.toJson(_user!.uid!), SetOptions(merge: true))
          .then((onValue) async {
        // _user = newUser;
        print("ADD USER ADDRESS" + _user.toString());
      });
      // getUserStream.listen((user) {
      //   myUser = user;
      //   print(myUser);
      // });
    } else if (event is ChangeUserName) {
      User2 newUser = User2(
        uid: _user!.uid,
        phoneNumbers: _user!.phoneNumbers,
        joiningDate: _user!.joiningDate,
        addresses: _user!.addresses,
        userType: _user!.userType,
        fcmToken: _user!.fcmToken,
        name: event.name,
        orderCount: _user!.orderCount,
        pietyCoinsEarned: _user!.pietyCoinsEarned,
        pietyCoinsRedeemed: _user!.pietyCoinsRedeemed,
        rating: _user!.rating,
        referCode: _user!.referCode,
        referredBy: _user!.referredBy,
        referredTo: _user!.referredTo,
      );
      print("Chnaged User NAME::: " + newUser.toString());
      await databaseReference
          .collection("customers")
          .doc(_user!.uid)
          .set(newUser.toJson(_user!.uid!), SetOptions(merge: true))
          .then((onValue) async {
        // _user = newUser;
        print("CHANGE NAME" + _user.toString());
        // getUserSink.add(newUser);
      });
      // getUserStream.listen((user) {
      //   myUser = user;
      //   //print(myUser);
      // });
    } else if (event is SelectUserAddress) {
      // setUserLocationIndex(event.index);
      // int userIndex = await getUserLocationIndex();
      // index = event.index;
      ///TODO @narayan i think you forget to check for null address here if its null
      ///then use current location
      _selectedUserAddress = _user!.addresses![event.index];
      print("selectedAddress:: " + _selectedUserAddress!.displayAddress());
      List<Placemark> place = await geolocator.placemarkFromAddress(
          _user!.addresses![event.index].displayAddress());
      selectedAddressSink.add(_user!.addresses![event.index]);
      userPlace = place[0];
      positionSink.add(place[0]);
      Fluttertoast.showToast(msg: "Location Changed");
    } else if (event is AddAddressByLatLng) {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          event.latLng.latitude, event.latLng.longitude);

      Placemark place = p[0];
      print(
          "Address is :  ${place.name}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}");

      _selectedUserAddress = UserAddress(
        addressType: AddressType.other,
        houseNo: "",
        landmark: place.name,
        locality: place.subLocality,
        city: place.locality,
        state: place.administrativeArea,
        postalCode: place.postalCode,
      );
      selectedAddressSink.add(_selectedUserAddress!);
      positionSink.add(place);
      List<UserAddress> currentAddresses = _user!.addresses ?? [];
      if (!_user!.addresses!.contains(_selectedUserAddress)) {
        currentAddresses.removeWhere((e) => e.addressType == AddressType.other);
        currentAddresses.add(_selectedUserAddress!);
      }
      User2 newUser = User2(
        uid: _user!.uid,
        phoneNumbers: _user!.phoneNumbers,
        joiningDate: _user!.joiningDate,
        addresses: currentAddresses,
        userType: _user!.userType,
        fcmToken: _user!.fcmToken,
        name: _user!.name,
        orderCount: _user!.orderCount,
        pietyCoinsEarned: _user!.pietyCoinsEarned,
        pietyCoinsRedeemed: _user!.pietyCoinsRedeemed,
        rating: _user!.rating,
        referCode: _user!.referCode,
        referredTo: _user!.referredTo,
        referredBy: _user!.referredBy,
      );
      // print(newUser);
      await databaseReference
          .collection("customers")
          .doc(_user!.uid)
          .set(newUser.toJson(_user!.uid!), SetOptions(merge: true))
          .then((onValue) async {
        // _user = newUser;
        print("ADD ADDRESS BY LAN LAG" + _user.toString());
      });
    } else if (event is ShareOnWhatsapp) {
      final Uri result = await createDynamicLink(_user!.uid!);
      _shareText(result.toString());
    }
  }

  void initDynamicLinks() async {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri? deepLink = dynamicLink.link;

      if (deepLink != null) {
        print('_handleDeepLink | deeplink: $deepLink');
        String referredByUserId = deepLink.queryParameters["username"]!;
        if (_user!.uid != referredByUserId && _user!.referredBy == null) {
          _user!.referredBy = referredByUserId;
          print("Referred By user Id : $referredByUserId");
          await databaseReference
              .collection("customers")
              .doc(_user!.uid)
              .update({"referredBy": _user!.referredBy}).then((onValue) {
            print("Updated User is : ${_user.toString()}");
          });
          User2 tempUser;
          await databaseReference
              .collection('customers')
              .doc(referredByUserId)
              .get()
              .then((DocumentSnapshot snapshot) async {
            tempUser = User2.fromMap(snapshot.data());
            List<String> referredTo = tempUser.referredTo!;
            double pietyCoinsEarned =
                double.parse(tempUser.pietyCoinsEarned!) ?? 0;
            print("Data Fetched");
            if (!referredTo.contains(_user!.uid)) {
              await databaseReference
                  .collection('customers')
                  .doc(referredByUserId)
                  .set({
                'referredTo': FieldValue.arrayUnion([_user!.uid]),
                'pietyCoinsEarned': pietyCoinsEarned + 10,
              }, SetOptions(merge: true)).then((onValue) {
                print("User Referred Successfully");
              });
            }
          });
        } else {
          print("You are in goddamn trouble");
        }
      } else {
        print("You are playing with fire sir");
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });
  }

  Future<Uri> createDynamicLink(String userId) async {
    final link = Uri.parse(
        "https://piety.page.link/?link=https://piety.page.link/inviteapp?username=$userId&apn=com.piety.piety");
    final ShortDynamicLink shortenedLink =
        await DynamicLinkParameters.shortenUrl(
      link,
      DynamicLinkParametersOptions(
          shortDynamicLinkPathLength: ShortDynamicLinkPathLength.unguessable),
    );
    return shortenedLink.shortUrl;
  }

  Future<void> _shareText(String text) async {
    try {
      Share.text('To earn the Piety Coins, Share', text, 'text/plain');
    } catch (e) {
      print('error: $e');
    }
  }

  @override
  void dispose() {
    _userController.close();
    _positionController.close();
    _selectedAddressController.close();
    _allAddressController.close();
    _phoneSignController.close();
    _userEventController.close();
  }
}
