import 'package:flutter/material.dart';
import '../utilities/constants.dart';
import 'package:clima2/services/location.dart';
import 'package:clima2/services/networking.dart';
import 'city_screen.dart';
import 'package:clima2/services/weather.dart';

const apiKey = 'f156be00b9c8bfb362daa8a2a4727f9b';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key, this.locationWeather});

  final dynamic locationWeather;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weather = WeatherModel();

  late int temperature;
  late String weatherIcon;
  late String cityName;
  late int condition;
  late String weatherMessage;

  @override
  void initState() {
    super.initState();
    updateUI(widget.locationWeather);
  }

  void updateUI(dynamic weatherData) {
    setState(() {
      if (weatherData == null) {
        temperature = 0;
        var condition = 0;
        cityName = 'Unknown';
        weatherIcon = '🤷‍'; // Default icon for unknown condition
        return;
      }
      temperature = (weatherData['main']['temp'] as double).toInt();
      var condition = weatherData['weather'][0]['id'];
      weatherIcon = weather.getWeatherIcon(condition);
      weatherMessage = weather.getMessage(temperature);
      cityName = weatherData['name'];
    });

    print(temperature);
  }

  void getLocationData() async {
    Location location = Location();
    await location.getCurrentLocation();
    double latitude = location.latitude;
    double longitude = location.longitude;

    NetworkHelper networkHelper = NetworkHelper(
      'http://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric',
    );

    var weatherData = await networkHelper.getData();
    updateUI(weatherData);
  }

  void getCityData(String cityName) async {
    NetworkHelper networkHelper = NetworkHelper(
      'http://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric',
    );

    var weatherData = await networkHelper.getData();
    updateUI(weatherData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      getLocationData();
                    },
                    child: const Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      var typedName = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return CityScreen();
                          },
                        ),
                      );
                      if (typedName != null) {
                        getCityData(typedName);
                      }
                    },
                    child: const Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$temperature°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      weatherIcon,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Text(
                  "$weatherMessage in $cityName!",
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import '../utilities/constants.dart';
// import 'package:clima2/services/location.dart';
// import 'package:clima2/services/networking.dart';
// import 'city_screen.dart';
// import 'package:clima2/services/weather.dart';
//
// const apiKey = 'f156be00b9c8bfb362daa8a2a4727f9b';
//
// class LocationScreen extends StatefulWidget {
//   const LocationScreen({super.key, this.locationWeather});
//
//   final dynamic locationWeather;
//
//   @override
//   _LocationScreenState createState() => _LocationScreenState();
// }
//
// class _LocationScreenState extends State<LocationScreen> {
//
//   WeatherModel weather = WeatherModel();
//
//   late int temperature;
//   late String weatherIcon;
//   late String cityName;
//   late int condition;
//   late String weatherMessage;
//
//   @override
//   void initState() {
//     super.initState();
//     updateUI(widget.locationWeather);
//   }
//
//   void updateUI(dynamic weatherData) {
//     setState(() {
//       if (weatherData == null) {
//         temperature = 0;
//         var condition = 0;
//         cityName = 'Unknown';
//         return;
//       }
//       temperature = (weatherData['main']['temp'] as double).toInt();
//       var condition = weatherData['weather'][0]['id'];
//       weatherIcon = weather.getWeatherIcon(condition);
//       weatherMessage = weather.getMessage(temperature);
//       cityName = weatherData['name'];
//     });
//
//     print(temperature);
//   }
//
//   void getLocationData() async {
//     Location location = Location();
//     await location.getCurrentLocation();
//     double latitude = location.latitude;
//     double longitude = location.longitude;
//
//     NetworkHelper networkHelper = NetworkHelper(
//       'http://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric',
//     );
//
//     var weatherData = await networkHelper.getData();
//     updateUI(weatherData);
//   }
//
//   void getCityData(String cityName) async {
//     NetworkHelper networkHelper = NetworkHelper(
//       'http://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric',
//     );
//
//     var weatherData = await networkHelper.getData();
//     updateUI(weatherData);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: const AssetImage('images/location_background.jpg'),
//             fit: BoxFit.cover,
//             colorFilter: ColorFilter.mode(
//                 Colors.white.withOpacity(0.8), BlendMode.dstATop),
//           ),
//         ),
//         constraints: const BoxConstraints.expand(),
//         child: SafeArea(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: <Widget>[
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   TextButton(
//                     onPressed: () {
//                       getLocationData();
//                     },
//                     child: const Icon(
//                       Icons.near_me,
//                       size: 50.0,
//                     ),
//                   ),
//                   TextButton(
//                     onPressed: () async {
//                       var typedName = await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) {
//                             return CityScreen();
//                           },
//                         ),
//                       );
//                       if (typedName != null) {
//                         getCityData(typedName);
//                       }
//                     },
//                     child: const Icon(
//                       Icons.location_city,
//                       size: 50.0,
//                     ),
//                   ),
//                 ],
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 15.0),
//                 child: Row(
//                   children: <Widget>[
//                     Text(
//                       '${temperature.toInt()}°',
//                       style: kTempTextStyle,
//                     ),
//                     Text(
//                       getWeatherIcon(condition),
//                       style: kConditionTextStyle,
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(right: 15.0),
//                 child: Text(
//                   "$weatherMessage in $cityName!",
//                   textAlign: TextAlign.right,
//                   style: kMessageTextStyle,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }




// double temperature = jsonDecode(data)['main']['temp'];
// int condition = jsonDecode(data)['weather'][0]['id'];
// String cityName = jsonDecode(data)['name'];