class Prize {
  String id;
  String? name;
  String? imageUrl;
  double? rate;
  int? quantity;

  Prize({required this.id, this.name, this.imageUrl, this.rate, this.quantity});

  toJson() {
    return {
      'prize_id': id,
      'prize_name': name,
      'prize_image_url': imageUrl,
      'rate': rate,
      'quantity': quantity
    };
  }

  static Prize fromJson(Map<String, dynamic> json) => Prize(
        id: json['prize_id'] ?? '',
        name: json['prize_name'],
        imageUrl: json['prize_image_url'],
        rate: double.tryParse(json['rate'].toString()),
        quantity: int.tryParse(json['quantity'].toString()),
      );

  static Prize fromJsonObject(Map<Object?, Object?> json) {
    return Prize(
      id: json['prize_id'].toString(),
      name: json['prize_name'].toString(),
      imageUrl: json['prize_image_url'].toString(),
      rate: double.tryParse(json['rate'].toString()),
      quantity: int.tryParse(json['quantity'].toString()),
    );
  }

  void update(Prize fromJsonObject) {
    name = fromJsonObject.name;
    imageUrl = fromJsonObject.imageUrl;
    rate = fromJsonObject.rate;
    quantity = fromJsonObject.quantity;
  }
}
