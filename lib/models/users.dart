class Users {
  Users({
    required this.id,
    required this.name,
    required this.privilege,
    required this.login,
    required this.password,
    required this.status,
    required this.description,
    required this.address,
    required this.telephone,
    required this.email,
    required this.fieldAgent,
    required this.routeId,
    required this.duty_in,
    required this.duty_out,
    required this.interval,
  });

  String id;
  String name;
  String privilege;
  String login;
  String password;
  String status;
  String description;
  String address;
  String telephone;
  String email;
  String fieldAgent;
  String routeId;
  String duty_in;
  String duty_out;
  String interval;

  factory Users.fromMap(Map<String, dynamic> json) => Users(
    id: json["id"],
    name: json["name"],
    privilege: json["privilege"],
    login: json["login"],
    password: json["password"],
    status: json["status"],
    description: json["description"],
    address: json["address"],
    telephone: json["telephone"],
    email: json["email"],
    fieldAgent: json["field_agent"],
    routeId: json["route_id"],
    duty_in: json["duty_in"],
    duty_out: json["duty_out"],
    interval: json["interval"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "privilege": privilege,
    "login": login,
    "password": password,
    "status": status,
    "description": description,
    "address": address,
    "telephone": telephone,
    "email": email,
    "field_agent": fieldAgent,
    "route_id": routeId,
    "duty_in": duty_in,
    "duty_out": duty_out,
    "interval": interval,
  };
}