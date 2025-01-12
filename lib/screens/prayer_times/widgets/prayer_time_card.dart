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
                      child: Icon(
                        _getIconForPrayer(title),
                        color: isCurrent
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface.withOpacity(0.7),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
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

  IconData _getIconForPrayer(String prayer) {
    switch (prayer) {
      case 'İmsak':
        return Icons.nightlight_round;
      case 'Güneş':
        return Icons.wb_sunny;
      case 'Öğle':
        return Icons.light_mode;
      case 'İkindi':
        return Icons.wb_twilight;
      case 'Akşam':
        return Icons.nights_stay;
      case 'Yatsı':
        return Icons.dark_mode;
      default:
        return Icons.access_time;
    }
  }
}
