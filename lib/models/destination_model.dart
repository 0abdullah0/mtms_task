class Destination {
  String? country;
  String? name;
  String? lat;
  String? lng;

  Destination({this.country, this.name, this.lat, this.lng});

  Destination.fromJson(Map<String, dynamic> json) {
    country = json['country'] as String?;
    name = json['name'] as String?;
    lat = json['lat'] as String?;
    lng = json['lng'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['country'] = country;
    data['name'] = name;
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}
