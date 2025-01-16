import 'dart:convert';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/additionnal_info.dart';
import 'package:weather_app/hourly_forcast.dart';
import 'package:http/http.dart' as http;
import '../secret.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<Map<String, dynamic>> fetchWeather() async {
    var url =
        'https://api.openweathermap.org/data/2.5/forecast?q=London,uk&APPID=$api'; // Remove any extra spaces

    try {
      // Await the HTTP request and get the response
      final res = await http.get(Uri.parse(url));

      // Handle successful response
      if (res.statusCode == 200) {
        // Decode the JSON response
        var weatherData = jsonDecode(res.body);

        return weatherData;
      }
    } catch (e) {
      // Catch any errors (e.g., network issues, invalid URL)
      throw Exception('Failed to load weather data');
    }
    // Ensure a return statement is always reached
    throw Exception('Unexpected error');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData.dark(useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                setState(() {});
              },
            ),
          ],
          title: Text('Weather App'),
        ),
        body: FutureBuilder(
          future: fetchWeather(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }
            final data = snapshot.data!;
            final currentWeatherData = data['list'][0];
            final currentTemp = currentWeatherData['main']['temp'];
            final currentSky = currentWeatherData['weather'][0]['main'];
            final currentPressure = currentWeatherData['main']['pressure'];
            final currentHumadity = currentWeatherData['main']['humidity'];
            final currentSpeed = currentWeatherData['wind']['speed'];

            return Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                children: [
                                  Text(
                                    currentTemp.toString(),
                                    style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 10),
                                  Icon(
                                      currentSky == 'Rain' ||
                                              currentSky == 'Clouds'
                                          ? Icons.cloud
                                          : Icons.sunny,
                                      size: 50),
                                  const SizedBox(height: 10),
                                  Text(
                                    currentSky,
                                    style: TextStyle(fontSize: 24),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )),
                  ),
                  const SizedBox(height: 10),
                  Text('Weather Forecast',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  // SingleChildScrollView(
                  //   scrollDirection: Axis.horizontal,
                  //   child: Row(
                  //     children: [
                  //       for (var i = 0; i < 9; i++)
                  //         HaurlyForcast(
                  //             label: data['list'][i]['dt'].toString(),
                  //             icon: data['list'][i]['weather'][0]['main'] ==
                  //                         'Rain' ||
                  //                     data['list'][i]['weather'][0]['main'] ==
                  //                         'Clouds'
                  //                 ? Icons.cloud
                  //                 : Icons.sunny,
                  //             temprature:
                  //                 data['list'][i]['main']['temp'].toString()),
                  //     ],
                  //   ),
                  // ),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 9,
                      itemBuilder: (context, index) {
                        final time =
                            DateTime.parse(data['list'][index]['dt_txt']);

                        return HaurlyForcast(
                            label: DateFormat.Hm().format(time),
                            icon: data['list'][index]['weather'][0]['main'] ==
                                        'Rain' ||
                                    data['list'][index]['weather'][0]['main'] ==
                                        'Clouds'
                                ? Icons.cloud
                                : Icons.sunny,
                            temprature:
                                data['list'][index]['main']['temp'].toString());
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('Additional Info',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: AdditionalInfo(
                          label: "Humadity",
                          icon: Icons.water_drop,
                          value: currentHumadity.toString(),
                        ),
                      ),
                      Expanded(
                        child: AdditionalInfo(
                          label: "Wind speed",
                          icon: Icons.wind_power,
                          value: currentSpeed.toString(),
                        ),
                      ),
                      Expanded(
                        child: AdditionalInfo(
                          label: "Pressure",
                          icon: Icons.umbrella,
                          value: currentPressure.toString(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
