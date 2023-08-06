import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '/BloCLayer/UserBloc.dart';
import '/BloCLayer/UserEvent.dart';
import '/DataLayer/Models/UserModels/PhoneNumber.dart';
import '/DataLayer/Models/UserModels/User.dart';
import '/const.dart';

class SignInMethods {
  static String? _phoneVerificationID;

  static Future<void> autoVerifyPhone({
    @required String? countryCode,
    @required String? phoneNumber,
    @required UserBloc? userBloc,
  }) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    print("Phone: ${countryCode! + phoneNumber!}");
    await _auth.verifyPhoneNumber(
      phoneNumber: countryCode + phoneNumber,
      codeSent: (String verficationID, [int? resendcodeTimeout]) {
        print("Code Sent to device");
        SignInMethods._phoneVerificationID = verficationID;
      },
      timeout: Duration(minutes: 1),
      verificationFailed: (FirebaseAuthException exception) {
        print("Verification Failed: ${exception.message}");
        Fluttertoast.showToast(
          msg: "${exception.message}",
        );
      },
      verificationCompleted: (AuthCredential credentials) async {
        try {
          // userBloc.userEventSink.add(PhoneSignedIn());
          // var v = PhoneSignedIn();
          UserCredential res =
              await FirebaseAuth.instance.signInWithCredential(credentials);
          // print("UID:: " + res.user.uid);
          await FirebaseFirestore.instance
              .collection("customers")
              .doc(res.user.uid)
              .get()
              .then((value) {
            // print("retured value::::" + value.exists.toString());
            if (!value.exists) {
              //print("You are a new User");
              userBloc!.mapEventToState(
                AddUserDetails(
                  user: User2(
                    uid: res.user.uid,
                    //addresses: [],
                    fcmToken: Constants.fcmToken!,
                    orderCount: 10,
                    joiningDate: DateTime.now(),
                    phoneNumbers: [
                      PhoneNumber(
                        number: res.user.phoneNumber.substring(
                          res.user.phoneNumber.length - 10,
                        ),
                        countryCode: res.user.phoneNumber.substring(
                          0,
                          res.user.phoneNumber.length - 10,
                        ),
                      ),
                    ],
                  ),
                ),
              );
              userBloc.initDynamicLinks();
            } else {
              //print("Exising User");
              userBloc!.mapEventToState(GetUserDetails());
            }
          });
          print("Phone Verification Complete");
        } on PlatformException catch (e) {
          print("Caught error: ${e.message}");
        } on Exception catch (e) {
          print("Unknown error: $e");
        }
      },
      codeAutoRetrievalTimeout: (String verificaionID) {
        print("Timed out");
      },
    );
  }

  static Future<void> phoneWithOTP({
    required String otp,
    required UserBloc userBloc,
  }) async {
    try {
      AuthCredential authCredentials = PhoneAuthProvider.getCredential(
        verificationId: _phoneVerificationID,
        smsCode: otp,
      );
      UserCredential res =
          await FirebaseAuth.instance.signInWithCredential(authCredentials);
      // print("UID:: " + res.user.uid);
      await FirebaseFirestore.instance
          .collection("customers")
          .doc(res.user.uid)
          .get()
          .then((value) {
        // print("retured value::::" + value.exists.toString());
        if (!value.exists) {
          //print("You are a new User");
          userBloc.mapEventToState(
            AddUserDetails(
              user: User2(
                uid: res.user.uid,
                addresses: [],
                fcmToken: Constants.fcmToken!,
                orderCount: 10,
                joiningDate: DateTime.now(),
                phoneNumbers: [
                  PhoneNumber(
                    number: res.user.phoneNumber.substring(
                      res.user.phoneNumber.length - 10,
                    ),
                    countryCode: res.user.phoneNumber.substring(
                      0,
                      res.user.phoneNumber.length - 10,
                    ),
                  ),
                ],
              ),
            ),
          );
          userBloc.initDynamicLinks();
        } else {
          //print("Exising User");
          userBloc.mapEventToState(GetUserDetails());
        }
      });
    } on PlatformException catch (e) {
      Fluttertoast.showToast(msg: e.message!);
      print("Platform Exception: ${e.details}");
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message);
      print("Auth Exception: ${e.message}");
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: "Unknown Error");
      print("Unknown Exception: $e");
    }
  }
}
