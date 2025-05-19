class AccountModel {
  final String id;
  final String customerId;
  final String username;
  final String ib;
  final String login;
  final String accountNo;
  final String balance;
  final String equity;
  final String credit;
  final String margin;
  final String accountType;
  final String accountPlan;
  final String accountGroup;
  final String leverage;
  final String amount;
  final String masterPassword;
  final String investorPassword;
  final String status;
  final String? note;
  final String createdBy;
  final String createdAt;
  final String? updatedAt;

  AccountModel({
    required this.id,
    required this.customerId,
    required this.username,
    required this.ib,
    required this.login,
    required this.accountNo,
    required this.balance,
    required this.equity,
    required this.credit,
    required this.margin,
    required this.accountType,
    required this.accountPlan,
    required this.accountGroup,
    required this.leverage,
    required this.amount,
    required this.masterPassword,
    required this.investorPassword,
    required this.status,
    required this.note,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      id: json['id'],
      customerId: json['customer_id'],
      username: json['username'],
      ib: json['ib'],
      login: json['login'],
      accountNo: json['account_no'],
      balance: json['balance'],
      equity: json['equity'],
      credit: json['credit'],
      margin: json['margin'],
      accountType: json['account_type'],
      accountPlan: json['account_plan'],
      accountGroup: json['account_group'],
      leverage: json['leverage'],
      amount: json['amount'],
      masterPassword: json['master_password'],
      investorPassword: json['investor_password'],
      status: json['status'],
      note: json['note'],
      createdBy: json['created_by'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'username': username,
      'ib': ib,
      'login': login,
      'account_no': accountNo,
      'balance': balance,
      'equity': equity,
      'credit': credit,
      'margin': margin,
      'account_type': accountType,
      'account_plan': accountPlan,
      'account_group': accountGroup,
      'leverage': leverage,
      'amount': amount,
      'master_password': masterPassword,
      'investor_password': investorPassword,
      'status': status,
      'note': note,
      'created_by': createdBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
