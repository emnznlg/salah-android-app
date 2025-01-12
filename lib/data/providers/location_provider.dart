import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/country.dart';
import '../models/city.dart';
import '../models/district.dart';
import '../services/prayer_api_service.dart';
import '../../core/constants/app_constants.dart';

class LocationProvider with ChangeNotifier {
  final SharedPreferences _prefs;
  final PrayerApiService _apiService = PrayerApiService();

  bool _isLoading = false;
  List<Country> _countries = [];
  List<City> _cities = [];
  List<District> _districts = [];
  Country? _selectedCountry;
  City? _selectedCity;
  District? _selectedDistrict;

  LocationProvider(this._prefs) {
    _loadSavedLocation();
  }

  bool get isLoading => _isLoading;
  List<Country> get countries => _countries;
  List<City> get cities => _cities;
  List<District> get districts => _districts;
  Country? get selectedCountry => _selectedCountry;
  City? get selectedCity => _selectedCity;
  District? get selectedDistrict => _selectedDistrict;
  bool get isLocationSelected => _selectedDistrict != null;

  Future<void> _loadSavedLocation() async {
    final countryJson = _prefs.getString(AppConstants.prefSelectedCountry);
    final cityJson = _prefs.getString(AppConstants.prefSelectedCity);
    final districtJson = _prefs.getString(AppConstants.prefSelectedDistrict);

    if (countryJson != null && cityJson != null && districtJson != null) {
      _selectedCountry = Country.fromJson(
          Map<String, dynamic>.from(Map.castFrom(json.decode(countryJson))));
      _selectedCity = City.fromJson(
          Map<String, dynamic>.from(Map.castFrom(json.decode(cityJson))));
      _selectedDistrict = District.fromJson(
          Map<String, dynamic>.from(Map.castFrom(json.decode(districtJson))));
      notifyListeners();
    }
  }

  Future<void> fetchCountries() async {
    _isLoading = true;
    notifyListeners();

    try {
      _countries = await _apiService.getCountries();
    } catch (e) {
      debugPrint('Ülke listesi alınırken hata oluştu: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchCities(Country country) async {
    _isLoading = true;
    _selectedCountry = country;
    _selectedCity = null;
    _selectedDistrict = null;
    _cities = [];
    _districts = [];
    notifyListeners();

    try {
      _cities = await _apiService.getCities(country.id);
    } catch (e) {
      debugPrint('Şehir listesi alınırken hata oluştu: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchDistricts(City city) async {
    _isLoading = true;
    _selectedCity = city;
    _selectedDistrict = null;
    _districts = [];
    notifyListeners();

    try {
      _districts = await _apiService.getDistricts(city.id);
    } catch (e) {
      debugPrint('İlçe listesi alınırken hata oluştu: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> selectDistrict(District district) async {
    _selectedDistrict = district;
    await _saveLocation();
    notifyListeners();
  }

  Future<void> _saveLocation() async {
    if (_selectedCountry != null &&
        _selectedCity != null &&
        _selectedDistrict != null) {
      await _prefs.setString(AppConstants.prefSelectedCountry,
          json.encode(_selectedCountry!.toJson()));
      await _prefs.setString(
          AppConstants.prefSelectedCity, json.encode(_selectedCity!.toJson()));
      await _prefs.setString(AppConstants.prefSelectedDistrict,
          json.encode(_selectedDistrict!.toJson()));
    }
  }

  void clearCountry() {
    _selectedCountry = null;
    _selectedCity = null;
    _selectedDistrict = null;
    _cities = [];
    _districts = [];
    notifyListeners();
  }

  void clearCity() {
    _selectedCity = null;
    _selectedDistrict = null;
    _districts = [];
    notifyListeners();
  }

  Future<void> clearLocation() async {
    _selectedCountry = null;
    _selectedCity = null;
    _selectedDistrict = null;
    _cities = [];
    _districts = [];
    await _prefs.remove(AppConstants.prefSelectedCountry);
    await _prefs.remove(AppConstants.prefSelectedCity);
    await _prefs.remove(AppConstants.prefSelectedDistrict);
    notifyListeners();
  }
}
