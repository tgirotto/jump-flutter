import 'package:greece/model/company.dart';
import 'package:greece/model/entity.dart';
import 'package:greece/model/user.dart';

class Credit extends Entity {
  int id;
  Company? company;
  double principal;

  Credit({required this.id, this.company, required this.principal});

  static Credit fromJson(Map<String, dynamic> json) {
    Company? company;

    if (json['company'] != null) {
      company = Company.fromJson(json['company']);
    }

    return Credit(
        id: json['id'],
        company: company,
        principal: json['principal'].toDouble());
  }
}
