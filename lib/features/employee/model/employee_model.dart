import 'package:isar/isar.dart';
import 'address_model.dart';
import 'company_model.dart';
import 'geo_model.dart';

part 'employee_model.g.dart';

@collection
class EmployeeModel {
  Id id;

  String? name;
  String? username;
  String? email;
  String? phone;
  String? website;
  AddressModel? address;
  CompanyModel? company;
  
  @Index()
  bool isFavorite;

  EmployeeModel({
    this.id = Isar.autoIncrement,
    this.name,
    this.username,
    this.email,
    this.phone,
    this.website,
    this.address,
    this.company,
    this.isFavorite = false,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'] as int? ?? Isar.autoIncrement,
      name: json['name'] as String?,
      username: json['username'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      website: json['website'] as String?,
      address: json['address'] != null ? AddressModel.fromJson(json['address'] as Map<String, dynamic>) : null,
      company: json['company'] != null ? CompanyModel.fromJson(json['company'] as Map<String, dynamic>) : null,
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id == Isar.autoIncrement ? null : id,
      'name': name,
      'username': username,
      'email': email,
      'phone': phone,
      'website': website,
      'address': address?.toJson(),
      'company': company?.toJson(),
      'isFavorite': isFavorite,
    };
  }

  EmployeeModel copyWith({
    Id? id,
    String? name,
    String? username,
    String? email,
    String? phone,
    String? website,
    AddressModel? address,
    CompanyModel? company,
    bool? isFavorite,
  }) {
    return EmployeeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      website: website ?? this.website,
      address: address ?? this.address,
      company: company ?? this.company,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
