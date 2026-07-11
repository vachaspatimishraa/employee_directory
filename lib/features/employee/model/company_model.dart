import 'package:isar/isar.dart';

part 'company_model.g.dart';

@embedded
class CompanyModel {
  String? name;
  String? catchPhrase;
  String? bs;

  CompanyModel({this.name, this.catchPhrase, this.bs});

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      name: json['name'] as String?,
      catchPhrase: json['catchPhrase'] as String?,
      bs: json['bs'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'catchPhrase': catchPhrase,
      'bs': bs,
    };
  }
}
