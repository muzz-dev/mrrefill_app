class MModel {
  int? modelId;
  String? modelName;
  int? companyId;
  String? type;

  MModel({this.modelId, this.modelName});

  MModel.fromJson(Map<String, dynamic> json) {
    modelId = json['modelId'];
    modelName = json['modelName'];
    companyId = json['companyId'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['modelId'] = this.modelId;
    data['modelName'] = this.modelName;
    data['companyId'] = this.companyId;
    data['type'] = this.type;
    return data;
  }
}
