class TrackingService {
  String token = "";
  double longitude = 0.0;
  double latitude = 0.0;
  String location = "";
  String speed = "0";
  String angle = "0";
  String datetime = "";
  String odo;
  int battery;

  TrackingService({
    required this.token,
    required this.latitude,
    required this.angle,
    required this.speed,
    required this.battery,
    required this.longitude,
    required this.location,
    required this.odo,
    required this.datetime,
  });

  factory TrackingService.fromMap(Map<String, dynamic> json) => TrackingService(
        token: json['token'],
        latitude: json['latitude'].toDouble(),
        longitude: json['longitude'].toDouble(),
        angle: json['angle'],
        speed: json['speed'],
        datetime: json['datetime'],
        location: json['location'],
        odo: json['odo'],
        battery: json['battery'],
      );

  Map<String, dynamic> toMap() {
    return {
      'token': token,
      'latitude': latitude,
      'angle': angle,
      'speed': speed,
      'battery': battery,
      'longitude': longitude,
      'location': location,
      'odo': odo,
      'datetime': datetime,
    };
  }
}
