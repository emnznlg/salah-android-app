import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'data/providers/location_provider.dart';
import 'data/providers/prayer_times_provider.dart';
import 'data/providers/theme_provider.dart';
import 'data/services/widget_service.dart';
import 'screens/prayer_times/prayer_times_screen.dart';
import 'screens/location/location_selection_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  // Widget verilerini temizle
  await WidgetService.clearWidgetData();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider(prefs)),
        ChangeNotifierProvider(create: (_) => LocationProvider(prefs)),
        ChangeNotifierProvider(create: (_) => PrayerTimesProvider(prefs)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final locationProvider = context.watch<LocationProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      home: locationProvider.selectedDistrict == null
          ? const LocationSelectionScreen()
          : const PrayerTimesScreen(),
    );
  }
}
