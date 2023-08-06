
import 'package:flutter/foundation.dart';

class SocialLinksAdmin {
  String? icon;
  String? link;
  SocialLinksAdmin({
    required this.icon,
    required this.link,
  });

  SocialLinksAdmin.fromMap(Map<String, dynamic> map) {
    this.icon = map["icon"];
    this.link = map["link"];
  }

  Map<String, dynamic> toJson() {
    return {
      "icon": this.icon,
      "link": this.link,
    };
  }
}
