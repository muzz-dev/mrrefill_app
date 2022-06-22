class ExchangeCartridgeModel {
  int? exchangeId;
  int? assignId;
  int? userId;
  String? userName;
  int? employeeId;
  String? employeeName;
  String? userContactNumber;
  String? employeeContactNumber;
  int? cartridgeId;
  String? cartridgeName;
  String? address;
  int? areaId;
  String? areaName;
  int? problemId;
  String? amount;
  String? paymentMode;
  String? datetime;
  String? requestDate;
  String? isPay;
  String? status;
  String? createdAt;
  String? updatedAt;

  ExchangeCartridgeModel(
      {this.exchangeId,
        this.assignId,
      this.userId,
      this.userName,
      this.employeeId,
      this.employeeName,
      this.userContactNumber,
      this.employeeContactNumber,
      this.cartridgeId,
      this.cartridgeName,
      this.address,
      this.areaId,
      this.areaName,
      this.problemId,
      this.amount,
      this.paymentMode,
      this.datetime,
      this.requestDate,
        this.isPay,
      this.status,
      this.createdAt,
      this.updatedAt});

  ExchangeCartridgeModel.fromJson(Map<String, dynamic> json) {
    exchangeId = json['exchangeId'];
    assignId = json['assignId'];
    userId = json['userId'];
    userName = json["userName"];
    employeeId = json["employeeId"];
    employeeName = json["employeeName"];
    userContactNumber = json["userContactNumber"];
    employeeContactNumber = json["employeeContactNumber"];
    cartridgeId = json['cartridgeId'];
    cartridgeName = json['cartridgeName'];
    address = json['address'];
    areaId = json['areaId'];
    areaName = json['areaName'];
    problemId = json['problemId'];
    amount = json['amount'];
    paymentMode = json['paymentMode'];
    datetime = json['datetime'];
    requestDate = json['requestDate'];
    isPay = json["isPay"];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['exchangeId'] = this.exchangeId;
    data['assignId'] = this.assignId;
    data['userId'] = this.userId;
    data['userName'] = this.userName;
    data['employeeId'] = this.employeeId;
    data['employeeName'] = this.employeeName;
    data['userContactNumber'] = this.userContactNumber;
    data['employeeContactNumber'] = this.employeeContactNumber;
    data['cartridgeId'] = this.cartridgeId;
    data['cartridgeName'] = this.cartridgeName;
    data['address'] = this.address;
    data['areaId'] = this.areaId;
    data['areaName'] = this.areaName;
    data['problemId'] = this.problemId;
    data['amount'] = this.amount;
    data['paymentMode'] = this.paymentMode;
    data['datetime'] = this.datetime;
    data['requestDate'] = this.requestDate;
    data["isPay"] = this.isPay;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
