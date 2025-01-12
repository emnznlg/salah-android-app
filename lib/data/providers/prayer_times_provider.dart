import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/prayer_times.dart';
import '../services/prayer_api_service.dart';
import '../services/local_storage_service.dart';

class PrayerTimesProvider with ChangeNotifier {
  final PrayerApiService _apiService = PrayerApiService();
  final LocalStorageService _storageService;
  List<PrayerTimes> _prayerTimes = [];
  bool _isLoading = false;
  Timer? _timer;
  String? _lastError;

  PrayerTimesProvider(SharedPreferences prefs)
      : _storageService = LocalStorageService(prefs) {
    _loadLocalPrayerTimes();
  }

  List<PrayerTimes> get prayerTimes => _prayerTimes;
  bool get isLoading => _isLoading;
  String? get lastError => _lastError;

  Future<void> _loadLocalPrayerTimes() async {
    final localTimes = _storageService.getPrayerTimes();
    if (localTimes != null) {
      _prayerTimes = localTimes;
      notifyListeners();
    }
  }

  PrayerTimes? get currentDayPrayerTimes {
    if (_prayerTimes.isEmpty) return null;
    final now = DateTime.now();
    return _prayerTimes.firstWhere(
      (times) =>
          times.date ==
          '${now.day.toString().padLeft(2, '0')}.${now.month.toString().padLeft(2, '0')}.${now.year}',
      orElse: () => _prayerTimes.first,
    );
  }

  String? get nextPrayerName {
    if (currentDayPrayerTimes == null) return null;
    final now = DateTime.now();
    final currentTime =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    if (currentTime.compareTo(currentDayPrayerTimes!.fajr) < 0) return 'İmsak';
    if (currentTime.compareTo(currentDayPrayerTimes!.sunrise) < 0)
      return 'Güneş';
    if (currentTime.compareTo(currentDayPrayerTimes!.dhuhr) < 0) return 'Öğle';
    if (currentTime.compareTo(currentDayPrayerTimes!.asr) < 0) return 'İkindi';
    if (currentTime.compareTo(currentDayPrayerTimes!.maghrib) < 0)
      return 'Akşam';
    if (currentTime.compareTo(currentDayPrayerTimes!.isha) < 0) return 'Yatsı';
    return 'İmsak';
  }

  Duration? get timeUntilNextPrayer {
    if (currentDayPrayerTimes == null) return null;
    final now = DateTime.now();
    final currentTime =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    DateTime next;
    if (currentTime.compareTo(currentDayPrayerTimes!.fajr) < 0) {
      next = _parseTime(currentDayPrayerTimes!.fajr);
    } else if (currentTime.compareTo(currentDayPrayerTimes!.sunrise) < 0) {
      next = _parseTime(currentDayPrayerTimes!.sunrise);
    } else if (currentTime.compareTo(currentDayPrayerTimes!.dhuhr) < 0) {
      next = _parseTime(currentDayPrayerTimes!.dhuhr);
    } else if (currentTime.compareTo(currentDayPrayerTimes!.asr) < 0) {
      next = _parseTime(currentDayPrayerTimes!.asr);
    } else if (currentTime.compareTo(currentDayPrayerTimes!.maghrib) < 0) {
      next = _parseTime(currentDayPrayerTimes!.maghrib);
    } else if (currentTime.compareTo(currentDayPrayerTimes!.isha) < 0) {
      next = _parseTime(currentDayPrayerTimes!.isha);
    } else {
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      final tomorrowDate =
          '${tomorrow.day.toString().padLeft(2, '0')}.${tomorrow.month.toString().padLeft(2, '0')}.${tomorrow.year}';
      final tomorrowTimes = _prayerTimes.firstWhere(
        (times) => times.date == tomorrowDate,
        orElse: () => currentDayPrayerTimes!,
      );
      next = _parseTime(tomorrowTimes.fajr, addDay: true);
    }

    return next.difference(now);
  }

  String get remainingTimeText {
    final duration = timeUntilNextPrayer;
    if (duration == null) return '';

    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '$hours s $minutes dk';
  }

  Future<void> fetchPrayerTimes(String districtId) async {
    _isLoading = true;
    _lastError = null;
    notifyListeners();

    try {
      final times = await _apiService.getPrayerTimes(districtId);
      _prayerTimes = times;
      await _storageService.savePrayerTimes(times);
      _startTimer();
    } catch (e) {
      _lastError = e.toString();
      // Eğer internet bağlantısı yoksa veya API'ye erişilemiyorsa,
      // yerel depolamadan verileri yükle
      await _loadLocalPrayerTimes();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      notifyListeners();
    });
  }

  DateTime _parseTime(String timeStr, {bool addDay = false}) {
    final parts = timeStr.split(':');
    final now = DateTime.now();
    var time = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );

    if (addDay) {
      time = time.add(const Duration(days: 1));
    }

    return time;
  }

  String? get currentPrayerName {
    if (currentDayPrayerTimes == null) return null;
    final now = DateTime.now();
    final currentTime =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    if (currentTime.compareTo(currentDayPrayerTimes!.fajr) < 0) {
      return 'Yatsı';
    }
    if (currentTime.compareTo(currentDayPrayerTimes!.sunrise) < 0) {
      return 'İmsak';
    }
    if (currentTime.compareTo(currentDayPrayerTimes!.dhuhr) < 0) return 'Güneş';
    if (currentTime.compareTo(currentDayPrayerTimes!.asr) < 0) return 'Öğle';
    if (currentTime.compareTo(currentDayPrayerTimes!.maghrib) < 0) {
      return 'İkindi';
    }
    if (currentTime.compareTo(currentDayPrayerTimes!.isha) < 0) return 'Akşam';
    return 'Yatsı';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
