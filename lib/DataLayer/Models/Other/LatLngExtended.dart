import 'package:google_maps_flutter/google_maps_flutter.dart';

/// The sole purpose of creating this class is to
/// create a public [toJson()] method.
///
/// The reason for creating it is to be able to push
/// latitude and longitude data to FirebaseFirestore in the
/// form of a map instead of the default list form.
/// ```
/// {
///   "lat" : 55.0056,
///   "lng" : 55.0182,
/// }
/// ```
///
class LatLngExtended extends LatLng {
  LatLngExtended(double latitude, double longitude)
      : super(latitude, longitude);

  @override
  LatLngExtended.fromMap(Map<String, dynamic> map)
      : super((map["lat"]).toDouble(), (map["lng"]).toDouble());

  Map<String, dynamic> toJson() {
    return {
      "lat": this.latitude,
      "lng": this.longitude,
    };
  }
}
