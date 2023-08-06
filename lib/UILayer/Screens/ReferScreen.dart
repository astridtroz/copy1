import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:provider/provider.dart';

import '/BloCLayer/UserBloc.dart';
import '/BloCLayer/UserEvent.dart';
import '/DataLayer/Models/Other/Enums.dart';
import '/DataLayer/Models/UserModels/User.dart';
import '/UILayer/Widgets/noNetwork.dart';

class ReferScreen extends StatefulWidget {
  @override
  _ReferScreenState createState() => _ReferScreenState();
}

class _ReferScreenState extends State<ReferScreen> with WidgetsBindingObserver {
  UserBloc? _userBloc;
  @override
  Widget build(BuildContext context) {
    var connectionStatus = Provider.of<ConnectivityStatus>(context);
    _userBloc = BlocProvider.of<UserBloc>(context);
    User2 _user = _userBloc!.getUser;
    return connectionStatus == ConnectivityStatus.offline
        ? NoNetwork()
        : SafeArea(
            child: Scaffold(
              body: ListView(
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: Text(
                      "Want to have more Discount?",
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Text(
                      "Referring to a friend",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "can get you ",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        "PIETY COINS ",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Text(
                      "Invite your friends to experience the joys of Piety Laundry and you can gain PIETY COINS, which you can use to pay your Laundry Bills",
                      style: Theme.of(context).textTheme.subtitle1,
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: Text(
                      "Your Earnings upto now : ",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      "\u{20B9} ${_user.pietyCoinsEarned ?? 0}",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 60, right: 60),
                    child: TextButton.icon(
                      // color: Color(0xFF25d366),
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(10),
                      // ),
                      onPressed: () async {
                        print("Clicked");
                        _userBloc!.mapEventToState(ShareOnWhatsapp());
                      },
                      icon: FaIcon(
                        FontAwesomeIcons.whatsapp,
                        color: Colors.white,
                      ),
                      label: Text(
                        "Refer with WhatsApp",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
//                  Padding(
//                    padding: const EdgeInsets.only(left: 60, right: 60),
//                    child: CupertinoButton.filled.icon(
//                      shape: RoundedRectangleBorder(
//                        borderRadius: BorderRadius.circular(10),
//                      ),
//                      color: Color(0xFF3b5998),
//                      onPressed: () {},
//                      icon: FaIcon(
//                        FontAwesomeIcons.facebook,
//                        color: Colors.white,
//                      ),
//                      label: Text(
//                        "Refer with Facebook",
//                        style: TextStyle(color: Colors.white),
//                      ),
//                    ),
//                  ),
                  SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
          );
  }
}

//class ReferScreen extends StatefulWidget {
//  @override
//  _ReferScreenState createState() => _ReferScreenState();
//}
//
//class _ReferScreenState extends State<ReferScreen> {
//  @override
//  void initState() {
//    super.initState();
//    fetchLinkData();
//  }
//
//  void fetchLinkData() async {
//    // FirebaseDynamicLinks.getInitialLInk does a call to firebase to get us the real link because we have shortened it.
//    var link = await FirebaseDynamicLinks.instance.getInitialLink();
//
//    // This link may exist if the app was opened fresh so we'll want to handle it the same way onLink will.
//    handleLinkData(link);
//
//    // This will handle incoming links if the application is already opened
//    FirebaseDynamicLinks.instance.onLink(
//        onSuccess: (PendingDynamicLinkData dynamicLink) async {
//      handleLinkData(dynamicLink);
//    });
//  }
//
//  void handleLinkData(PendingDynamicLinkData data) {
//    final Uri uri = data?.link;
//    print(uri.toString());
////    if (uri != null) {
////      final queryParams = uri.queryParameters;
////      if (queryParams.length > 0) {
////        String userName = queryParams["username"];
////        // verify the username is parsed correctly
////        print("My users username is: $userName");
////      }
////    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("Sample"),
//      ),
//      body: Center(
//        child: Text("Test"),
//      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: () async {
//          var dynamicLink = await createDynamicLink();
//          // dynamicLink has been generated. share it with others to use it accordingly.
//          print("Dynamic Link: $dynamicLink");
//          _shareText(dynamicLink.toString());
//        },
//        child: Icon(
//          Icons.add,
//          color: Colors.white,
//        ),
//      ),
//    );
//  }
//
//  Future<void> _shareText(String text) async {
//    try {
//      Share.text('To earn the Piety Coins, Share', text, 'text/plain');
//    } catch (e) {
//      print('error: $e');
//    }
//  }
//
//  Future<Uri> createDynamicLink() async {
//    final DynamicLinkParameters parameters = DynamicLinkParameters(
//      // This should match firebase but without the username query param
//      uriPrefix: 'https://pietycustomerapplication.page.link',
//      // This can be whatever you want for the uri, https://yourapp.com/groupinvite?username=$userName
//      link: Uri.parse('https://pietycustomerapplication.page.link/web3'),
//      androidParameters: AndroidParameters(
//        packageName: 'com.example.pietycustomerapplication',
//        minimumVersion: 25,
//      ),
////      iosParameters: IosParameters(
////        bundleId: 'com.test.demo',
////        minimumVersion: '1',
////        appStoreId: '',
////      ),
//    );
//    final link = await parameters.buildUrl();
//    final ShortDynamicLink shortenedLink =
//        await DynamicLinkParameters.shortenUrl(
//      link,
//      DynamicLinkParametersOptions(
//          shortDynamicLinkPathLength: ShortDynamicLinkPathLength.unguessable),
//    );
//    return shortenedLink.shortUrl;
//  }
//}

//import 'dart:async';
//
//import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
//import 'package:url_launcher/url_launcher.dart';
//
//void main() {
//  runApp(
//    MaterialApp(
//      title: 'Dynamic Links Example',
//      routes: <String, WidgetBuilder>{
//        '/': (BuildContext context) => _MainScreen(),
//        '/helloworld': (BuildContext context) => _DynamicLinkScreen(),
//      },
//    ),
//  );
//}
//
//class _MainScreen extends StatefulWidget {
//  @override
//  State<StatefulWidget> createState() => _MainScreenState();
//}
//
//class _MainScreenState extends State<_MainScreen> {
//  String _linkMessage;
//  bool _isCreatingLink = false;
//  String _testString =
//      "To test: long press link and then copy and click from a non-browser "
//      "app. Make sure this isn't being tested on iOS simulator and iOS xcode "
//      "is properly setup. Look at firebase_dynamic_links/README.md for more "
//      "details.";
//
//  @override
//  void initState() {
//    super.initState();
//    initDynamicLinks();
//  }
//
//  void initDynamicLinks() async {
//    final PendingDynamicLinkData data =
//        await FirebaseDynamicLinks.instance.getInitialLink();
//    final Uri deepLink = data?.link;
//
//    if (deepLink != null) {
//      Navigator.pushNamed(context, deepLink.path);
//    }
//
//    FirebaseDynamicLinks.instance.onLink(
//        onSuccess: (PendingDynamicLinkData dynamicLink) async {
//      final Uri deepLink = dynamicLink?.link;
//
//      if (deepLink != null) {
//        Navigator.pushNamed(context, deepLink.path);
//      }
//    }, onError: (OnLinkErrorException e) async {
//      print('onLinkError');
//      print(e.message);
//    });
//  }
//
//  Future<void> _createDynamicLink(bool short) async {
//    setState(() {
//      _isCreatingLink = true;
//    });
//
//    final DynamicLinkParameters parameters = DynamicLinkParameters(
//      uriPrefix: 'https://laundrycustomerapp.page.link',
//      link: Uri.parse('https://laundrycustomerapp.page.link/web2'),
//      androidParameters: AndroidParameters(
//        packageName: 'com.example.pietycustomerapp',
//        minimumVersion: 25,
//      ),
//      dynamicLinkParametersOptions: DynamicLinkParametersOptions(
//        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
//      ),
//    );
//
//    Uri url;
//    if (short) {
//      final ShortDynamicLink shortLink = await parameters.buildShortLink();
//      url = shortLink.shortUrl;
//    } else {
//      url = await parameters.buildUrl();
//    }
//
//    setState(() {
//      _linkMessage = url.toString();
//      _isCreatingLink = false;
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Material(
//      child: Scaffold(
//        appBar: AppBar(
//          title: const Text('Dynamic Links Example'),
//        ),
//        body: Builder(builder: (BuildContext context) {
//          return Center(
//            child: Column(
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: <Widget>[
//                ButtonBar(
//                  alignment: MainAxisAlignment.center,
//                  children: <Widget>[
//                    ElevatedButton(
//                      onPressed: !_isCreatingLink
//                          ? () => _createDynamicLink(false)
//                          : null,
//                      child: const Text('Get Long Link'),
//                    ),
//                    ElevatedButton(
//                      onPressed: !_isCreatingLink
//                          ? () => _createDynamicLink(true)
//                          : null,
//                      child: const Text('Get Short Link'),
//                    ),
//                  ],
//                ),
//                InkWell(
//                  child: Text(
//                    _linkMessage ?? '',
//                    style: const TextStyle(color: Colors.blue),
//                  ),
//                  onTap: () async {
//                    if (_linkMessage != null) {
//                      await launch(_linkMessage);
//                    }
//                  },
//                  onLongPress: () {
//                    Clipboard.setData(ClipboardData(text: _linkMessage));
//                    Scaffold.of(context).showSnackBar(
//                      const SnackBar(content: Text('Copied Link!')),
//                    );
//                  },
//                ),
//                Text(_linkMessage == null ? '' : _testString)
//              ],
//            ),
//          );
//        }),
//      ),
//    );
//  }
//}
//
//class _DynamicLinkScreen extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Material(
//      child: Scaffold(
//        appBar: AppBar(
//          title: const Text('Hello World DeepLink'),
//        ),
//        body: const Center(
//          child: Text('Hello, World!'),
//        ),
//      ),
//    );
//  }
//}
