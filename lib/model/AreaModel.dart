class AreaModel {
  int? areaId;
  String? areaName;

  AreaModel({this.areaId, this.areaName});

  AreaModel.fromJson(Map<String, dynamic> json) {
    areaId = json['areaId'];
    areaName = json['areaName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['areaId'] = this.areaId;
    data['areaName'] = this.areaName;
    return data;
  }
}
