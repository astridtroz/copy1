import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:launch_review/launch_review.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '/BloCLayer/AdminBloc.dart';
import '/DataLayer/Models/Other/Enums.dart';
import '/DataLayer/Models/adminModels/adminMetaData.dart';
import '/DataLayer/Services/HandleSignIn.dart';
import '/UILayer/Widgets/noNetwork.dart';
import '../../../BloCLayer/UserBloc.dart';
import '../../../BloCLayer/UserEvent.dart';
import '../../../DataLayer/Models/UserModels/User.dart';
import '../../../UILayer/Screens/SettingsScreens/UserProfileScreen.dart';

class SettingsScreen extends StatefulWidget {
  static String route = 'settings_screen';
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  UserBloc? _userBloc;

  Widget reusableContainer(String imageIcon, String text) {
    return Container(
      height: 30,
      padding: EdgeInsets.all(0),
      width: double.infinity,
      child: Row(
        children: <Widget>[
          //Icon(Icons.star, size: 22),
          Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imageIcon),
                fit: BoxFit.fill,
              ),
            ),
          ),
          // ElevatedButton(
          //   clipBehavior: Clip.antiAlias,
          //   shape: CircleBorder(),
          //   child: Image.asset(imageIcon),
          //   onPressed: null,
          // ),
          SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(fontSize: 15),
          ),
          Flexible(fit: FlexFit.tight, child: SizedBox()),
          Icon(Icons.arrow_forward_ios, size: 20),
        ],
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    AdminBloc _adminBloc = BlocProvider.of<AdminBloc>(context);
    var connectionStatus = Provider.of<ConnectivityStatus>(context);
    _userBloc = BlocProvider.of(context);
    return connectionStatus == ConnectivityStatus.offline
        ? NoNetwork()
        : SafeArea(
            child: ListView(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(0, 30, 0, 20),
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Column(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 40,
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          StreamBuilder<User2>(
                              initialData: _userBloc!.getUser,
                              stream: _userBloc!.getUserStream,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  if (snapshot.hasError) {
                                    return Text("Error Fetching");
                                  } else {
                                    return Text(
                                      snapshot.data!.name ?? "",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    );
                                  }
                                } else {
                                  return Text("Loading");
                                }
                              }),
                          SizedBox(width: 10),
                          InkWell(
                            child: Icon(Icons.border_color, size: 20),
                            onTap: () {
                              String? name;
                              showBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      height: 200,
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0, right: 8),
                                            child: FormBuilderTextField(
                                              initialValue: "",
                                              decoration: InputDecoration(
                                                hintText: "Change your Name",
                                                contentPadding:
                                                    EdgeInsets.all(8),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.0),
                                                ),
                                              ),
                                              onChanged: (val) => name = val,
                                              attribute: "name",
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          TextButton(
                                            onPressed: () {
                                              _userBloc!.mapEventToState(
                                                  ChangeUserName(name: name!));
                                              Navigator.pop(context);
                                            },
                                            child: Text("Submit"),
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                  width: double.infinity,
                  child: Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => UserProfileScreen())),
                        child: reusableContainer(
                            "assets/Icons/account.png", 'My Profile'),
                      ),
                      Divider(
                        color: Colors.grey,
                        endIndent: 10,
                        indent: 10,
                      ),
                      reusableContainer("assets/Icons/faq.png", "FAQ's"),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                  width: double.infinity,
                  child: Column(
                    children: <Widget>[
                      // reusableContainer(Icons.share, 'Refer and Earn'),
                      // Divider(
                      //   color: Colors.grey,
                      //   endIndent: 10,
                      //   indent: 10,
                      // ),
                      GestureDetector(
                        onTap: () {
                          return _launchURL(_adminBloc
                                  .getAdminMetaData.agreement ??
                              "https://www.google.com/search?safe=active&q=piety+innovation+labs");
                        },
                        child: reusableContainer(
                            "assets/Icons/legal.png", 'Legal Agreement'),
                      ),
                      Divider(
                        color: Colors.grey,
                        endIndent: 10,
                        indent: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          LaunchReview.launch();
                        },
                        child: reusableContainer(
                            "assets/Icons/review.png", 'Rate us on Play Store'),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: StreamBuilder<AdminMetaData>(
                      stream: _adminBloc.adminMetaDataStream,
                      initialData: _adminBloc.getAdminMetaData,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                            height: 50,
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot.data!.social?.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: ButtonTheme(
                                      height: 100,
                                      minWidth: 10,
                                      buttonColor: Colors.white,
                                      child: ElevatedButton(
                                        // padding: EdgeInsets.all(8),
                                        clipBehavior: Clip.antiAlias,
                                        // shape: CircleBorder(),
                                        child: CachedNetworkImage(
                                          imageUrl: snapshot.data!
                                              .social![index].icon as String,
                                        ),
                                        onPressed: () {
                                          _launchURL(snapshot
                                              .data!.social![index].link!);
                                        },
                                      ),
                                    ),
                                  );
                                }),
                          );
                        } else {
                          return LinearProgressIndicator();
                        }
                      }),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  // padding: EdgeInsets.all(3),
                  width: 250,
                  decoration: BoxDecoration(
                    color: Colors.deepOrangeAccent,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: StreamBuilder<User>(
                      stream: FirebaseAuth.instance.authStateChanges(),
                      builder:
                          (BuildContext context, AsyncSnapshot<User> snapshot) {
                        return TextButton(
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HandleSignIn()));
                          },
                          child: Text(
                            'LOG OUT',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }),
                ),
              ],
            ),
          );
  }
}
