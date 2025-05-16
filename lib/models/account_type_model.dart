
import 'dart:convert';

class AccountType {
  final String id;
  final String name;
  final List<String> leverageList;

  AccountType({required this.id, required this.name, required this.leverageList});

  factory AccountType.fromJson(Map<String, dynamic> json) {
    return AccountType(
      id: json['id'],
      name: json['name'],
      leverageList: List<String>.from(jsonDecode(json['leverage'])),
    );
  }
}
