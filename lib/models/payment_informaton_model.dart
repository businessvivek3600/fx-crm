import 'package:nb_utils/nb_utils.dart';


class PaymentInformation {
  int? status;
  int? isLogin;
  String? message;
  Data? data;
  Order? order;

  PaymentInformation(
      {this.status, this.isLogin, this.message, this.data, this.order});

  PaymentInformation.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    isLogin = json['is_login'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    order = json['order'] != null ? Order.fromJson(json['order']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['is_login'] = isLogin;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (order != null) {
      data['order'] = order!.toJson();
    }
    return data;
  }
}

class Data {
  String? orderId;
  String? txnId;
  String? coinAmt;
  String? recived;
  String? types;
  String? coin;
  String? walletAddress;
  int? status;
  String? statusText;
  String? qrUrl;
  String? sellerEmail;
  String? sellerUsername;

  Data(
      {this.orderId,
      this.txnId,
      this.coinAmt,
      this.recived,
      this.types,
      this.coin,
      this.walletAddress,
      this.status,
      this.statusText,
      this.qrUrl,
      this.sellerEmail,
      this.sellerUsername});

  Data.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    txnId = json['txn_id'];
    coinAmt = json['coin_amt'];
    recived = json['recived'];
    types = json['types'];
    coin = json['coin'];
    walletAddress = json['wallet_address'];
    status = json['status'];
    statusText = json['status_text'];
    qrUrl = json['qr_url'];
    sellerEmail = json['seller_email'];
    sellerUsername = json['seller_username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_id'] = orderId;
    data['txn_id'] = txnId;
    data['coin_amt'] = coinAmt;
    data['recived'] = recived;
    data['types'] = types;
    data['coin'] = coin;
    data['wallet_address'] = walletAddress;
    data['status'] = status;
    data['status_text'] = statusText;
    data['qr_url'] = qrUrl;
    data['seller_email'] = sellerEmail;
    data['seller_username'] = sellerUsername;
    return data;
  }
}

class Order {
  String? id;
  String? orderId;
  String? createdAt;
  String? customerId;
  String? username;
  String? amount;
  String? paymentType;
  String? paymentUrl;
  String? qrUrl;
  String? txnId;
  String? status;
  Null note;
  String? updatedAt;

  Order(
      {this.id,
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
      this.updatedAt});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    createdAt = json['created_at'];
    customerId = json['customer_id'];
    username = json['username'];
    amount = json['amount'];
    paymentType = json['payment_type'];
    paymentUrl = json['payment_url'];
    qrUrl = json['qr_url'];
    txnId = json['txn_id'];
    status = json['status'];
    note = json['note'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_id'] = orderId;
    data['created_at'] = createdAt;
    data['customer_id'] = customerId;
    data['username'] = username;
    data['amount'] = amount;
    data['payment_type'] = paymentType;
    data['payment_url'] = paymentUrl;
    data['qr_url'] = qrUrl;
    data['txn_id'] = txnId;
    data['status'] = status;
    data['note'] = note;
    data['updated_at'] = updatedAt;
    return data;
  }
}
