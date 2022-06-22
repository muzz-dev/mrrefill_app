class FeedbackModel {
  int? feedbackId;
  int? userId;
  String? feedbackText;
  String? createdAt;
  String? updatedAt;

  FeedbackModel({this.feedbackId, this.userId,this.feedbackText,this.createdAt,this.updatedAt});

  FeedbackModel.fromJson(Map<String, dynamic> json) {
    feedbackId = json['feedbackId'];
    userId = json['userId'];
    feedbackText = json['feedbackText'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['feedbackId'] = this.feedbackId;
    data['userId'] = this.userId;
    data['feedbackText'] = this.feedbackText;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
