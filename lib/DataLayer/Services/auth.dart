import 'package:firebase_auth/firebase_auth.dart';

import '/DataLayer/Models/UserModels/User.dart';

abstract class AuthBase {
  Future<User2> currentUser();
  Future<User2> signInAnonymously();
  Future<void> signOut();
  Stream<User2> get onAuthStateChanged;
}

class Auth implements AuthBase {
  User2 _userFromFirebase(User user) {
    if (user == null) {
      return null!;
    }
    return User2(uid: user.uid);
  }

  @override
  Stream<User2> get onAuthStateChanged {
    return _firebaseAuth.onAuthStateChanged.map(_userFromFirebase);
  }

  final _firebaseAuth = FirebaseAuth.instance;
  Future<User2> currentUser() async {
    final user = await _firebaseAuth.currentUser;
    return _userFromFirebase(user);
  }

  @override
  Future<User2> signInAnonymously() async {
    final authResult = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  //SignIn
  signIn(AuthCredential authCreds) {
    FirebaseAuth.instance.signInWithCredential(authCreds);
  }

  @Deprecated("Use SignInMethods.phoneWithOTP instead")
  signInWithOTP(smsCode, verId) {
    AuthCredential authCreds = PhoneAuthProvider.getCredential(
        verificationId: verId, smsCode: smsCode);
    signIn(authCreds);
  }
}
