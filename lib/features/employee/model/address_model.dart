import 'package:isar/isar.dart';
import 'geo_model.dart';

part 'address_model.g.dart';

@embedded
class AddressModel {
  String? street;
  String? suite;
  String? city;
  String? zipcode;
  GeoModel? geo;

  AddressModel({this.street, this.suite, this.city, this.zipcode, this.geo});

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      street: json['street'] as String?,
      suite: json['suite'] as String?,
      city: json['city'] as String?,
      zipcode: json['zipcode'] as String?,
      geo: json['geo'] != null ? GeoModel.fromJson(json['geo'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'suite': suite,
      'city': city,
      'zipcode': zipcode,
      'geo': geo?.toJson(),
    };
  }
}
