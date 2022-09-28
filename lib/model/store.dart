import 'package:greece/model/entity.dart';

class Store extends Entity {
  int id;
  String name;
  String address;
  String phone;

  Store(
      {required this.id,
      required this.name,
      required this.phone,
      required this.address})
      : super();

  static Store fromJson(Map<String, dynamic> json) {
    return Store(
      address: json['address'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      id: json['id'],
    );
  }
}
