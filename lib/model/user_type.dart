import 'package:greece/model/entity.dart';

class UserType extends Entity {
  int id;
  String name;

  UserType({required this.id, required this.name});

  static UserType fromJson(Map<String, dynamic> json) {
    return UserType(id: json['id'], name: json['name']);
  }

  @override
  bool operator ==(Object other) => other is UserType && other.id == id;

  @override
  int get hashCode => name.hashCode;
}
