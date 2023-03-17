import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_api.dart';
import 'package:weather_app/views/additional_information.dart';
import 'package:weather_app/views/current_weather.dart';
import 'package:dcdg/dcdg.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WeatherApiClient client = WeatherApiClient();
  Weather? data;
  final location = 15;
  double x = 0.5;
  String searchValue = 'Северодвинск';
  final List<String> _suggestions = [
    'Архангельск',
    'Новодвинск',
    'Москва',
    'Санкт-Петербург',
  ];

  Future<void> getData() async {
    data = await client.getCurrentWeather("$searchValue");
  }

  Icon customIcon = const Icon(Icons.search);
  Widget customTitle = const Text("Погода");

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Погода',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: Scaffold(
            appBar: EasySearchBar(
                title: const Text('Приложение погоды'),
                onSearch: (value) => setState(() => searchValue = value),
                suggestions: _suggestions),
            body: FutureBuilder(
              future: getData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      currentWeather(
                          Icons.cloud, "${data!.temp}°C", "${data!.cityName}"),
                      SizedBox(height: 60.0),
                      Text("Погодные условия",
                          style: TextStyle(fontSize: 24.0, color: Colors.grey)),
                      Divider(),
                      SizedBox(height: 20.0),
                      additionalInformation(
                          "${data!.wind} м/с",
                          "${data!.humidity}",
                          "${(data!.pressure)} мм ртутного столба",
                          "${data!.feels_like}°C")
                    ],
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Container();
              },
            )
        )
    );
  }
}
