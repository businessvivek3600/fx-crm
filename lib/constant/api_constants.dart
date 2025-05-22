class ApiConst {
  ///APP INFO
  static const String appInfo = "app_info";

  ///  Auth APIs
  static const String login = "login";
  static const String register = "signup";
  static const String verifyEmail = "send_verfication_email";
  static const String logOut = "logout";

  ///Dashboard
  static const String home = 'dashboard';

  ///Accounts
  static const String accountPlans = 'plans';
  static const String activate = 'activate';
  static const String change_acc_password = 'change_acc_password';
  static const String accounts = 'accounts';
  static const String createAccount = 'create_account';
  static const String changeLeverage = 'change_leverage';

  /// Country
  static const String country = "countries";

  /// Banks api
  static const String getBankDetails = "bank";
  static const String updateBankDetails = "update_bank";
  static const String bankEmail = "bank_email";

  ///kyc
  static const String getKyc = "kyc";
  static const String uploadKyc = "upload_kyc";

  ///Profile
  static const String updateProfile = "update_profile";
  static const String userProfile = "profile";

  ///TERMS AND CONDITION
  static const String termAndCondition = "terms";

  ///Support
  static const String tickets = 'tickets';
  static const String createTicket = 'open_ticket';
  static const String ticketDetails = 'ticket_detail';
  static const String ticketReplay = 'ticket_reply';
  //Password
  static const String updatePassword = 'update_password';

  //Downloads
  static const String downloads = 'downloads';
  //get otp
  static const String send_code = 'send-code';
  static const String verify_code = 'verify-otp';
  static const String changePassword = 'change-password';

  //Funds
  static const String wallet_ledger = 'wallet_ledger';
  static const String wallet_deposit = 'wallet_deposit';
  static const String withDrawHistory = "wallet_withdraw";
  static const String fundWays = "fund_add_ways";
  static const String transferWallet = "mt5_transfer";
  static const String accountStatement = "account_statement";
}
