class ProblemModel {
  int? problemId;
  String? problemName;
  String? price;

  ProblemModel({this.problemId, this.problemName,this.price});

  ProblemModel.fromJson(Map<String, dynamic> json) {
    problemId = json['problemId'];
    problemName = json['problemName'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['problemId'] = this.problemId;
    data['problemName'] = this.problemName;
    data['price'] = this.price;
    return data;
  }
}
