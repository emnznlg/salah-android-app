import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/providers/location_provider.dart';
import '../location/location_selection_screen.dart';
import '../prayer_times/prayer_times_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final locationProvider = context.read<LocationProvider>();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => locationProvider.isLocationSelected
            ? const PrayerTimesScreen()
            : const LocationSelectionScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/salah_app_icon_black.png',
              width: 150,
              height: 150,
            ),
          ],
        ),
      ),
    );
  }
}
