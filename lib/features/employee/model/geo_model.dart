import 'package:isar/isar.dart';

part 'geo_model.g.dart';

@embedded
class GeoModel {
  String? lat;
  String? lng;

  GeoModel({this.lat, this.lng});

  factory GeoModel.fromJson(Map<String, dynamic> json) {
    return GeoModel(
      lat: json['lat'] as String?,
      lng: json['lng'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
    };
  }
}
