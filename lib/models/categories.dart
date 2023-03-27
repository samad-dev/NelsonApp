class Categories {
  Categories({
    required this.id,
    required this.category_name,
  });

  String id;
  String category_name;

  factory Categories.fromMap(Map<String, dynamic> json) => Categories(
    id: json["id"].toString(),
    category_name: json["category_name"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "category_name": category_name,
  };
}