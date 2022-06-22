class AssignRequestModel {
  int? assignId;
  int? userId;
  String? userName;
  int? exchangeId;
  String? contactNumber;
  String? status;
  String? amount;
  String? paymentMode;
  String? datetime;
  String? isPay;
  String? createdAt;
  String? updatedAt;

  AssignRequestModel(
      {
        this.assignId,
        this.userId,
        this.userName,
        this.exchangeId,
        this.contactNumber,
        this.status,
        this.amount,
        this.paymentMode,
        this.datetime,
        this.isPay,
        this.createdAt,
        this.updatedAt
      });

  AssignRequestModel.fromJson(Map<String, dynamic> json) {
    assignId = json['assignId'];
    userId = json['userId'];
    userName = json['userName'];
    exchangeId = json['exchangeId'];
    contactNumber = json['contactNumber'];
    status = json['status'];
    amount = json['amount'];
    paymentMode = json['paymentMode'];
    datetime = json['datetime'];
    isPay = json["isPay"];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['assignId'] = this.assignId;
    data['userId'] = this.userId;
    data['userName'] = this.userName;
    data['exchangeId'] = this.exchangeId;
    data['contactNumber'] = this.contactNumber;
    data['status'] = this.status;
    data['amount'] = this.amount;
    data['paymentMode'] = this.paymentMode;
    data['datetime'] = this.datetime;
    data["isPay"] = this.isPay;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
