import 'package:flutter/material.dart';

class NoNetwork extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "You're offline",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "No Internet found. Check your connection or try again. \n It will automatically detect your network.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15),
                ),

                // OutlineButton(
                //   child: Text(
                //     "RETRY",
                //     style: TextStyle(
                //       color: Colors.black,
                //     ),
                //   ),
                //   onPressed: () {
                //     AppSettings.openWIFISettings();
                //     Navigator.of(context).pop();
                //   },
                // ),
              ],
            ),
          ),
          Positioned(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset(
                  "assets/Images/ic_launcher_foreground.png",
                  width: 30,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "Piety",
                  style: Theme.of(context).textTheme.titleMedium,
                )
              ],
            ),
            bottom: 40,
          )
        ],
      ),
    );
  }
}
