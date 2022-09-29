import 'package:greece/model/edge.dart';
import 'package:greece/model/entity.dart';
import 'package:greece/model/page_info.dart';

class Page<T extends Entity> {
  PageInfo pageInfo;
  List<Entry<T>> entries;

  Page({required this.pageInfo, required this.entries});

  factory Page.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic> o) fromJson) {
    PageInfo info = PageInfo.fromJson(json['page_info']);
    List<Entry<T>> entries = List<Entry<T>>.from(
        json['entries'].map((model) => Entry<T>.fromJson(model, fromJson)));

    return Page(pageInfo: info, entries: entries);
  }
}
