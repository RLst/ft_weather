import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../models/weather_model.dart';
import '../services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  //api key
  final _weatherService = WeatherService('c18499b9d367f910eb58cda6580101a8');
  Weather? _weather;
  late String _weatherAssetPath;
  
  //fetch weather
  _fetchWeather() async {
    //get the current city
    String cityName = await _weatherService.getCurrentCity();

    //get weather for the city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }
    catch (e) {
      print(e);
    }
  }

  //weather animations
  String getWeatherAnimation(String? weatherCondition)
  {
    if (weatherCondition == null) return 'assets/sunny.json';

    switch (weatherCondition.toLowerCase()) {
      case 'clouds':
        return 'assets/cloudy.json';

      case 'mist':
      case 'haze':
      case 'smoke':
      case 'dust':
      case 'fog':
        return 'assets/foggy.json';
      
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/partly_shower.json';

      case 'thunderstorm':
        return 'assets/storm.json';

      case 'clear':
      default:
        return 'assets/sunny.json';
    }
  }

  //init state
  @override
  void initState() {
    super.initState();

    _fetchWeather();

  }

  @override
  Widget build(BuildContext context) {
    _weatherAssetPath = getWeatherAnimation(_weather?.mainCondition);

    return Scaffold(
      backgroundColor: Colors.grey[500],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          //city name
          Text(_weather?.cityName ?? 'Loading city...'),

          //animation
          Lottie.asset(_weatherAssetPath),
      
          //temperature
          Text('${_weather?.temperature.round()}°C'),

          Text(_weather?.mainCondition ?? ''),
      
        ],),
      ),
    );
  }
}