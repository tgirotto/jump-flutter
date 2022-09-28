import 'package:greece/model/entity.dart';

class Edge<T extends Entity> {
  String? cursor;
  T node;

  Edge({this.cursor, required this.node});

  factory Edge.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic> o) fromJson) {
    T t = fromJson(json);
    return Edge(cursor: json['cursor'], node: t);
  }

  Map<String, dynamic> toJson() => {};
}
