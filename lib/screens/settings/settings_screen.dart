import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../data/providers/location_provider.dart';
import '../../data/providers/theme_provider.dart';
import '../location/location_selection_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ayarlar',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSectionTitle(context, 'Tema'),
                _buildThemeSection(context),
                const SizedBox(height: 24),
                _buildSectionTitle(context, 'Konum'),
                _buildLocationSection(context),
                const SizedBox(height: 24),
                _buildSectionTitle(context, 'Uygulama Hakkında'),
                _buildAboutSection(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildThemeSection(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return Column(
              children: [
                _buildThemeOption(
                  context,
                  title: 'Sistem Teması',
                  icon: Icons.brightness_auto,
                  isSelected: themeProvider.themeMode == ThemeMode.system,
                  onTap: () => themeProvider.setThemeMode(ThemeMode.system),
                ),
                _buildDivider(),
                _buildThemeOption(
                  context,
                  title: 'Açık Tema',
                  icon: Icons.light_mode,
                  isSelected: themeProvider.themeMode == ThemeMode.light,
                  onTap: () => themeProvider.setThemeMode(ThemeMode.light),
                ),
                _buildDivider(),
                _buildThemeOption(
                  context,
                  title: 'Koyu Tema',
                  icon: Icons.dark_mode,
                  isSelected: themeProvider.themeMode == ThemeMode.dark,
                  onTap: () => themeProvider.setThemeMode(ThemeMode.dark),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildLocationSection(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Consumer<LocationProvider>(
          builder: (context, locationProvider, child) {
            final hasLocation = locationProvider.selectedDistrict != null;
            return Column(
              children: [
                ListTile(
                  leading: Icon(
                    hasLocation ? Icons.location_on : Icons.location_off,
                    color: hasLocation
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.error,
                  ),
                  title: Text(
                    hasLocation
                        ? locationProvider.selectedDistrict!.name
                        : 'Konum seçilmedi',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: hasLocation
                      ? Text(
                          '${locationProvider.selectedCity?.name}, ${locationProvider.selectedCountry?.name}',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(0.7),
                                  ),
                        )
                      : null,
                  trailing: TextButton.icon(
                    icon: const Icon(Icons.edit_location),
                    label: const Text('Değiştir'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LocationSelectionScreen(),
                        ),
                      );
                      locationProvider.clearLocation();
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            ListTile(
              leading: Icon(
                Icons.mosque,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text(AppConstants.appName),
              subtitle: const Text(AppConstants.appDescription),
            ),
            _buildDivider(),
            ListTile(
              leading: const Icon(Icons.new_releases_outlined),
              title: const Text('Versiyon'),
              trailing: Text(
                AppConstants.appVersion,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context, {
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Theme.of(context).colorScheme.primary : null,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: isSelected ? Theme.of(context).colorScheme.primary : null,
              fontWeight: isSelected ? FontWeight.bold : null,
            ),
      ),
      trailing: isSelected
          ? Icon(
              Icons.check_circle,
              color: Theme.of(context).colorScheme.primary,
            )
          : null,
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, indent: 56);
  }
}
