class CompanyType {
  int id;
  String name;

  CompanyType({required this.id, required this.name});

  static CompanyType fromJson(Map<String, dynamic> json) {
    return CompanyType(id: json['id'], name: json['name']);
  }

  @override
  bool operator ==(Object other) => other is CompanyType && other.id == id;

  @override
  int get hashCode => name.hashCode;
}
