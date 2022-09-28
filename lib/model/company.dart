import 'package:greece/model/company_type.dart';
import 'package:greece/model/entity.dart';
import 'package:greece/model/store.dart';

class Company extends Entity {
  int id;
  String name;
  CompanyType? companyType;

  Company({required this.id, required this.name, this.companyType});

  static Company fromJson(Map<String, dynamic> json) {
    CompanyType? companyType;

    Company? company;

    if (json['company'] != null) {
      companyType = CompanyType.fromJson(json['company_type']);
    }

    return Company(
        id: json['id'], name: json['name'], companyType: companyType);
  }
}
