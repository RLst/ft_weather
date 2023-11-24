// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../models/weather.dart';
import 'package:http/http.dart' as http;

// import 'package:geocoder2/geocoder2.dart';
// import 'package:google_geocoding_api/google_geocoding_api.dart';

class WeatherService {
  // ignore: constant_identifier_names
  static const WEATHER_URL = 'http://api.openweathermap.org/data/2.5/weather';
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

    // //Old geocoding
    // //    //convert the location into a list of placemark objects
    // List<Placemark> placemarks =
    //     await placemarkFromCoordinates(position.latitude, position.longitude);
    // print('old geo method: ${placemarks[0].locality}');

    //Location to City
    final response = await http.get(Uri.parse(
        '$GEO_REV_URL?lat=${position.latitude}&lon=${position.longitude}&limit=3&appid=$_key'));
    print('weather.geo response: ${response.body}');

    if (response.statusCode == 200) {
      List<Map<String, dynamic>> locations =
          List<Map<String, dynamic>>.from(json.decode(response.body));
      Map<String, dynamic> firstLocation = locations[0];
      String? city = firstLocation['name'];
      print('First city: $city');
      return city ?? "";
    } else {
      throw Exception('Failed to load geo data');
    }
  }

  //City name based
  Future<Weather> getWeather(String cityName) async {
    final response = await http
        .get(Uri.parse('$WEATHER_URL?q=$cityName&appid=$_key&units=metric'));

    // print('weather response: ${response.body}');

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode((response.body)));
    } else {
      throw Exception('Failed to load weather data');
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
    // print('weather response: ${response.body}');

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode((response.body)));
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
