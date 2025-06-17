
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
class ApiResponse {
  final List<String> accountTypes;

  ApiResponse({required this.accountTypes});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      accountTypes: List<String>.from(json['account_type']),
    );
  }
}



class AccountPlanModel {
  final String code;
  final String name;
  final List<String> leverage;
  final List<String> initialFund;

  AccountPlanModel({
    required this.code,
    required this.name,
    required this.leverage,
    required this.initialFund,
  });

  factory AccountPlanModel.fromJson(Map<String, dynamic> json) {
    return AccountPlanModel(
      code: json['code'].toString(),
      name: json['name'].toString(),
      leverage: List<String>.from(json['leverage']),
      initialFund: List<String>.from(json['initial_fund']),
    );
  }
}
