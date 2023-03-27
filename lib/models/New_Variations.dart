class Variation_n {
  Variation_n({
    required this.colors,
    required this.qtr,
    required this.gln,
    required this.drm,
    required this.qtrp,
    required this.glnp,
    required this.drmp,
    required this.price,
  });

  String colors;
  String qtr;
  String gln;
  String drm;
  String qtrp;
  String glnp;
  String drmp;
  String price;

  factory Variation_n.fromMap(Map<String, dynamic> json) => Variation_n(
    colors: json["route_name"],
    qtr: json["qtr"],
    gln: json["gln"],
    drm: json["drm"],
    qtrp: json["qtrp"],
    glnp: json["glnp"],
    drmp: json["drmp"],
    price: json["price"],
  );

  Map<String, dynamic> toMap() => {
    "colors": colors,
    "qtr": qtr,
    "gln": gln,
    "drm": drm,
    "qtrp": qtrp,
    "glnp": glnp,
    "drmp": drmp,
    "price": price,
  };
}