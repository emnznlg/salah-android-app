class District {
  final String id;
  final String name;
  final String nameEn;

  District({
    required this.id,
    required this.name,
    required this.nameEn,
  });

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      id: json['IlceID'],
      name: json['IlceAdi'],
      nameEn: json['IlceAdiEn'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'IlceID': id,
      'IlceAdi': name,
      'IlceAdiEn': nameEn,
    };
  }
}
