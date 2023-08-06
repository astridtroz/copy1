import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

import '/BloCLayer/AdminBloc.dart';
import '/BloCLayer/StoreBloc.dart';
import '/BloCLayer/StoreEvent.dart';
import '/BloCLayer/UserBloc.dart';
import '/BloCLayer/UserEvent.dart';
import '/UILayer/Screens/AuthenticationScreens/OnboardingScreen.dart';
import '/UILayer/Screens/SplashScreen.dart';

class HandleSignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserBloc _userBloc = BlocProvider.of<UserBloc>(context);
    StoreBloc _storeBloc = BlocProvider.of<StoreBloc>(context);
    AdminBloc _adminBloc = BlocProvider.of<AdminBloc>(context);

    return StreamBuilder<User>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.connectionState == ConnectionState.none) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          if (snapshot.hasData) {
            _userBloc.setFirebaseUser = snapshot.data!;
            _storeBloc.setUserBloc = _userBloc;
            _adminBloc.fetchMetaData().then(
              (value) {
                _storeBloc.setAdminBloc = _adminBloc;
                _userBloc.mapEventToState(GetUserLocation());
                _userBloc.allAddressStream.listen((event) {});
                _storeBloc.mapEventToState(GetAllStore());
                _storeBloc.mapEventToState(GetFeatureOfferList());
              },
            );

            return SplashScreen();
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text("Error signing in. Please try later"),
              ),
            );
          }
        }
        return OnboardingScreen();
      },
    );
  }
}
