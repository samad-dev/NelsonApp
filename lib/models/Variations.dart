class Variations {
  Variations({
    required this.id,
    required this.productId,
    required this.variationId,
    required this.name,
    required this.variationName,
    required this.size,
    required this.price,
    required this.price2,
    required this.price3,
    required this.price4,
    required this.price5,
    required this.price6,
    required this.price7,
    required this.color_id,
    required this.colors,
  });

  String id;
  String productId;
  String variationId;
  String name;
  String price;
  String price2;
  String price3;
  String price4;
  String price5;
  String price6;
  String price7;
  String variationName;
  String size;
  String color_id;
  String colors;

  factory Variations.fromMap(Map<String, dynamic> json) => Variations(
    id: json["id"],
    productId: json["product_id"],
    variationId: json["variation_id"],
    name: json["name"],
    price: json["price"],
    price2: json["price2"],
    price3: json["price3"],
    price4: json["price4"],
    price5: json["price5"],
    price6: json["price6"],
    price7: json["price7"],
    variationName: json["variation_name"],
    size: json["size"],
    color_id: json["color_id"],
    colors: json["colors"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "product_id": productId,
    "variation_id": variationId,
    "name": name,
    "variation_name": variationName,
    "size": size,
    "color_id": color_id,
    "colors": colors,
    "price": price,
    "price2": price2,
    "price3": price3,
    "price4": price4,
    "price5": price5,
    "price6": price6,
    "price7": price7,
  };
}
