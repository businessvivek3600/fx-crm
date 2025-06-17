class AccountStatement {
  final String? id;
  final String? customerId;
  final String? username;
  final String? accountNo;
  final String? type;
  final String? amount;
  final String? comment;
  final String? adminRemarks;
  final String? status;
  final String? createdAt;
  final String? ticket;
  final String? updatedAt;

  AccountStatement({
    this.id,
    this.customerId,
    this.username,
    this.accountNo,
    this.type,
    this.amount,
    this.comment,
    this.adminRemarks,
    this.status,
    this.createdAt,
    this.ticket,
    this.updatedAt,
  });

  factory AccountStatement.fromJson(Map<String, dynamic> json) {
    return AccountStatement(
      id: json['id']?.toString(),
      customerId: json['customer_id']?.toString(),
      username: json['username']?.toString(),
      accountNo: json['account_no']?.toString(),
      type: json['type']?.toString(),
      amount: json['amount']?.toString(),
      comment: json['comment']?.toString(),
      adminRemarks: json['admin_remarks']?.toString(),
      status: json['status']?.toString(),
      createdAt: json['created_at']?.toString(),
      ticket: json['ticket']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }
}
