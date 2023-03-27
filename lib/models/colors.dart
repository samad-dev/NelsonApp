class Coolor {
  Coolor({
    required this.color,
  });

  String color;

  factory Coolor.fromMap(Map<String, dynamic> json) => Coolor(
    color: json["color"].toString(),
  );

  Map<String, dynamic> toMap() => {
    "color": color,
  };
}
