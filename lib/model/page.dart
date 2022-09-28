import 'package:greece/model/edge.dart';
import 'package:greece/model/entity.dart';
import 'package:greece/model/page_info.dart';

class Page<T extends Entity> {
  PageInfo pageInfo;
  List<Edge<T>> edges;

  Page({required this.pageInfo, required this.edges});

  factory Page.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic> o) fromJson) {
    PageInfo info = PageInfo.fromJson(json['pageInfo']);
    List<Edge<T>> edges = List<Edge<T>>.from(json['edges']
        .map((model) => Edge<T>.fromJson(model['node'], fromJson)));

    return Page(pageInfo: info, edges: edges);
  }
}
