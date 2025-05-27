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
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    order = json['order'] != null ? new Order.fromJson(json['order']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['is_login'] = this.isLogin;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.order != null) {
      data['order'] = this.order!.toJson();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['txn_id'] = this.txnId;
    data['coin_amt'] = this.coinAmt;
    data['recived'] = this.recived;
    data['types'] = this.types;
    data['coin'] = this.coin;
    data['wallet_address'] = this.walletAddress;
    data['status'] = this.status;
    data['status_text'] = this.statusText;
    data['qr_url'] = this.qrUrl;
    data['seller_email'] = this.sellerEmail;
    data['seller_username'] = this.sellerUsername;
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
  Null? note;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['created_at'] = this.createdAt;
    data['customer_id'] = this.customerId;
    data['username'] = this.username;
    data['amount'] = this.amount;
    data['payment_type'] = this.paymentType;
    data['payment_url'] = this.paymentUrl;
    data['qr_url'] = this.qrUrl;
    data['txn_id'] = this.txnId;
    data['status'] = this.status;
    data['note'] = this.note;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
