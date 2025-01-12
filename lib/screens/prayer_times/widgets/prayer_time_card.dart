import 'package:flutter/material.dart';

class PrayerTimeCard extends StatelessWidget {
  final String title;
  final String time;
  final bool isNext;
  final bool isCurrent;

  const PrayerTimeCard({
    super.key,
    required this.title,
    required this.time,
    required this.isNext,
    required this.isCurrent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.onSurface.withOpacity(0.1),
            width: 0.5,
          ),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? theme.colorScheme.primary.withOpacity(0.1)
                            : theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.asset(
                        _getIconForPrayer(title),
                        width: 20,
                        height: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: isCurrent
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface,
                        fontWeight:
                            isCurrent ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                Text(
                  time,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: isCurrent
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getIconForPrayer(String prayer) {
    switch (prayer) {
      case 'İmsak':
        return 'assets/icons/fajr.png';
      case 'Güneş':
        return 'assets/icons/sunrise.png';
      case 'Öğle':
        return 'assets/icons/dhuhr.png';
      case 'İkindi':
        return 'assets/icons/asr.png';
      case 'Akşam':
        return 'assets/icons/maghrib.png';
      case 'Yatsı':
        return 'assets/icons/isha.png';
      default:
        return 'assets/icons/mosque.png';
    }
  }
}
