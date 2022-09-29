import 'package:greece/model/company.dart';
import 'package:greece/model/entity.dart';
import 'package:greece/model/store.dart' as s;

class User extends Entity {
  int? id;
  String fullName;
  String? email;
  String? phone;
  Company company;
  s.Store? store;
  String? userType;

  User(
      {this.id,
      required this.fullName,
      this.phone,
      required this.store,
      this.email,
      required this.company,
      this.userType})
      : super();

  static User fromJson(Map<String, dynamic> json) {
    s.Store? store;
    if (json['store'] != null) {
      store = s.Store.fromJson(json['store']);
    }
    User u = User(
        fullName: json['full_name'],
        id: json['id'],
        phone: json['phone'],
        company: Company.fromJson(json['company']),
        store: store,
        userType: json['user_type'],
        email: json['email']);

    return u;
  }
}
