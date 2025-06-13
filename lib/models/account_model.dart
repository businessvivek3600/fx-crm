class AccountModel {
  final String? id;
  final String? customerId;
  final String? username;
  final String? ib;
  final String? login;
  final String? accountNo;
  final String? balance;
  final String? equity;
  final String? credit;
  final String? margin;
  final String? accountType;
  final String? accountPlan;
  final String? accountGroup;
  final String? leverage;
  final String? amount;
  final String? masterPassword;
  final String? investorPassword;
  final String? status;
  final String? note;
  final String? createdBy;
  final String? createdAt;
  final String? updatedAt;

  AccountModel({
    this.id,
    this.customerId,
    this.username,
    this.ib,
    this.login,
    this.accountNo,
    this.balance,
    this.equity,
    this.credit,
    this.margin,
    this.accountType,
    this.accountPlan,
    this.accountGroup,
    this.leverage,
    this.amount,
    this.masterPassword,
    this.investorPassword,
    this.status,
    this.note,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      id: json['id']?.toString(),
      customerId: json['customer_id']?.toString(),
      username: json['username']?.toString(),
      ib: json['ib']?.toString(),
      login: json['login']?.toString(),
      accountNo: json['account_no']?.toString(),
      balance: json['balance']?.toString(),
      equity: json['equity']?.toString(),
      credit: json['credit']?.toString(),
      margin: json['margin']?.toString(),
      accountType: json['account_type']?.toString(),
      accountPlan: json['account_plan']?.toString(),
      accountGroup: json['account_group']?.toString(),
      leverage: json['leverage']?.toString(),
      amount: json['amount']?.toString(),
      masterPassword: json['master_password']?.toString(),
      investorPassword: json['investor_password']?.toString(),
      status: json['status']?.toString(),
      note: json['note']?.toString(),
      createdBy: json['created_by']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
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


