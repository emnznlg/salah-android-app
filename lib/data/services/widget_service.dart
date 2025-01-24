import 'package:home_widget/home_widget.dart';

class WidgetService {
  static const String appWidgetProviderClass = 'SalahWidgetProvider';

  static Future<void> updatePrayerTimes({
    required String imsak,
    required String gunes,
    required String ogle,
    required String ikindi,
    required String aksam,
    required String yatsi,
    required String nextPrayer,
  }) async {
    try {
      await Future.wait([
        HomeWidget.saveWidgetData('imsak', imsak),
        HomeWidget.saveWidgetData('gunes', gunes),
        HomeWidget.saveWidgetData('ogle', ogle),
        HomeWidget.saveWidgetData('ikindi', ikindi),
        HomeWidget.saveWidgetData('aksam', aksam),
        HomeWidget.saveWidgetData('yatsi', yatsi),
        HomeWidget.saveWidgetData('next_prayer',
            nextPrayer.isEmpty ? 'Sonraki Vakte: --:--' : nextPrayer),
      ]);

      await HomeWidget.updateWidget(
        androidName: appWidgetProviderClass,
      );
    } catch (e) {
      print('Widget güncelleme hatası: $e');
    }
  }

  static Future<void> clearWidgetData() async {
    try {
      await Future.wait([
        HomeWidget.saveWidgetData('imsak', '00:00'),
        HomeWidget.saveWidgetData('gunes', '00:00'),
        HomeWidget.saveWidgetData('ogle', '00:00'),
        HomeWidget.saveWidgetData('ikindi', '00:00'),
        HomeWidget.saveWidgetData('aksam', '00:00'),
        HomeWidget.saveWidgetData('yatsi', '00:00'),
        HomeWidget.saveWidgetData('next_prayer', 'Sonraki Vakte: --:--'),
      ]);

      await HomeWidget.updateWidget(
        androidName: appWidgetProviderClass,
      );
    } catch (e) {
      print('Widget temizleme hatası: $e');
    }
  }
}
