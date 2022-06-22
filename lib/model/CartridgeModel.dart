class CartridgeModel {
  int? cartridgeId;
  String? cartridgeName;
  String? price;
  String? description;
  String? imageUrl;
  int? modelId;
  int? typeId;

  CartridgeModel(
      {
        this.cartridgeId,
        this.cartridgeName,
        this.price,
        this.description,
        this.imageUrl,
        this.modelId,
        this.typeId
      });

  CartridgeModel.fromJson(Map<String, dynamic> json) {
    cartridgeId = json['cartridgeId'];
    cartridgeName = json['cartridgeName'];
    price = json['price'];
    description = json['description'];
    imageUrl = json['imageUrl'];
    modelId = json['modelId'];
    typeId = json['typeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cartridgeId'] = this.cartridgeId;
    data['cartridgeName'] = this.cartridgeName;
    data['price'] = this.price;
    data['description'] = this.description;
    data['imageUrl'] = this.imageUrl;
    data['modelId'] = this.modelId;
    data['typeId'] = this.typeId;
    return data;
  }
}
