class FundRequestResponse {
  final int? status;
  final String? message;
  final int? isLogin;
  final FundRequestData? data;

  FundRequestResponse({
    this.status,
    this.message,
    this.isLogin,
    this.data,
  });

  factory FundRequestResponse.fromJson(Map<String, dynamic> json) {
    return FundRequestResponse(
      status: json['status'],
      message: json['message'],
      isLogin: json['is_login'],
      data: json['data'] != null ? FundRequestData.fromJson(json['data']) : null,
    );
  }
}

class FundRequestData {
  final List<FundRequestItem>? fundRequest;

  FundRequestData({this.fundRequest});

  factory FundRequestData.fromJson(Map<String, dynamic> json) {
    return FundRequestData(
      fundRequest: (json['fund_request'] as List<dynamic>?)
          ?.map((e) => FundRequestItem.fromJson(e))
          .toList(),
    );
  }
}

class FundRequestItem {
  final String? id;
  final String? orderId;
  final String? createdAt;
  final String? customerId;
  final String? username;
  final String? amount;
  final String? paymentType;
  final String? paymentUrl;
  final String? txnId;
  final String? status;
  final String? note;
  final String? updatedAt;

  FundRequestItem({
    this.id,
    this.orderId,
    this.createdAt,
    this.customerId,
    this.username,
    this.amount,
    this.paymentType,
    this.paymentUrl,
    this.txnId,
    this.status,
    this.note,
    this.updatedAt,
  });

  factory FundRequestItem.fromJson(Map<String, dynamic> json) {
    return FundRequestItem(
      id: json['id'],
      orderId: json['order_id'],
      createdAt: json['created_at'],
      customerId: json['customer_id'],
      username: json['username'],
      amount: json['amount'],
      paymentType: json['payment_type'],
      paymentUrl: json['payment_url'],
      txnId: json['txn_id'],
      status: json['status'],
      note: json['note'],
      updatedAt: json['updated_at'],
    );
  }
}
