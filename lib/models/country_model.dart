class Country {
  final int id;
  final String sortname;
  final String name;
  final String phonecode;

  Country({
    required this.id,
    required this.sortname,
    required this.name,
    required this.phonecode,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: int.tryParse(json['id'].toString()) ?? 0,
      sortname: json['sortname'] ?? '',
      name: json['name'] ?? '',
      phonecode: json['phonecode'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sortname': sortname,
      'name': name,
      'phonecode': phonecode,
    };
  }
}