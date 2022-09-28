import 'package:greece/model/company.dart';
import 'package:greece/model/company_type.dart';
import 'package:greece/model/entity.dart';
import 'package:greece/model/store.dart';
import 'package:greece/model/user.dart';

class Loan extends Entity {
  int id;
  Company? company;

  Loan({required this.id, this.company});

  static Loan fromJson(Map<String, dynamic> json) {
    Company? company;

    if (json['company'] != null) {
      company = Company.fromJson(json['company']);
    }

    return Loan(id: json['id'], company: company);
  }
}
