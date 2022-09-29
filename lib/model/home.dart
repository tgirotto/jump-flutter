import 'package:greece/model/company.dart';
import 'package:greece/model/credit.dart';
import 'package:greece/model/entity.dart';
import 'package:greece/model/loan.dart';

class Home extends Entity {
  Company? company;
  List<Loan> loans;
  List<Credit> credits;

  Home({this.company, required this.loans, required this.credits});

  static Home fromJson(Map<String, dynamic> json) {
    Company? company;

    if (json["company"] != null) {
      company = Company.fromJson(json["company"]);
    }

    List<Loan> loans =
        List<Loan>.from(json['loans'].map((model) => Loan.fromJson(model)));

    List<Credit> credits = List<Credit>.from(
        json['credits'].map((model) => Credit.fromJson(model)));

    return Home(company: company, loans: loans, credits: credits);
  }
}
