import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '/BloCLayer/AdminBloc.dart';
import '/BloCLayer/StoreBloc.dart';
import '/BloCLayer/StoreEvent.dart';
import '/BloCLayer/UserBloc.dart';
import '/BloCLayer/UserEvent.dart';
import '/UILayer/Screens/LandingScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  FirebaseUser? user;
  AdminBloc? _adminBloc;
  StoreBloc? _storeBloc;
  UserBloc? _userBloc;
  bool _isLoading = true;

  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, _navigate);
  }

  void _navigate() async {
    if (!mounted) return;
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LandingScreen()));
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    _storeBloc = BlocProvider.of<StoreBloc>(context);
    _adminBloc = BlocProvider.of<AdminBloc>(context);
    _userBloc = BlocProvider.of<UserBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    _adminBloc!.fetchMetaData();
    _storeBloc!.mapEventToState(FetchLocalDB());
    _userBloc!.mapEventToState(GetUserDetails());
    startTime();

    return Scaffold(
        body: Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 200,
              width: 200,
              child: Image.asset('assets/Images/Logo.jpeg'),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              'Piety Innovation Labs',
              style: GoogleFonts.montserrat(
                fontSize: 22,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 80,
            ),
            SpinKitSquareCircle(
              color: Colors.white,
              size: 50.0,
              controller: AnimationController(
                  vsync: this, duration: const Duration(milliseconds: 1200)),
            ),
          ],
        ),
      ),
    ));
  }
}
