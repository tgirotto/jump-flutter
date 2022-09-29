class PageInfo {
  int limit;
  int offset;
  int total;
  String sort;

  PageInfo(
      {required this.limit,
      required this.offset,
      required this.sort,
      required this.total});

  factory PageInfo.fromJson(Map<String, dynamic> json) {
    return PageInfo(
        limit: json['limit'],
        offset: json['offset'],
        sort: json['sort'] ?? '',
        total: json['total']);
  }

  Map<String, dynamic> toJson() => {};
}
