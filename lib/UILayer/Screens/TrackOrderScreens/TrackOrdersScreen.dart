import 'package:flutter/material.dart';
import 'CurrentOrdersScreen.dart';
import 'PastOrdersScreen.dart';

class TrackOrdersScreen extends StatefulWidget {
  @override
  _TrackOrdersScreenState createState() => _TrackOrdersScreenState();
}

class _TrackOrdersScreenState extends State<TrackOrdersScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Colors.white,
              title: Text(
                'My Orders',
                style: TextStyle(
                  fontFamily: "OpenSansBold",
                  color: Colors.black,
                ),
              ),
              leading: Icon(
                Icons.shopping_cart,
                color: Colors.black,
              ),
              centerTitle: true,
              pinned: true,
              floating: false,
              // snap: true,
              // forceElevated: true,
              // actions: <Widget>[
              //   IconButton(
              //       icon: Icon(
              //         Icons.share,
              //         color: Colors.black,
              //       ),
              //       onPressed: () {})
              // ],
              bottom: TabBar(
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(width: 3.0),
                  insets: EdgeInsets.symmetric(horizontal: 16.0),
                ),
                indicatorColor: Colors.blueGrey,
                indicatorWeight: 5,
                labelColor: Colors.black,
                tabs: <Tab>[
                  Tab(text: "Current"),
                  Tab(text: "Past"),
                ],
                controller: _tabController,
              ),
            ),
          ];
        },
        body: TabBarView(
          children: <Widget>[
            CurrentOrdersScreen(),
            PastOrdersScreen(),
          ],
          controller: _tabController,
        ),
      ),
    );
  }
}
