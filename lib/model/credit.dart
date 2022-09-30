import 'package:greece/model/company.dart';
import 'package:greece/model/entity.dart';
import 'package:greece/model/user.dart';

class Credit extends Entity {
  int id;
  Company? company;
  double principal;
  double interest;
  int period_days;
  String creditStatus;

  Credit(
      {required this.id,
      this.company,
      required this.principal,
      required this.interest,
      required this.period_days,
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
        interest: json['interest'].toDouble(),
        period_days: json['period_days'],
        principal: json['principal'].toDouble());
  }
}
