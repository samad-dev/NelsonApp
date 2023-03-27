class Variation {
  final int id;
  final String attributes;
  final String product_id;
  final String permalink;
  final double  price;
  

  Variation({
    required this.id,
    required this.attributes,
    required this.product_id,
    required this.permalink,
    required this.price,
  });

  factory Variation.fromMap(Map<String, dynamic> json) => Variation(
    id: json['id'],
    attributes: json['attributes'],
    price: json['price'],
    permalink: json['permalink'],
    product_id: json['product_id'],


  );


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'price':price,
      'attributes':attributes,
      'permalink':permalink,
      'product_id':product_id,


    };
  }
}

// Our demo Products



const String description =
    "Wireless Controller for PS4™ gives you what you want in your gaming from over precision control your games to sharing …";
