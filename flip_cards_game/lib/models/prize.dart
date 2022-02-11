class Prize {
  String id;
  String? name;
  String? imageUrl;

  Prize({required this.id, this.name, this.imageUrl});

  toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
    };
  }

  static Prize fromJson(Map<String, dynamic> json) => Prize(
      id: json['prize_id'] ?? '',
      name: json['prize_name'],
      imageUrl: json['prize_image_url']);

  static Prize fromJsonObject(Map<Object?, Object?> json) {
    return Prize(
        id: json['prize_id'].toString(),
        name: json['prize_name'].toString(),
        imageUrl: json['prize_image_url'].toString());
  }
}
