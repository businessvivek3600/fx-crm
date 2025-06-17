class Bank {
  final String? title;
  final int? bankDetailId;
  final String? bank;
  final String? address;
  final String? accountHolderName;
  final String? accountNumber;
  final String? ifscCode;
  final String? btcAddress;
  final String? bizzcoinAddress;
  final String? usdtAddress;

  Bank({
     this.title,
     this.bankDetailId,
     this.bank,
     this.address,
     this.accountHolderName,
     this.accountNumber,
     this.ifscCode,
    this.btcAddress,
    this.bizzcoinAddress,
    this.usdtAddress,
  });

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      title: json['title'],
      bankDetailId: int.tryParse(json['bankdetail_id']?.toString() ?? ''),
      bank: json['bank'],
      address: json['address'],
      accountHolderName: json['account_holder_name'],
      accountNumber: json['account_number'],
      ifscCode: json['ifsc_code'],
      btcAddress: json['btc_address'],
      bizzcoinAddress: json['bizzcoin_address'],
      usdtAddress: json['usdt_address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'bankdetail_id': bankDetailId,
      'bank': bank,
      'address': address,
      'account_holder_name': accountHolderName,
      'account_number': accountNumber,
      'ifsc_code': ifscCode,
      'btc_address': btcAddress,
      'bizzcoin_address': bizzcoinAddress,
      'usdt_address': usdtAddress,
    };
  }
}
