class PrayerTimes {
  final String fajr; // İmsak
  final String sunrise; // Güneş
  final String dhuhr; // Öğle
  final String asr; // İkindi
  final String maghrib; // Akşam
  final String isha; // Yatsı
  final String date;
  final String hijriDate;

  PrayerTimes({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.date,
    required this.hijriDate,
  });

  factory PrayerTimes.fromJson(Map<String, dynamic> json) {
    return PrayerTimes(
      fajr: json['Imsak'],
      sunrise: json['Gunes'],
      dhuhr: json['Ogle'],
      asr: json['Ikindi'],
      maghrib: json['Aksam'],
      isha: json['Yatsi'],
      date: json['MiladiTarihKisa'],
      hijriDate: json['HicriTarihKisa'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Imsak': fajr,
      'Gunes': sunrise,
      'Ogle': dhuhr,
      'Ikindi': asr,
      'Aksam': maghrib,
      'Yatsi': isha,
      'MiladiTarihKisa': date,
      'HicriTarihKisa': hijriDate,
    };
  }
}
