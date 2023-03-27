class Routes {
  Routes({
    required this.id,
    required this.route_name,
  });

  String id;
  String route_name;

  factory Routes.fromMap(Map<String, dynamic> json) => Routes(
    id: json["id"].toString(),
    route_name: json["route_name"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "route_name": route_name,
  };
}