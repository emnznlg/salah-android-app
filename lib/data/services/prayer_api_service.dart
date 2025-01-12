import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/country.dart';
import '../models/city.dart';
import '../models/district.dart';
import '../models/prayer_times.dart';

class PrayerApiService {
  static const String baseUrl = 'https://ezanvakti.emushaf.net';
  static const Duration _minRequestInterval = Duration(seconds: 1);
  static const Duration _timeout = Duration(seconds: 10);
  DateTime? _lastRequestTime;

  Future<void> _checkRateLimit() async {
    if (_lastRequestTime != null) {
      final timeSinceLastRequest = DateTime.now().difference(_lastRequestTime!);
      if (timeSinceLastRequest < _minRequestInterval) {
        final waitTime = _minRequestInterval - timeSinceLastRequest;
        await Future.delayed(waitTime);
      }
    }
    _lastRequestTime = DateTime.now();
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      throw Exception('İnternet bağlantısı yok');
    }
  }

  Future<List<Country>> getCountries() async {
    await _checkRateLimit();
    await _checkConnectivity();
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/ulkeler')).timeout(_timeout);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        return data.map((json) => Country.fromJson(json)).toList();
      }
      throw Exception('Ülke listesi alınamadı');
    } on TimeoutException {
      throw Exception('Bağlantı zaman aşımına uğradı');
    }
  }

  Future<List<City>> getCities(String countryCode) async {
    await _checkRateLimit();
    await _checkConnectivity();
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/sehirler/$countryCode'))
          .timeout(_timeout);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        return data.map((json) => City.fromJson(json)).toList();
      }
      throw Exception('Şehir listesi alınamadı');
    } on TimeoutException {
      throw Exception('Bağlantı zaman aşımına uğradı');
    }
  }

  Future<List<District>> getDistricts(String cityCode) async {
    await _checkRateLimit();
    await _checkConnectivity();
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/ilceler/$cityCode'))
          .timeout(_timeout);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        return data.map((json) => District.fromJson(json)).toList();
      }
      throw Exception('İlçe listesi alınamadı');
    } on TimeoutException {
      throw Exception('Bağlantı zaman aşımına uğradı');
    }
  }

  Future<List<PrayerTimes>> getPrayerTimes(String districtCode) async {
    await _checkRateLimit();
    await _checkConnectivity();
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/vakitler/$districtCode'))
          .timeout(_timeout);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        return data.map((json) => PrayerTimes.fromJson(json)).toList();
      }
      throw Exception('Namaz vakitleri alınamadı');
    } on TimeoutException {
      throw Exception('Bağlantı zaman aşımına uğradı');
    }
  }
}
