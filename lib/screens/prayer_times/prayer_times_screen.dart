import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../data/providers/location_provider.dart';
import '../../data/providers/prayer_times_provider.dart';
import '../../data/providers/theme_provider.dart';
import '../settings/settings_screen.dart';
import 'widgets/prayer_time_card.dart';

class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final locationProvider = context.read<LocationProvider>();
      if (locationProvider.selectedDistrict != null) {
        context
            .read<PrayerTimesProvider>()
            .fetchPrayerTimes(locationProvider.selectedDistrict!.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Consumer<LocationProvider>(
          builder: (context, provider, child) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.location_on,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  provider.selectedDistrict?.name ?? '',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            );
          },
        ),
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return IconButton(
                icon: Icon(
                  Icons.settings,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: Consumer<PrayerTimesProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                ),
              );
            }

            if (provider.currentDayPrayerTimes == null) {
              return Center(
                child: Text(
                  'Namaz vakitleri yüklenemedi',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              );
            }

            final times = provider.currentDayPrayerTimes!;
            final nextPrayer = provider.nextPrayerName ?? 'Bilinmiyor';

            return SafeArea(
              minimum: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Sonraki Vakte Kalan Süre',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.7),
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            provider.remainingTimeText,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 420,
                        child: ListView(
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            PrayerTimeCard(
                              title: AppConstants.fajrPrayer,
                              time: times.fajr,
                              isNext: nextPrayer == AppConstants.fajrPrayer,
                              isCurrent: provider.currentPrayerName ==
                                  AppConstants.fajrPrayer,
                            ),
                            PrayerTimeCard(
                              title: AppConstants.sunrisePrayer,
                              time: times.sunrise,
                              isNext: nextPrayer == AppConstants.sunrisePrayer,
                              isCurrent: provider.currentPrayerName ==
                                  AppConstants.sunrisePrayer,
                            ),
                            PrayerTimeCard(
                              title: AppConstants.dhuhrPrayer,
                              time: times.dhuhr,
                              isNext: nextPrayer == AppConstants.dhuhrPrayer,
                              isCurrent: provider.currentPrayerName ==
                                  AppConstants.dhuhrPrayer,
                            ),
                            PrayerTimeCard(
                              title: AppConstants.asrPrayer,
                              time: times.asr,
                              isNext: nextPrayer == AppConstants.asrPrayer,
                              isCurrent: provider.currentPrayerName ==
                                  AppConstants.asrPrayer,
                            ),
                            PrayerTimeCard(
                              title: AppConstants.maghribPrayer,
                              time: times.maghrib,
                              isNext: nextPrayer == AppConstants.maghribPrayer,
                              isCurrent: provider.currentPrayerName ==
                                  AppConstants.maghribPrayer,
                            ),
                            PrayerTimeCard(
                              title: AppConstants.ishaPrayer,
                              time: times.isha,
                              isNext: nextPrayer == AppConstants.ishaPrayer,
                              isCurrent: provider.currentPrayerName ==
                                  AppConstants.ishaPrayer,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
