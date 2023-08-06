import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

const bgColor = Color(0xfff3f5f9);
const titleColor = Colors.black;
const themeColor = Colors.cyan;
const subtitleColor = Colors.deepPurple;
const col = Colors.grey;
const color = Color(0xfff3f5f9);

class Constants {
  static const String folderName = "Piety";

  static const String mapsAPIkey = "AIzaSyBKI191Af805JYym_vbEA6g7eJqlhj2quM";
  static String? fcmToken;
  static const Color bgColor = Color.fromRGBO(220, 220, 220, 1);
  static const Color tabGreenColor = Color.fromRGBO(105, 105, 105, 1);
  static const Color tabIndicatorColor = Color.fromRGBO(44, 182, 16, 1);
  static const Color themeColor = Color.fromRGBO(145, 120, 152, 1);
  static const double borderCurvature = 8.0;
  static final BorderRadius constBorderRadius =
      BorderRadius.circular(borderCurvature);

  static final GlobalKey<ScaffoldState> scaffoldKey =
      new GlobalKey<ScaffoldState>();

  /// Return a string after converting [dateTime] to
  /// format `Apr 21, 2020 5:33 PM` for better UX.
  static String toFancyDate(DateTime dateTime) {
    return DateFormat.yMMMd().add_jm().format(dateTime);
  }

  static String toFancyDate1(DateTime dateTime) {
    return DateFormat.yMMMd().format(dateTime);
  }

  /// Function to convert camel case sentence to sentence case.
  /// Reason for creation is to convert enum string in cameCase
  /// to user displayable format like Title case.
  static String camelCaseToTitleCase(String camelCase) {
    List<String> words;
    // There are better accurate ways to do it like discribed here
    // https://stackoverflow.com/questions/7593969/regex-to-split-camelcase-or-titlecase-advanced
    // But I have used the simplest version. This one splits at small letter capital and letter interface
    words = camelCase.split(RegExp("(?<!^)(?=[A-Z])"));
    String sentence = "";
    // Make the first letter of first word capital to get TitleCase
    words[0] =
        words[0].replaceFirst(RegExp("[a-z]"), words[0][0].toUpperCase());
    // Append all words to make TitleCase
    words.forEach((String w) {
      sentence += w + " ";
    });
    return sentence;
  }

  /// Return the difference of [dateTime] and [DateTime.now()] as
  /// a relative time string. eg: few minutes ago, an hour ago etc.
  static String toRelativeDate(DateTime dateTime) {
    Duration _difference = DateTime.now().difference(dateTime);
    // if(difference.)
    throw UnimplementedError("Relative date function is WIP");
  }

  static double precisionOfTwo(double val) {
    double fraction = val - val.floor();
    int x = (fraction * 100).floor();
    double rounded = val.floor() + x / 100;
    return rounded;
  }

  static final Uint8List transparentImage = Uint8List.fromList(<int>[
    0x89,
    0x50,
    0x4E,
    0x47,
    0x0D,
    0x0A,
    0x1A,
    0x0A,
    0x00,
    0x00,
    0x00,
    0x0D,
    0x49,
    0x48,
    0x44,
    0x52,
    0x00,
    0x00,
    0x00,
    0x01,
    0x00,
    0x00,
    0x00,
    0x01,
    0x08,
    0x06,
    0x00,
    0x00,
    0x00,
    0x1F,
    0x15,
    0xC4,
    0x89,
    0x00,
    0x00,
    0x00,
    0x0A,
    0x49,
    0x44,
    0x41,
    0x54,
    0x78,
    0x9C,
    0x63,
    0x00,
    0x01,
    0x00,
    0x00,
    0x05,
    0x00,
    0x01,
    0x0D,
    0x0A,
    0x2D,
    0xB4,
    0x00,
    0x00,
    0x00,
    0x00,
    0x49,
    0x45,
    0x4E,
    0x44,
    0xAE,
  ]);
}
