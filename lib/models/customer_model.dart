
class Customer {
  final int? id;
  final String? customerId;
  final String? username;
  final String? directSponserUsername;
  final String? sponserUsername;
  final String? customerName;
  final int? salesActive;
  final String? salesActiveDate;
  final int? binaryStatus;
  final double? binaryPer;
  final int? position;
  final String? createdAt;
  final String? sponserId;
  final String? customerSponserId;
  final String? directSponserId;
  final String? firstName;
  final String? lastName;
  final String? fatherName;
  final String? customerShortAddress;
  final String? customerAddress1;
  final String? customerAddress2;
  final String? city;
  final String? state;
  final int? country;
  final String? countryText;
  final String? zip;
  final int? countryCode;
  final String? customerMobile;
  final String? forgetOtp;
  final String? customerEmail;
  final String? image;
  final int? step;
  final String? company;
  final String? gender;
  final String? panCard;
  final String? aadharCard;
  final String? dateOfBirth;
  final String? bitCoinAddress;
  final int? placement;
  final String? directSponserName;
  final String? sponserName;
  final String? proposerUsername;
  final String? referencerUsername;
  final String? paymentType;
  final String? epin;
  final int? block;
  final String? blockNote;
  final int? verifyEmail;
  final String? emailVerificationCode;
  final int? emailReset;
  final String? emailResetCode;
  final int? kyc;
  final String? kycDocType;
  final String? kycDocNo;
  final int? bizzCareer;
  final int? packageId;
  final String? packageName;
  final double? packageAmt;
  final double? packageCapping;
  final String? packageUpdated;
  final int? packageRoi;
  final String? bitCoinTxn;
  final int? merchent;
  final String? memberSale;
  final int? booster;
  final int? directIncome;
  final int? rewardId;
  final String? rankName;
  final int? rankPoint;
  final int? matchPoint;
  final int? userProfitOff;
  final int? tiBtn;
  final int? dTiBtn;
  final String? tiType;
  final int? clb;
  final int? crb;
  final double? mlb;
  final double? mrb;
  final int? mobileVerify;
  final String? mobileOtp;
  final String? mobileOtpTime;
  final String? withdrawEOtp;
  final String? withdrawEOtpTime;
  final String? withdrawMOtp;
  final String? withdrawMOtpTime;
  final String? bankEOtp;
  final String? bankEOtpTime;
  final String? bankMOtp;
  final String? bankMOtpTime;
  final int? authReset;
  final String? authResetCode;
  final int? isIsAuth;
  final int? isAuth;
  final String? googleAuthCode;
  final int? status;
  final String? ipAddress;
  final int? isLogin;
  final String? loginIpAddress;
  final String? loginTime;
  final String? logoutTime;
  final int? loginAttempt;
  final int? isDisabled;
  final String? disabledTime;
  final int? isResetPwd;
  final int? custFreez;
  final int? dDTree;
  final int? bSchoolRemoteId;
  final int? cB;
  final int? cI;
  final int? cA;
  final int? ftb;
  final String? ftbDate;
  final String? accountType;
  final int? ib;
  final String? accountNo;
  final String? loginToken;
  final String? updatedAt;

