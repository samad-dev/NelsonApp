class Address {
  Address({
    required this.id,
    required this.user_id,
    required this.first_name,
    required this.last_name,
    required this.address_a,
    required this.address_b,
    required this.state,
    required this.city,
    required this.post_code,
    required this.country,
    required this.email,
    required this.phone,
    required this.created_by,
    required this.status,
  });

  String id;
  String user_id;
  String first_name;
  String last_name;
  String address_a;
  String address_b;
  String state;
  String city;
  String post_code;
  String country;
  String email;
  String phone;
  String created_by;
  String status;

  factory Address.fromMap(Map<String, dynamic> json) => Address(
    id: json["id"].toString(),
    user_id: json["user_id"],
    first_name: json["first_name"],
    last_name: json["last_name"],
    address_a: json["address_a"],
    address_b: json["address_b"],
    state: json["state"],
    city: json["city"],
    post_code: json["post_code"],
    country: json["country"],
    email: json["email"],
    created_by: json["created_by"],
    phone: json["phone"],
    status: json["status"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "user_id": user_id,
    "first_name": first_name,
    "last_name": last_name,
    "address_a": address_a,
    "address_b": address_b,
    "state": state,
    "city": city,
    "post_code": post_code,
    "country": country,
    "email": email,
    "phone": phone,
    "created_by": created_by,
    "status": status,
  };
}
