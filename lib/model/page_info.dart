class PageInfo {
  String? startCursor;
  String? endCursor;
  bool hasNextPage;
  bool hasPreviousPage;

  PageInfo(
      {this.startCursor,
      this.endCursor,
      required this.hasNextPage,
      required this.hasPreviousPage});

  factory PageInfo.fromJson(Map<String, dynamic> json) {
    return PageInfo(
        startCursor: json['startCursor'],
        endCursor: json['endCursor'],
        hasNextPage: json['hasNextPage'] ?? true,
        hasPreviousPage: json['hasPreviousPage'] ?? false);
  }

  Map<String, dynamic> toJson() => {};
}
