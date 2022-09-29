import 'package:greece/model/company.dart';
import 'package:greece/model/entity.dart';
import 'package:greece/model/user.dart';

class Loan extends Entity {
  int id;
  Company? company;
  User? customer;
  double principal;

  Loan(
      {required this.id, this.company, this.customer, required this.principal});

  static Loan fromJson(Map<String, dynamic> json) {
    Company? company;

    if (json['company'] != null) {
      company = Company.fromJson(json['company']);
    }

    User? customer;

    if (json['customer'] != null) {
      customer = User.fromJson(json['customer']);
    }

    return Loan(
        id: json['id'],
        company: company,
        customer: customer,
        principal: json['principal'].toDouble());
  }
}
