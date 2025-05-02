class AppInfoModel {
  final List<Setting>? setting;
  final Company? company;

  AppInfoModel({
    this.setting,
    this.company,
  });

  factory AppInfoModel.fromJson(Map<String, dynamic> json) {
    return AppInfoModel(
      setting: (json['setting'] as List?)
          ?.map((x) => Setting.fromJson(x))
          .toList(),
      company: json['company'] != null
          ? Company.fromJson(json['company'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'setting': setting?.map((x) => x.toJson()).toList(),
    'company': company?.toJson(),
  };
}

class Setting {
  final String? settingId;
  final String? logo;
  final String? invoiceLogo;
  final String? favicon;
  final String? footerLogo;
  final String? footerText;
  final String? mapApiKey;
  final String? mapLatitude;
  final String? mapLangitude;

  Setting({
    this.settingId,
    this.logo,
    this.invoiceLogo,
    this.favicon,
    this.footerLogo,
    this.footerText,
    this.mapApiKey,
    this.mapLatitude,
    this.mapLangitude,
  });

  factory Setting.fromJson(Map<String, dynamic> json) => Setting(
    settingId: json['setting_id'],
    logo: json['logo'],
    invoiceLogo: json['invoice_logo'],
    favicon: json['favicon'],
    footerLogo: json['footer_logo'],
    footerText: json['footer_text'],
    mapApiKey: json['map_api_key'],
    mapLatitude: json['map_latitude'],
    mapLangitude: json['map_langitude'],
  );

  Map<String, dynamic> toJson() => {
    'setting_id': settingId,
    'logo': logo,
    'invoice_logo': invoiceLogo,
    'favicon': favicon,
    'footer_logo': footerLogo,
    'footer_text': footerText,
    'map_api_key': mapApiKey,
    'map_latitude': mapLatitude,
    'map_langitude': mapLangitude,
  };
}


class Company {
  final String? companyId;
  final String? companyName;
  final String? email;
  final String? address;
  final String? mobile;
  final String? website;
  final String? businessPlan;
  final String? username;
  final String? ruleAgreement;
  final String? minActiveAmt;
  final String? minWithdrawAmt;
  final String? matchingPer;
  final String? matchingCondition;
  final String? matchingPvAmt;
  final String? directPer;
  final String? fMatchingPer;
  final String? fDirectPer;
  final String? repurchasePer;
  final String? bAdminPer;
  final String? mAdminPer;
  final String? cAdminPer;
  final String? uAdminPer;
  final String? tdsPer;
  final String? repurchasedPer;
  final String? tTransactionPer;
  final String? tMinimumWithdraw;
  final String? tMinimumTransfer;
  final String? cTransactionPer;
  final String? cMinimumWithdraw;
  final String? cMinimumTransfer;
  final String? eTransactionPer;
  final String? eMinimumWithdraw;
  final String? eMinimumTransfer;
  final String? matchingDirectPer;
  final String? matchingParentPer;
  final String? bitCoinAddress;
  final String? euroIn1Coin;
  final String? btcIn1Coin;
  final String? usdtIn1Coin;
  final String? eurUsd;
  final String? eurGbp;
  final String? eurInr;
  final String? eurPkr;
  final String? tradingDay;
  final String? wTrading;
  final String? tTrading;
  final String? wCommission;
  final String? tCommission;
  final String? wTransaction;
  final String? tTransaction;
  final String? wEscrow;
  final String? eMinimumSaving;
  final String? eventIs;
  final String? eventName;
  final String? eventBanner;
  final String? ticketPrice;
  final String? ticketDiscount;
  final String? ticketDiscountPrice;
  final String? noTicket;
  final String? popupImg;
  final String? popupImage;
  final String? monthlyRewardImg;
  final String? bankWire;
  final String? loginEnable;
  final String? signupEnable;
  final String? status;

  Company({
    this.companyId,
    this.companyName,
    this.email,
    this.address,
    this.mobile,
    this.website,
    this.businessPlan,
    this.username,
    this.ruleAgreement,
    this.minActiveAmt,
    this.minWithdrawAmt,
    this.matchingPer,
    this.matchingCondition,
    this.matchingPvAmt,
    this.directPer,
    this.fMatchingPer,
    this.fDirectPer,
    this.repurchasePer,
    this.bAdminPer,
    this.mAdminPer,
    this.cAdminPer,
    this.uAdminPer,
    this.tdsPer,
    this.repurchasedPer,
    this.tTransactionPer,
    this.tMinimumWithdraw,
    this.tMinimumTransfer,
    this.cTransactionPer,
    this.cMinimumWithdraw,
    this.cMinimumTransfer,
    this.eTransactionPer,
    this.eMinimumWithdraw,
    this.eMinimumTransfer,
    this.matchingDirectPer,
    this.matchingParentPer,
    this.bitCoinAddress,
    this.euroIn1Coin,
    this.btcIn1Coin,
    this.usdtIn1Coin,
    this.eurUsd,
    this.eurGbp,
    this.eurInr,
    this.eurPkr,
    this.tradingDay,
    this.wTrading,
    this.tTrading,
    this.wCommission,
    this.tCommission,
    this.wTransaction,
    this.tTransaction,
    this.wEscrow,
    this.eMinimumSaving,
    this.eventIs,
    this.eventName,
    this.eventBanner,
    this.ticketPrice,
    this.ticketDiscount,
    this.ticketDiscountPrice,
    this.noTicket,
    this.popupImg,
    this.popupImage,
    this.monthlyRewardImg,
    this.bankWire,
    this.loginEnable,
    this.signupEnable,
    this.status,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
    companyId: json['company_id'],
    companyName: json['company_name'],
    email: json['email'],
    address: json['address'],
    mobile: json['mobile'],
    website: json['website'],
    businessPlan: json['business_plan'],
    username: json['username'],
    ruleAgreement: json['rule_agreement'],
    minActiveAmt: json['min_active_amt'],
    minWithdrawAmt: json['min_withdraw_amt'],
    matchingPer: json['matching_per'],
    matchingCondition: json['matching_condition'],
    matchingPvAmt: json['matching_pv_amt'],
    directPer: json['direct_per'],
    fMatchingPer: json['f_matching_per'],
    fDirectPer: json['f_direct_per'],
    repurchasePer: json['repurchase_per'],
    bAdminPer: json['b_admin_per'],
    mAdminPer: json['m_admin_per'],
    cAdminPer: json['c_admin_per'],
    uAdminPer: json['u_admin_per'],
    tdsPer: json['tds_per'],
    repurchasedPer: json['repurchased_per'],
    tTransactionPer: json['t_transaction_per'],
    tMinimumWithdraw: json['t_minimum_withdraw'],
    tMinimumTransfer: json['t_minimum_transfer'],
    cTransactionPer: json['c_transaction_per'],
    cMinimumWithdraw: json['c_minimum_withdraw'],
    cMinimumTransfer: json['c_minimum_transfer'],
    eTransactionPer: json['e_transaction_per'],
    eMinimumWithdraw: json['e_minimum_withdraw'],
    eMinimumTransfer: json['e_minimum_transfer'],
    matchingDirectPer: json['matching_direct_per'],
    matchingParentPer: json['matching_parent_per'],
    bitCoinAddress: json['bit_coin_address'],
    euroIn1Coin: json['euro_in_1_coin'],
    btcIn1Coin: json['btc_in_1_coin'],
    usdtIn1Coin: json['usdt_in_1_coin'],
    eurUsd: json['eur_usd'],
    eurGbp: json['eur_gbp'],
    eurInr: json['eur_inr'],
    eurPkr: json['eur_pkr'],
    tradingDay: json['trading_day'],
    wTrading: json['w_trading'],
    tTrading: json['t_trading'],
    wCommission: json['w_commission'],
    tCommission: json['t_commission'],
    wTransaction: json['w_transaction'],
    tTransaction: json['t_transaction'],
    wEscrow: json['w_escrow'],
    eMinimumSaving: json['e_minimum_saving'],
    eventIs: json['event_is'],
    eventName: json['event_name'],
    eventBanner: json['event_banner'],
    ticketPrice: json['ticket_price'],
    ticketDiscount: json['ticket_discount'],
    ticketDiscountPrice: json['ticket_discount_price'],
    noTicket: json['no_ticket'],
    popupImg: json['popup_img'],
    popupImage: json['popup_image'],
    monthlyRewardImg: json['monthly_reward_img'],
    bankWire: json['bank_wire'],
    loginEnable: json['login_enable'],
    signupEnable: json['signup_enable'],
    status: json['status'],
  );

  Map<String, dynamic> toJson() => {
    'company_id': companyId,
    'company_name': companyName,
    'email': email,
    'address': address,
    'mobile': mobile,
    'website': website,
    'business_plan': businessPlan,
    'username': username,
    'rule_agreement': ruleAgreement,
    'min_active_amt': minActiveAmt,
    'min_withdraw_amt': minWithdrawAmt,
    'matching_per': matchingPer,
    'matching_condition': matchingCondition,
    'matching_pv_amt': matchingPvAmt,
    'direct_per': directPer,
    'f_matching_per': fMatchingPer,
    'f_direct_per': fDirectPer,
    'repurchase_per': repurchasePer,
    'b_admin_per': bAdminPer,
    'm_admin_per': mAdminPer,
    'c_admin_per': cAdminPer,
    'u_admin_per': uAdminPer,
    'tds_per': tdsPer,
    'repurchased_per': repurchasedPer,
    't_transaction_per': tTransactionPer,
    't_minimum_withdraw': tMinimumWithdraw,
    't_minimum_transfer': tMinimumTransfer,
    'c_transaction_per': cTransactionPer,
    'c_minimum_withdraw': cMinimumWithdraw,
    'c_minimum_transfer': cMinimumTransfer,
    'e_transaction_per': eTransactionPer,
    'e_minimum_withdraw': eMinimumWithdraw,
    'e_minimum_transfer': eMinimumTransfer,
    'matching_direct_per': matchingDirectPer,
    'matching_parent_per': matchingParentPer,
    'bit_coin_address': bitCoinAddress,
    'euro_in_1_coin': euroIn1Coin,
    'btc_in_1_coin': btcIn1Coin,
    'usdt_in_1_coin': usdtIn1Coin,
    'eur_usd': eurUsd,
    'eur_gbp': eurGbp,
    'eur_inr': eurInr,
    'eur_pkr': eurPkr,
    'trading_day': tradingDay,
    'w_trading': wTrading,
    't_trading': tTrading,
    'w_commission': wCommission,
    't_commission': tCommission,
    'w_transaction': wTransaction,
    't_transaction': tTransaction,
    'w_escrow': wEscrow,
    'e_minimum_saving': eMinimumSaving,
    'event_is': eventIs,
    'event_name': eventName,
    'event_banner': eventBanner,
    'ticket_price': ticketPrice,
    'ticket_discount': ticketDiscount,
    'ticket_discount_price': ticketDiscountPrice,
    'no_ticket': noTicket,
    'popup_img': popupImg,
    'popup_image': popupImage,
    'monthly_reward_img': monthlyRewardImg,
    'bank_wire': bankWire,
    'login_enable': loginEnable,
    'signup_enable': signupEnable,
    'status': status,
  };
}

