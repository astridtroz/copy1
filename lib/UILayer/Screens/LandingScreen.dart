import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'HomeScreens/HomeScreen.dart';
import 'ReferScreen.dart';
import 'SettingsScreens/SettingsScreen.dart';
import 'TrackOrderScreens/TrackOrdersScreen.dart';

class LandingScreen extends StatefulWidget {
  static String route = "landing_screen";
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  //UserBloc _userBloc;
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    TrackOrdersScreen(),
    ReferScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // _userBloc = BlocProvider.of<UserBloc>(context);
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
        ]),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
                gap: 8,
                activeColor: Colors.black,
                iconSize: 24,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                duration: Duration(milliseconds: 700),
                tabBackgroundColor: Colors.cyan[200]!,
                tabs: [
                  GButton(
                    icon: Icons.home,
                    text: 'Suvidha',
                  ),
                  GButton(
                    icon: Icons.history_sharp,
                    text: 'My Orders',
                  ),
                  GButton(
                    icon: Icons.local_offer_sharp,
                    text: 'Offer',
                  ),
                  GButton(
                    icon: Icons.settings,
                    text: 'Settings',
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                }),
          ),
        ),
      ),
    );
  }
}
