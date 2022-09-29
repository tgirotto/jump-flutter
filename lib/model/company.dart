import 'package:greece/model/company_type.dart';
import 'package:greece/model/entity.dart';
import 'package:greece/model/store.dart';

class Company extends Entity {
  int id;
  double creditScore;
  String name;
  CompanyType? companyType;

  Company(
      {required this.id,
      required this.name,
      this.companyType,
      required this.creditScore});

  static Company fromJson(Map<String, dynamic> json) {
    CompanyType? companyType;

    if (json['company_type'] != null) {
      companyType = CompanyType.fromJson(json['company_type']);
    }

    return Company(
        creditScore: json["credit_score"].toDouble(),
        id: json['id'],
        name: json['name'],
        companyType: companyType);
  }
}
