class WalletLedgerResponse {
  final int? status;
  final String? message;
  final int? isLogin;
  final WalletLedgerData? data;

  WalletLedgerResponse({
    this.status,
    this.message,
    this.isLogin,
    this.data,
  });

  factory WalletLedgerResponse.fromJson(Map<String, dynamic> json) {
    return WalletLedgerResponse(
      status: json['status'],
      message: json['message'],
      isLogin: json['is_login'],
      data: json['data'] != null ? WalletLedgerData.fromJson(json['data']) : null,
    );
  }
}

class WalletLedgerData {
  final List<WalletLedgerItem>? ledger;
  final String? balance;

  WalletLedgerData({
    this.ledger,
    this.balance,
  });

  factory WalletLedgerData.fromJson(Map<String, dynamic> json) {
    return WalletLedgerData(
      ledger: (json['ledger'] as List<dynamic>?)
          ?.map((e) => WalletLedgerItem.fromJson(e))
          .toList(),
      balance: json['balance'],
    );
  }
}

class WalletLedgerItem {
  final String? id;
  final String? date;
  final String? payoutId;
  final String? customerId;
  final String? balance;
  final String? debit;
  final String? credit;
  final String? note;
  final String? createdBy;
  final String? createdAt;

  WalletLedgerItem({
    this.id,
    this.date,
    this.payoutId,
    this.customerId,
    this.balance,
    this.debit,
    this.credit,
    this.note,
    this.createdBy,
    this.createdAt,
  });

  factory WalletLedgerItem.fromJson(Map<String, dynamic> json) {
    return WalletLedgerItem(
      id: json['id'],
      date: json['date'],
      payoutId: json['payout_id'],
      customerId: json['customer_id'],
      balance: json['balance'],
      debit: json['debit'],
      credit: json['credit'],
      note: json['note'],
      createdBy: json['created_by'],
      createdAt: json['created_at'],
    );
  }
}
