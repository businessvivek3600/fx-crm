class GetFundWays {
  final List<FundOption>? depositFund;
  final List<WithdrawOption>? withdrawFund;
  final List<FundOption>? transferWallet;

  GetFundWays({
    this.depositFund,
    this.withdrawFund,
    this.transferWallet,
  });

  factory GetFundWays.fromJson(Map<String, dynamic> json) {
    return GetFundWays(
      depositFund: (json['deposit_fund'] as List?)
          ?.map((e) => FundOption.fromJson(e))
          .toList(),
      withdrawFund: (json['withdraw_fund'] as List?)
          ?.map((e) => WithdrawOption.fromJson(e))
          .toList(),
      transferWallet: (json['transfer_wallet'] as List?)
          ?.map((e) => FundOption.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deposit_fund': depositFund?.map((e) => e.toJson()).toList(),
      'withdraw_fund': withdrawFund?.map((e) => e.toJson()).toList(),
      'transfer_wallet': transferWallet?.map((e) => e.toJson()).toList(),
    };
  }
}

class FundOption {
  final String? name;
  final String? value;

  FundOption({
    this.name,
    this.value,
  });

  factory FundOption.fromJson(Map<String, dynamic> json) {
    return FundOption(
      name: json['name'] as String?,
      value: json['value'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
    };
  }
}

class WithdrawOption {
  final String? name;
  final String? value;
  final double? adminCharge;
  final double? minWithdraw;

  WithdrawOption({
    this.name,
    this.value,
    this.adminCharge,
    this.minWithdraw,
  });

  factory WithdrawOption.fromJson(Map<String, dynamic> json) {
    return WithdrawOption(
      name: json['name'] as String?,
      value: json['value'] as String?,
      adminCharge: json['admin_charge'] != null
          ? double.tryParse(json['admin_charge'].toString())
          : null,
      minWithdraw: json['min_withdraw'] != null
          ? double.tryParse(json['min_withdraw'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
      'admin_charge': adminCharge,
      'min_withdraw': minWithdraw,
    };
  }
}
