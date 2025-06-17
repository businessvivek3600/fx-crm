class WithdrawHistory {
  final String? id;
  final String? requestId;
  final String? type;
  final String? customerId;
  final String? username;
  final String? name;
  final String? accountHolderName;
  final String? accountNo;
  final String? ifscCode;
  final String? bank;
  final String? btcAddress;
  final String? bizzcoinAddress;
  final String? usdtAddress;
  final String? amount;
  final String? minBal;
  final String? adminPer;
  final String? adminCharge;
  final String? tdsPer;
  final String? tdsCharge;
  final String? repurchasedPer;
  final String? repurchasedCharge;
  final String? netPayable;
  final String? coinPrice;
  final String? netCoinPrice;
  final String? paymentType;
  final String? country;
  final String? currency;
  final String? currencyAmt;
  final String? transactionNumber;
  final String? status;
  final String? remarks;
  final String? ipAddress;
  final String? createdAt;
  final String? updatedAt;

  WithdrawHistory({
    this.id,
    this.requestId,
    this.type,
    this.customerId,
    this.username,
    this.name,
    this.accountHolderName,
    this.accountNo,
    this.ifscCode,
    this.bank,
    this.btcAddress,
    this.bizzcoinAddress,
    this.usdtAddress,
    this.amount,
    this.minBal,
    this.adminPer,
    this.adminCharge,
    this.tdsPer,
    this.tdsCharge,
    this.repurchasedPer,
    this.repurchasedCharge,
    this.netPayable,
    this.coinPrice,
    this.netCoinPrice,
    this.paymentType,
    this.country,
    this.currency,
    this.currencyAmt,
    this.transactionNumber,
    this.status,
    this.remarks,
    this.ipAddress,
    this.createdAt,
    this.updatedAt,
  });

  factory WithdrawHistory.fromJson(Map<String, dynamic> json) {
    return WithdrawHistory(
      id: json['id'] as String?,
      requestId: json['request_id'] as String?,
      type: json['type'] as String?,
      customerId: json['customer_id'] as String?,
      username: json['username'] as String?,
      name: json['name'] as String?,
      accountHolderName: json['account_holder_name'] as String?,
      accountNo: json['account_no'] as String?,
      ifscCode: json['ifsc_code'] as String?,
      bank: json['bank'] as String?,
      btcAddress: json['btc_address'] as String?,
      bizzcoinAddress: json['bizzcoin_address'] as String?,
      usdtAddress: json['usdt_address'] as String?,
      amount: json['amount'] as String?,
      minBal: json['min_bal'] as String?,
      adminPer: json['admin_per'] as String?,
      adminCharge: json['admin_charge'] as String?,
      tdsPer: json['tds_per'] as String?,
      tdsCharge: json['tds_charge'] as String?,
      repurchasedPer: json['repurchased_per'] as String?,
      repurchasedCharge: json['repurchased_charge'] as String?,
      netPayable: json['net_payable'] as String?,
      coinPrice: json['coin_price'] as String?,
      netCoinPrice: json['net_coin_price'] as String?,
      paymentType: json['payment_type'] as String?,
      country: json['country'] as String?,
      currency: json['currency'] as String?,
      currencyAmt: json['currency_amt'] as String?,
      transactionNumber: json['transaction_number'] as String?,
      status: json['status'] as String?,
      remarks: json['remarks'] as String?,
      ipAddress: json['ip_address'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'request_id': requestId,
      'type': type,
      'customer_id': customerId,
      'username': username,
      'name': name,
      'account_holder_name': accountHolderName,
      'account_no': accountNo,
      'ifsc_code': ifscCode,
      'bank': bank,
      'btc_address': btcAddress,
      'bizzcoin_address': bizzcoinAddress,
      'usdt_address': usdtAddress,
      'amount': amount,
      'min_bal': minBal,
      'admin_per': adminPer,
      'admin_charge': adminCharge,
      'tds_per': tdsPer,
      'tds_charge': tdsCharge,
      'repurchased_per': repurchasedPer,
      'repurchased_charge': repurchasedCharge,
      'net_payable': netPayable,
      'coin_price': coinPrice,
      'net_coin_price': netCoinPrice,
      'payment_type': paymentType,
      'country': country,
      'currency': currency,
      'currency_amt': currencyAmt,
      'transaction_number': transactionNumber,
      'status': status,
      'remarks': remarks,
      'ip_address': ipAddress,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
