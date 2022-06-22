class UserModel {
  int? userId;
  String? name;
  String? contact;
  String? emailId;
  String? password;
  String? companyName;
  String? address;
  int? areaId;
  String? gstNumber;
  String? otp;
  String? type;
  String? registerBy;
  String? isVerify;
  String? isBlock;
  String? createdAt;
  String? updatedAt;

  UserModel(
      {
        this.userId,
        this.name,
        this.contact,
        this.emailId,
        this.password,
        this.companyName,
        this.address,
        this.areaId,
        this.gstNumber,
        this.otp,
        this.type,
        this.registerBy,
        this.isVerify,
        this.isBlock,
        this.createdAt,
        this.updatedAt
      });

  UserModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    name = json['name'];
    contact = json['contact'];
    emailId = json['emailId'];
    password = json['password'];
    companyName = json['companyName'];
    address = json['address'];
    areaId = json['areaId'];
    gstNumber = json['gstNumber'];
    otp = json['otp'];
    type = json['type'];
    registerBy = json['registerBy'];
    isVerify = json['isVerify'];
    isBlock = json['isBlock'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['name'] = this.name;
    data['contact'] = this.contact;
    data['emailId'] = this.emailId;
    data['password'] = this.password;
    data['companyName'] = this.companyName;
    data['address'] = this.address;
    data['areaId'] = this.areaId;
    data['gstNumber'] = this.gstNumber;
    data['otp'] = this.otp;
    data['type'] = this.type;
    data['registerBy'] = this.registerBy;
    data['isVerify'] = this.isVerify;
    data['isBlock'] = this.isBlock;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
