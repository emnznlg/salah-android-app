class Country {
  final String id;
  final String name;
  final String nameEn;

  Country({
    required this.id,
    required this.name,
    required this.nameEn,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['UlkeID'],
      name: json['UlkeAdi'],
      nameEn: json['UlkeAdiEn'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'UlkeID': id,
      'UlkeAdi': name,
      'UlkeAdiEn': nameEn,
    };
  }
}
