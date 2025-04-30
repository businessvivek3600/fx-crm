class KycModel {
  final String? id;
  final String? customerId;
  final String? customerUsername;
  final String? customerName;
  final String? uploadFirstProof;
  final String? uploadSecondProof;
  final String? uploadThirdProof;
  final String? uploadForthProof;
  final String? status;
  final String? remarks;
  final String? createdAt;
  final String? updatedAt;
  final String? idType;

  KycModel({
    this.id,
    this.customerId,
    this.customerUsername,
    this.customerName,
    this.uploadFirstProof,
    this.uploadSecondProof,
    this.uploadThirdProof,
    this.uploadForthProof,
    this.status,
    this.remarks,
    this.createdAt,
    this.updatedAt,
    this.idType,
  });

  factory KycModel.fromJson(Map<String, dynamic> json) {
    return KycModel(
      id: json['id']?.toString(),
      customerId: json['customer_id']?.toString(),
      customerUsername: json['customer_username']?.toString(),
      customerName: json['customer_name']?.toString(),
      uploadFirstProof: json['upload_first_proof']?.toString(),
      uploadSecondProof: json['upload_second_proof']?.toString(),
      uploadThirdProof: json['upload_third_proof']?.toString(),
      uploadForthProof: json['upload_forth_proof']?.toString(),
      status: json['status']?.toString(),
      remarks: json['remarks']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      idType: json['id_type']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'customer_username': customerUsername,
      'customer_name': customerName,
      'upload_first_proof': uploadFirstProof,
      'upload_second_proof': uploadSecondProof,
      'upload_third_proof': uploadThirdProof,
      'upload_forth_proof': uploadForthProof,
      'status': status,
      'remarks': remarks,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'id_type': idType,
    };
  }
}
