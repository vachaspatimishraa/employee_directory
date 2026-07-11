import 'package:isar/isar.dart';

part 'admin_user_model.g.dart';

@collection
class AdminUserModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  String email;

  String password;
  
  String? name;
  String? phone;
  String? company;
  String? designation;
  String? website;
  String? street;
  String? suite;
  String? city;
  String? zipcode;

  AdminUserModel({
    required this.email,
    required this.password,
    this.name,
    this.phone,
    this.company,
    this.designation,
    this.website,
    this.street,
    this.suite,
    this.city,
    this.zipcode,
  });
}
