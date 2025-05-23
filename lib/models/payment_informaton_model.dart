class PaymentInformation {
  final int? status;
  final int? isLogin;
  final String? message;
  final PaymentData? data;
  final Order? order;

  PaymentInformation({
    this.status,
    this.isLogin,
    this.message,
    this.data,
    this.order,
  });

  factory PaymentInformation.fromJson(Map<String, dynamic> json) {
    return PaymentInformation(
      status: json['status'],
      isLogin: json['is_login'],
      message: json['message'],
      data: json['data'] != null ? PaymentData.fromJson(json['data']) : null,
      order: json['order'] != null ? Order.fromJson(json['order']) : null,
    );
  }
}

class PaymentData {
  final String? orderId;
  final String? txnId;
  final int? amount;
  final String? coinAmt;
  final int? recived;
  final String? types;
  final String? coin;
  final String? walletAddress;
  final int? status;
  final String? statusText;
  final String? qrUrl;

  PaymentData({
    this.orderId,
    this.txnId,
    this.amount,
    this.coinAmt,
    this.recived,
    this.types,
    this.coin,
    this.walletAddress,
    this.status,
    this.statusText,
    this.qrUrl,
  });

  factory PaymentData.fromJson(Map<String, dynamic> json) {
    return PaymentData(
      orderId: json['order_id'],
      txnId: json['txn_id'],
      amount: json['amount'],
      coinAmt: json['coin_amt'],
      recived: json['recived'],
      types: json['types'],
      coin: json['coin'],
      walletAddress: json['wallet_address'],
      status: json['status'],
      statusText: json['status_text'],
      qrUrl: json['qr_url'],
    );
  }
}

class Order {
  final String? id;
  final String? orderId;
  final String? createdAt;
  final String? customerId;
  final String? username;
  final String? amount;
  final String? paymentType;
  final String? paymentUrl;
  final String? qrUrl;
  final String? txnId;
  final String? status;
  final String? note;
  final String? updatedAt;

  Order({
    this.id,
    this.orderId,
    this.createdAt,
    this.customerId,
    this.username,
    this.amount,
    this.paymentType,
    this.paymentUrl,
    this.qrUrl,
    this.txnId,
    this.status,
    this.note,
    this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      orderId: json['order_id'],
      createdAt: json['created_at'],
      customerId: json['customer_id'],
      username: json['username'],
      amount: json['amount'],
      paymentType: json['payment_type'],
      paymentUrl: json['payment_url'],
      qrUrl: json['qr_url'],
      txnId: json['txn_id'],
      status: json['status'],
      note: json['note'],
      updatedAt: json['updated_at'],
    );
  }
}
