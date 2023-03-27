class RecordLocationBody {
  String token = "";
  double longitude = 0.0;
  double latitude = 0.0;
  String location = "";
  double speed = 0.0;
  String datetime = "";

  RecordLocationBody(
      {required this.token,
      required this.longitude,
      required this.latitude,
      required this.location,
      required this.speed,
      required this.datetime});

  RecordLocationBody.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    longitude = json['longitude'].toDouble();
    latitude = json['latitude'].toDouble();
    location = json['location'];
    speed = json['speed'];
    datetime = json['datetime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['location'] = this.location;
    data['speed'] = this.speed;
    data['datetime'] = this.datetime;
    return data;
  }
}
