class User_Routes {
  User_Routes({
    required this.id,
    required this.user_id,
      required this.route_id,
  });
  String id;
  String user_id;
  String route_id;
  factory User_Routes.fromMap(Map<String, dynamic> json) => User_Routes(
    id: json["id"].toString(),
    user_id: json["user_id"],
    route_id: json["route_id"],

  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "user_id": user_id,
    "route_id": route_id,
  };
}
