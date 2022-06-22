class CompanyModel {
  int? companyId;
  String? companyName;

  CompanyModel(
      {
        this.companyId,
        this.companyName
      });

  CompanyModel.fromJson(Map<String, dynamic> json) {
    companyId = json['companyId'];
    companyName = json['companyName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['companyId'] = this.companyId;
    data['companyName'] = this.companyName;
    return data;
  }
}