  Customer({
    this.id,
    this.customerId,
    this.username,
    this.directSponserUsername,
    this.sponserUsername,
    this.customerName,
    this.salesActive,
    this.salesActiveDate,
    this.binaryStatus,
    this.binaryPer,
    this.position,
    this.createdAt,
    this.sponserId,
    this.customerSponserId,
    this.directSponserId,
    this.firstName,
    this.lastName,
    this.fatherName,
    this.customerShortAddress,
    this.customerAddress1,
    this.customerAddress2,
    this.city,
    this.state,
    this.country,
    this.countryText,
    this.zip,
    this.countryCode,
    this.customerMobile,
    this.forgetOtp,
    this.customerEmail,
    this.image,
    this.step,
    this.company,
    this.gender,
    this.panCard,
    this.aadharCard,
    this.dateOfBirth,
    this.bitCoinAddress,
    this.placement,
    this.directSponserName,
    this.sponserName,
    this.proposerUsername,
    this.referencerUsername,
    this.paymentType,
    this.epin,
    this.block,
    this.blockNote,
    this.verifyEmail,
    this.emailVerificationCode,
    this.emailReset,
    this.emailResetCode,
    this.kyc,
    this.kycDocType,
    this.kycDocNo,
    this.bizzCareer,
    this.packageId,
    this.packageName,
    this.packageAmt,
    this.packageCapping,
    this.packageUpdated,
    this.packageRoi,
    this.bitCoinTxn,
    this.merchent,
    this.memberSale,
    this.booster,
    this.directIncome,
    this.rewardId,
    this.rankName,
    this.rankPoint,
    this.matchPoint,
    this.userProfitOff,
    this.tiBtn,
    this.dTiBtn,
    this.tiType,
    this.clb,
    this.crb,
    this.mlb,
    this.mrb,
    this.mobileVerify,
    this.mobileOtp,
    this.mobileOtpTime,
    this.withdrawEOtp,
    this.withdrawEOtpTime,
    this.withdrawMOtp,
    this.withdrawMOtpTime,
    this.bankEOtp,
    this.bankEOtpTime,
    this.bankMOtp,
    this.bankMOtpTime,
    this.authReset,
    this.authResetCode,
    this.isIsAuth,
    this.isAuth,
    this.googleAuthCode,
    this.status,
    this.ipAddress,
    this.isLogin,
    this.loginIpAddress,
    this.loginTime,
    this.logoutTime,
    this.loginAttempt,
    this.isDisabled,
    this.disabledTime,
    this.isResetPwd,
    this.custFreez,
    this.dDTree,
    this.bSchoolRemoteId,
    this.cB,
    this.cI,
    this.cA,
    this.ftb,
    this.ftbDate,
    this.accountType,
    this.ib,
    this.accountNo,
    this.loginToken,
    this.updatedAt,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: int.tryParse(json['id']?.toString() ?? ''),
      customerId: json['customer_id'],
      username: json['username'],
      directSponserUsername: json['direct_sponser_username'],
      sponserUsername: json['sponser_username'],
      customerName: json['customer_name'],
      salesActive: int.tryParse(json['sales_active']?.toString() ?? ''),
      salesActiveDate: json['sales_active_date'],
      binaryStatus: int.tryParse(json['binary_status']?.toString() ?? ''),
      binaryPer: double.tryParse(json['binary_per']?.toString() ?? ''),
      position: json['position'],
      createdAt: json['created_at'],
      sponserId: json['sponser_id'],
      customerSponserId: json['customer_sponser_id'],
      directSponserId: json['direct_sponser_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      fatherName: json['father_name'],
      customerShortAddress: json['customer_short_address'],
      customerAddress1: json['customer_address_1'],
      customerAddress2: json['customer_address_2'],
      city: json['city'],
      state: json['state'],
      country: int.tryParse(json['country']?.toString() ?? ''),
      countryText: json['country_text'],
      zip: json['zip'],
      countryCode: json['country_code'],
      customerMobile: json['customer_mobile'],
      forgetOtp: json['forget_otp'],
      customerEmail: json['customer_email'],
      image: json['image'],
      step: json['step'],
      company: json['company'],
      gender: json['gender'],
      panCard: json['pan_card'],
      aadharCard: json['aadhar_card'],
      dateOfBirth: json['date_of_birth'],
      bitCoinAddress: json['bit_coin_address'],
      placement: int.tryParse(json['placement']?.toString() ?? ''),
      directSponserName: json['direct_sponser_name'],
      sponserName: json['sponser_name'],
      proposerUsername: json['proposer_username'],
      referencerUsername: json['referencer_username'],
      paymentType: json['payment_type'],
      epin: json['epin'],
      block: json['block'],
      blockNote: json['block_note'],
      verifyEmail: json['verify_email'],
      emailVerificationCode: json['email_verification_code'],
      emailReset: json['email_reset'],
      emailResetCode: json['email_reset_code'],
      kyc: json['kyc'],
      kycDocType: json['kyc_doc_type'],
      kycDocNo: json['kyc_doc_no'],
      bizzCareer: json['bizz_career'],
      packageId: json['package_id'],
      packageName: json['package_name'],
      packageAmt: (json['package_amt'] ?? 0).toDouble(),
      packageCapping: (json['package_capping'] ?? 0).toDouble(),
      packageUpdated: json['package_updated'],
      packageRoi: json['package_roi'],
      bitCoinTxn: json['bit_coin_txn'],
      merchent: json['merchent'],
      memberSale: json['member_sale'],
      booster: json['booster'],
      directIncome: json['direct_income'],
      rewardId: json['reward_id'],
      rankName: json['rank_name'],
      rankPoint: json['rank_point'],
      matchPoint: json['match_point'],
      userProfitOff: json['user_profit_off'],
      tiBtn: json['ti_btn'],
      dTiBtn: json['d_ti_btn'],
      tiType: json['ti_type'],
      clb: json['clb'],
      crb: json['crb'],
      mlb: (json['mlb'] ?? 0).toDouble(),
      mrb: (json['mrb'] ?? 0).toDouble(),
      mobileVerify: json['mobile_verify'],
      mobileOtp: json['mobile_otp'],
      mobileOtpTime: json['mobile_otp_time'],
      withdrawEOtp: json['withdraw_e_otp'],
      withdrawEOtpTime: json['withdraw_e_otp_time'],
      withdrawMOtp: json['withdraw_m_otp'],
      withdrawMOtpTime: json['withdraw_m_otp_time'],
      bankEOtp: json['bank_e_otp'],
      bankEOtpTime: json['bank_e_otp_time'],
      bankMOtp: json['bank_m_otp'],
      bankMOtpTime: json['bank_m_otp_time'],
      authReset: json['auth_reset'],
      authResetCode: json['auth_reset_code'],
      isIsAuth: json['is_is_auth'],
      isAuth: json['is_auth'],
      googleAuthCode: json['google_auth_code'],
      status: json['status'],
      ipAddress: json['ip_address'],
      isLogin: json['is_login'],
      loginIpAddress: json['login_ip_address'],
      loginTime: json['login_time'],
      logoutTime: json['logout_time'],
      loginAttempt: json['login_attempt'],
      isDisabled: json['is_disabled'],
      disabledTime: json['disabled_time'],
      isResetPwd: json['is_reset_pwd'],
      custFreez: json['cust_freez'],
      dDTree: json['d_d_tree'],
      bSchoolRemoteId: json['b_school_remote_id'],
      cB: json['c_b'],
      cI: json['c_i'],
      cA: json['c_a'],
      ftb: json['ftb'],
      ftbDate: json['ftb_date'],
      accountType: json['account_type'],
      ib: json['ib'],
      accountNo: json['account_no'],
      loginToken: json['login_token'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'username': username,
      'direct_sponser_username': directSponserUsername,
      'sponser_username': sponserUsername,
      'customer_name': customerName,
      'sales_active': salesActive,
      'sales_active_date': salesActiveDate,
      'binary_status': binaryStatus,
      'binary_per': binaryPer,
      'position': position,
      'created_at': createdAt,
      'sponser_id': sponserId,
      'customer_sponser_id': customerSponserId,
      'direct_sponser_id': directSponserId,
      'first_name': firstName,
      'last_name': lastName,
      'father_name': fatherName,
      'customer_short_address': customerShortAddress,
      'customer_address_1': customerAddress1,
      'customer_address_2': customerAddress2,
      'city': city,
      'state': state,
      'country': country,
      'country_text': countryText,
      'zip': zip,
      'country_code': countryCode,
      'customer_mobile': customerMobile,
      'forget_otp': forgetOtp,
      'customer_email': customerEmail,
      'image': image,
      'step': step,
      'company': company,
      'gender': gender,
      'pan_card': panCard,
      'aadhar_card': aadharCard,
      'date_of_birth': dateOfBirth,
      'bit_coin_address': bitCoinAddress,
      'placement': placement,
      'direct_sponser_name': directSponserName,
      'sponser_name': sponserName,
      'proposer_username': proposerUsername,
      'referencer_username': referencerUsername,
      'payment_type': paymentType,
      'epin': epin,
      'block': block,
      'block_note': blockNote,
      'verify_email': verifyEmail,
      'email_verification_code': emailVerificationCode,
      'email_reset': emailReset,
      'email_reset_code': emailResetCode,
      'kyc': kyc,
      'kyc_doc_type': kycDocType,
      'kyc_doc_no': kycDocNo,
      'bizz_career': bizzCareer,
      'package_id': packageId,
      'package_name': packageName,
      'package_amt': packageAmt,
      'package_capping': packageCapping,
      'package_updated': packageUpdated,
      'package_roi': packageRoi,
      'bit_coin_txn': bitCoinTxn,
      'merchent': merchent,
      'member_sale': memberSale,
      'booster': booster,
      'direct_income': directIncome,
      'reward_id': rewardId,
      'rank_name': rankName,
      'rank_point': rankPoint,
      'match_point': matchPoint,
      'user_profit_off': userProfitOff,
      'ti_btn': tiBtn,
      'd_ti_btn': dTiBtn,
      'ti_type': tiType,
      'clb': clb,
      'crb': crb,
      'mlb': mlb,
      'mrb': mrb,
      'mobile_verify': mobileVerify,
      'mobile_otp': mobileOtp,
      'mobile_otp_time': mobileOtpTime,
      'withdraw_e_otp': withdrawEOtp,
      'withdraw_e_otp_time': withdrawEOtpTime,
      'withdraw_m_otp': withdrawMOtp,
      'withdraw_m_otp_time': withdrawMOtpTime,
      'bank_e_otp': bankEOtp,
      'bank_e_otp_time': bankEOtpTime,
      'bank_m_otp': bankMOtp,
      'bank_m_otp_time': bankMOtpTime,
      'auth_reset': authReset,
      'auth_reset_code': authResetCode,
      'is_is_auth': isIsAuth,
      'is_auth': isAuth,
      'google_auth_code': googleAuthCode,
      'status': status,
      'ip_address': ipAddress,
      'is_login': isLogin,
      'login_ip_address': loginIpAddress,
      'login_time': loginTime,
      'logout_time': logoutTime,
      'login_attempt': loginAttempt,
      'is_disabled': isDisabled,
      'disabled_time': disabledTime,
      'is_reset_pwd': isResetPwd,
      'cust_freez': custFreez,
      'd_d_tree': dDTree,
      'b_school_remote_id': bSchoolRemoteId,
      'c_b': cB,
      'c_i': cI,
      'c_a': cA,
      'ftb': ftb,
      'ftb_date': ftbDate,
      'account_type': accountType,
      'ib': ib,
      'account_no': accountNo,
      'login_token': loginToken,
      'updated_at': updatedAt,
    };
  }
}
