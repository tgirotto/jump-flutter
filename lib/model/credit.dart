import 'package:greece/model/company.dart';
import 'package:greece/model/entity.dart';
import 'package:greece/model/user.dart';

class Credit extends Entity {
  int id;
  Company? company;
  double principal;
  String creditStatus;

  Credit(
      {required this.id,
      this.company,
      required this.principal,
      required this.creditStatus});

  static Credit fromJson(Map<String, dynamic> json) {
    Company? company;

    if (json['company'] != null) {
      company = Company.fromJson(json['company']);
    }

    return Credit(
        id: json['id'],
        creditStatus: json['credit_status'],
        company: company,
        principal: json['principal'].toDouble());
  }
}
