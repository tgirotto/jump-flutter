import 'package:greece/model/entity.dart';

class Entry<T extends Entity> {
  String? cursor;
  T node;

  Entry({this.cursor, required this.node});

  factory Entry.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic> o) fromJson) {
    T t = fromJson(json);
    return Entry(cursor: json['cursor'], node: t);
  }

  Map<String, dynamic> toJson() => {};
}
