import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather_model.dart';

class WeatherApiClient{
  Future<Weather>? getCurrentWeather(String? location) async{
    // --dart-define=Test=f1bb25cccbecb068797a7e1589a48973
    const String API_KEY = String.fromEnvironment('Test');
    log('test: $API_KEY');
    var endpoint = Uri.parse("https://api.openweathermap.org/data/2.5/weather?q=$location&appid=$API_KEY&units=metric&lang=ru");
    var response = await http.get(endpoint);
    var body = jsonDecode(response.body);
    return Weather.fromJson(body);
  }
}