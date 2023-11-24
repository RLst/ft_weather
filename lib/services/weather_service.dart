import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import '../models/weather.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  // ignore: constant_identifier_names
  static const WEATHER_URL = 'http://api.openweathermap.org/data/2.5/weather';
  // ignore: constant_identifier_names
  static const GEO_REV_URL = 'http://api.openweathermap.org/geo/1.0/reverse';

  final String _key;
  late String currentCity;

  WeatherService(this._key);

  Future<String> getCurrentCity() async {
    //Permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    //Current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    //Location to City
    final response = await http.get(Uri.parse(
        '$GEO_REV_URL?lat=${position.latitude}&lon=${position.longitude}&limit=3&appid=$_key'));

    if (response.statusCode == 200) {
      List<Map<String, dynamic>> locations =
          List<Map<String, dynamic>>.from(json.decode(response.body));
      Map<String, dynamic> firstLocation = locations[0];
      String? city = firstLocation['name'];
      return city ?? "";
    } else {
      throw Exception('Failed to load geo data');
    }
  }

  //Coordinates based
  Future<Weather> getWeatherByCoords() async {
    //Permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    //Current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    final response = await http.get(Uri.parse(
        '$WEATHER_URL?lat=${position.latitude}&lon=${position.longitude}&appid=$_key'));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode((response.body)));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  //City name based
  Future<Weather> getWeather(String cityName) async {
    final response = await http
        .get(Uri.parse('$WEATHER_URL?q=$cityName&appid=$_key&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode((response.body)));
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
