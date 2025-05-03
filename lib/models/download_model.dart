class DownloadDataModel {
  final int status;
  final int isLogin;
  final DownloadData? data;
  final String message;

  DownloadDataModel({
    required this.status,
    required this.isLogin,
    required this.data,
    required this.message,
  });

  factory DownloadDataModel.fromJson(Map<String, dynamic> json) {
    return DownloadDataModel(
      status: json['status'] ?? 0,
      isLogin: json['is_login'] ?? 0,
      data: json['data'] != null ? DownloadData.fromJson(json['data']) : null,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'is_login': isLogin,
        'data': data?.toJson(),
        'message': message,
      };
}

class DownloadData {
  final String? mt5Window;
  final String? mt5Mac;
  final String? mt5Android;
  final String? mt5Ios;
  final String? pdf;

  DownloadData({
    this.mt5Window,
    this.mt5Mac,
    this.mt5Android,
    this.mt5Ios,
    this.pdf,
  });

  factory DownloadData.fromJson(Map<String, dynamic> json) {
    return DownloadData(
      mt5Window: json['mt5_window'],
      mt5Mac: json['mt5_mac'],
      mt5Android: json['mt5_android'],
      mt5Ios: json['mt5_ios'],
      pdf: json['pdf'],
    );
  }

  Map<String, dynamic> toJson() => {
        'mt5_window': mt5Window,
        'mt5_mac': mt5Mac,
        'mt5_android': mt5Android,
        'mt5_ios': mt5Ios,
        'pdf': pdf,
      };
}
