class City {
  final String id;
  final String name;
  final String nameEn;

  City({
    required this.id,
    required this.name,
    required this.nameEn,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['SehirID'],
      name: json['SehirAdi'],
      nameEn: json['SehirAdiEn'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'SehirID': id,
      'SehirAdi': name,
      'SehirAdiEn': nameEn,
    };
  }
}
