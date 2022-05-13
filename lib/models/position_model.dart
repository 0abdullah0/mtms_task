class MtmsPosition {
  String? name;
  double? latitude;
  double? longitude;

  MtmsPosition({this.name, this.latitude, this.longitude});

  MtmsPosition.fromJson(Map<String, dynamic> json) {
    name = json['name'] as String?;
    latitude = json['latitude'] as double?;
    longitude = json['longitude'] as double?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}
