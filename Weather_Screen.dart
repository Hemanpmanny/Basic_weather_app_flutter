// ignore: file_names
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/AdditionalinfoItem.dart';
import 'package:weather/HourlyforecastItem.dart';
import 'package:http/http.dart' as http;
import 'package:weather/secreats.dart';

// ignore: camel_case_types
class Weather_Screen extends StatefulWidget {
  const Weather_Screen({super.key});

  @override
  State<Weather_Screen> createState() => _Weather_ScreenState();
}

class _Weather_ScreenState extends State<Weather_Screen> {
  late Future<Map<String, dynamic>> weather;
  Future<Map<String, dynamic>> getCurrentWeather() async {
    String cityname = 'London';
    try {
      final res = await http.get(Uri.parse(
          'http://api.openweathermap.org/data/2.5/forecast?q=$cityname&APPID=$openWeatherAPIkey'));
      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw data['message']; //throw "An unexpected error occured"
      }
      return data;
      //data['list'][0]['main']['temp'];
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Weather app',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 30, top: 5),
            child: IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  weather = getCurrentWeather();
                });
              },
            ),
          )
        ],
      ),
      body: FutureBuilder(
        future: weather,
        builder: (context, snapshot) {
          // print(snapshot);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator
                    .adaptive()); // adopted for ios and android
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            ); // because text cant take object it has to convert toString()
          }
          final data = snapshot.data!;
          final currentWeatherdata = data['list'][0];
          final currentTemp = currentWeatherdata['main']
              ['temp']; // or canbe written as data['list'][0]['main']['temp']
          final currentSky = currentWeatherdata['weather'][0]['main'];
          final currentPresure = currentWeatherdata['main']['pressure'];
          final currentHumidity = currentWeatherdata['main']['humidity'];
          final currentwindspeed = currentWeatherdata['wind']['speed'];
          return Padding(
            padding: const EdgeInsets.all(10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              //main card
              SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 9, sigmaY: 9),
                      child: Padding(
                        padding: const EdgeInsets.all(13.0),
                        child: Column(
                          children: [
                            Text(
                              '$currentTemp k',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Icon(
                              currentSky == 'Clouds' || currentSky == 'Rain'
                                  ? Icons.cloud
                                  : Icons.sunny,
                              size: 65,
                            ),
                            const SizedBox(height: 18),
                            Text(
                              "$currentSky",
                              style: const TextStyle(fontSize: 24),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Weather Forecast",
                style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 1),

              //weather forcast card
              // SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   child: Row(
              //     children: [
              //       for (int i = 0; i < 5; i++)
              //         HourlyforecastItem(
              //             time: data['list'][i + 1]['dt'].toString(),
              //             icon: data['list'][i + 1]['weather'][0]['main'] ==
              //                         'Clouds' ||
              //                     data['list'][i + 1]['weather'][0]['main'] ==
              //                         'Rain'
              //                 ? Icons.cloud
              //                 : Icons.sunny,
              //             temperature:
              //                 data['list'][i + 1]['main']['temp'].toString()),
              //     ],
              //   ),
              // ),

              SizedBox(
                height: 130,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      final hourlyforecast = data['list'][index + 1];
                      final hourlysky = hourlyforecast['weather'][0]['main'];
                      final time = DateTime.parse(hourlyforecast[
                          'dt_txt']); // used intl dart dependencies
                      return HourlyforecastItem(
                        time: DateFormat.j()
                            .format(time), // used intl dart dependencies
                        temperature: hourlyforecast['main']['temp'].toString(),
                        icon: hourlysky == 'Clouds' || hourlysky == 'Rain'
                            ? Icons.cloud
                            : Icons.sunny,
                      );
                    }),
              ),

              const SizedBox(
                height: 7,
              ),
              //additional information
              const Text("Additional Information",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AdditionalinfoItem(
                      icon: Icons.water_drop,
                      lable: "Humidity",
                      value: currentHumidity.toString()),
                  AdditionalinfoItem(
                      icon: Icons.air,
                      lable: "Wind",
                      value: currentwindspeed.toString()),
                  AdditionalinfoItem(
                      icon: Icons.beach_access,
                      lable: "Pressure",
                      value: currentPresure.toString()),
                ],
              )
            ]),
          );
        },
      ),
    );
  }
}
