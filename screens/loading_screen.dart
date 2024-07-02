import 'package:flutter/material.dart';
import 'package:clima2/services/location.dart';
import 'package:clima2/services/networking.dart';
import 'location_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

const apiKey = 'f156be00b9c8bfb362daa8a2a4727f9b';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  @override
  void initState() {
    super.initState();
    getLocationData(); // Immediately get location on initialization
  }

  void getLocationData() async {
    Location location = Location();
    await location.getCurrentLocation(); // Call the instance method

    // double latitude = location.latitude;
    // double longitude = location.longitude;

    NetworkHelper networkHelper = NetworkHelper(
      'http://api.openweathermap.org/data/2.5/weather?lat=${location.latitude}'
          '&lon=${location.longitude}&appid=$apiKey&units=metric',
    );

    var weatherData = await networkHelper.getData();

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return LocationScreen(
        locationWeather: weatherData,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SpinKitDoubleBounce(
          color: Colors.white,
          size: 100,
        ),
      ),
    );
  }
}
