import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/prayer_times.dart';

class LocalStorageService {
  static const String _prayerTimesKey = 'prayer_times';
  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  Future<void> savePrayerTimes(List<PrayerTimes> prayerTimes) async {
    final jsonList = prayerTimes.map((pt) => pt.toJson()).toList();
    await _prefs.setString(_prayerTimesKey, json.encode(jsonList));
  }

  List<PrayerTimes>? getPrayerTimes() {
    final jsonString = _prefs.getString(_prayerTimesKey);
    if (jsonString == null) return null;

    final jsonList = json.decode(jsonString) as List;
    return jsonList.map((json) => PrayerTimes.fromJson(json)).toList();
  }

  Future<void> clearPrayerTimes() async {
    await _prefs.remove(_prayerTimesKey);
  }
}
