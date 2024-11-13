import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:weatherzomato/model/CustomWeatherModel.dart';
import 'package:weatherzomato/model/WeatherModel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String subLocality = "";
  String date = "";
  String day = "";
  WeatherModel model = WeatherModel();
  CustomWeatherModel customWeatherModel = CustomWeatherModel();
  final baseUrl = "www.weatherunion.com";


  @override
  void initState() {
    super.initState();
    getCurrentDateTime();
    requestPermission(Permission.locationWhenInUse);
  }

  Future<WeatherModel> callWeatherApi(String longitude, String latitude) async {
    final queryParameters = {
      'latitude': latitude,
      'longitude': longitude,
    };
    final uri = Uri.https(
        baseUrl, "/gw/weather/external/v0/get_weather_data/", queryParameters);
    print('final uri is ${uri.toString()}');
    final response = await http.get(
      uri,
      headers: {"x-zomato-api-key": "42bdbb8d00e9e9168e4ec1e0bd1c4ac9"},
    ).timeout(const Duration(seconds: 60));
    print('response => ${response.statusCode} and body is ${response.body}');
    return WeatherModel.fromJson(jsonDecode(response.body));
  }

  Future<void> requestPermission(Permission permission) async {
    final status = await permission.request();
    if (status.isGranted) {
      print('permission granted');
      getLocation();
    } else {
      print('permission not granted ${status.toString()}');
    }
  }

  void getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    print(position.latitude);
    print(position.longitude);
    var localityString = getPlacemarks(position.latitude, position.longitude);
    print("locality is ${localityString.toString()}");
    //var data = callWeatherApi(position.longitude.toString(), position.latitude.toString());
    var data = callWeatherApi( "77.625825","12.933756");
    model = await data;
    if(int.parse(model.status ?? "500") == 200) {
      var finalModel = model.localityWeatherData;
      if(finalModel != null) {
        customWeatherModel.temperature = finalModel.temperature?.toString() ?? "NA";
        customWeatherModel.humidity = finalModel.humidity?.toString() ?? "NA";
        customWeatherModel.windSpeed = finalModel.windSpeed?.toString() ?? "NA";
        customWeatherModel.windDirection = finalModel.windDirection?.toString() ?? "NA";
        customWeatherModel.rainIntensity = finalModel.rainIntensity?.toString() ?? "NA";
        customWeatherModel.rainAccumulation = finalModel.rainAccumulation?.toString() ?? "NA";
        print('custom weather data is ${customWeatherModel.temperature}');
        setState(() {
          customWeatherModel.temperature;
          customWeatherModel.humidity;
          customWeatherModel.rainIntensity;
          customWeatherModel.windSpeed;
        });
      }
    } else {
      showInSnackBar("Api Failed!! Please Try Again Later");
    }
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: new Text(value)
    ));
  }

  Future<String> getPlacemarks(double lat, double long) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);

      var address = '';

      if (placemarks.isNotEmpty) {

        // Concatenate non-null components of the address
        var streets = placemarks.reversed
            .map((placemark) => placemark.street)
            .where((street) => street != null);

        // Filter out unwanted parts
        streets = streets.where((street) =>
        street!.toLowerCase() !=
            placemarks.reversed.last.locality!
                .toLowerCase()); // Remove city names
        streets =
            streets.where((street) => !street!.contains('+')); // Remove street codes

        address += streets.join(', ');

        address += ', ${placemarks.reversed.last.subLocality ?? ''}';
        address += ', ${placemarks.reversed.last.locality ?? ''}';
        address += ', ${placemarks.reversed.last.subAdministrativeArea ?? ''}';
        address += ', ${placemarks.reversed.last.administrativeArea ?? ''}';
        address += ', ${placemarks.reversed.last.postalCode ?? ''}';
        address += ', ${placemarks.reversed.last.country ?? ''}';
      }

      print("Your Address for ($lat, $long) is: $address");

      subLocality = placemarks.reversed.last.subLocality ?? "SubLocality Not Found";
      setState(() {
        subLocality;
      });

      return address;
    } catch (e) {
      print("Error getting placemarks: $e");
      return "No Address found";
    }
  }

  String getCurrentDateTime() {
    DateTime now = DateTime.now();
    date = DateFormat('dd MMMM,').format(now);
    day = DateFormat('EEEE').format(now);
    print('Formatted date: $date $day');
    return "";
  }

  bool checkForApiFailure() {
    var finalModel = customWeatherModel.temperature ?? "NA";
    if(finalModel.isEmpty || finalModel == "NA") {
      return true;
    } else {
      return false;
    }
  }


  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          await requestPermission(Permission.locationWhenInUse);
          print('refreshing please wait.....');
        },
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height:MediaQuery.of(context).size.height * 0.6,
                  width: screenWidth,
                  child: Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    semanticContainer: true,
                    color: Colors.deepPurpleAccent[800],
                    shadowColor: Colors.deepPurpleAccent[400],
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: (checkForApiFailure())
                                  ? const AssetImage("assets/images/apifailed.jpg")
                                  : const AssetImage("assets/images/nature1.jpeg"),
                              fit: BoxFit.fill,
                              alignment: Alignment.center
                          )
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          (checkForApiFailure()) ? setFailureWidget() : setSuccessWidget()
                        ],
                      ),
                    )
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.28,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Expanded(
                        child: OtherParam(
                            otherparam: customWeatherModel.windSpeed ?? "NA",
                            cardType: CardType.WIND
                        ),
                      ),
                      Expanded(
                        child: OtherParam(
                            otherparam: customWeatherModel.humidity ?? "NA",
                            cardType: CardType.HUMIDITY
                        ),
                      ),
                      Expanded(
                        child: OtherParam(
                            otherparam: customWeatherModel.rainIntensity ?? "NA",
                            cardType: CardType.RAIN
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget setSuccessWidget() {
    return Column(
      children: [
        dateAndTimeWidget(date,day),
        setTemperatureWidget(customWeatherModel.temperature ?? "NA"),
        setLocationWidget(subLocality)
      ],
    );
  }

  Widget setFailureWidget() {
    return Column(
      children: [
        dateAndTimeWidget(date, day)
      ],
    );
  }

  Widget dateAndTimeWidget(String date,String day) {
    return Container(
      padding: const EdgeInsets.only(top: 40),
      child: RichText(
          text: TextSpan(
            text: date,
            style: const TextStyle(
              fontSize: 22,
              color: Colors.white
            ),
            children: [
              TextSpan(
                text: ' $day',
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.white60
                )
              )
            ]
          )
      ),
    );
  }

  Widget setTemperatureWidget(String temp) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 100),
      child: (temp != "NA")
          ? Text("$temp°C",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 70,
                  fontWeight: FontWeight.bold))
          : Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/reload.png',
                    alignment: Alignment.center,
                    height: 50,
                    width: 50,
                  ),
                  const Text(
                    'Failed to load Data',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.normal),
                  )
                ],
              ),
            ),
    );
  }

  Widget setLocationWidget(String subLocation) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        subLocation,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.normal
        ),
      ),
    );
  }

}
//test

class OtherParam extends StatelessWidget {
  final CardType cardType;
  final String otherparam;


  const OtherParam({super.key,required this.otherparam,required this.cardType});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.20,
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        semanticContainer: true,
        color: Colors.deepPurpleAccent[700],
        shadowColor: Colors.deepPurpleAccent[400],
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blueAccent,
                Colors.deepPurpleAccent,
                Colors.deepPurple,
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),

            )
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Icon(
                  cardType.icons,
                  color: Colors.white,
                  size: 24.0,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  cardType.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: 15
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  cardType.getUnits(otherparam),
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 15
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}



enum ApiResponse { SUCCESS, ERROR, FAILED }
enum CardType {WIND,HUMIDITY,RAIN}

extension WeatherTypeProperties on CardType {

  String get label {
    switch(this) {
      case  CardType.WIND:
        return "Wind";
      case CardType.HUMIDITY:
        return "Humidity";
      case CardType.RAIN:
        return "Rain";
    }
  }

  IconData get icons {
    switch(this) {
      case CardType.WIND:
        return Icons.wind_power_sharp;
      case CardType.HUMIDITY:
        return Icons.water;
      case CardType.RAIN:
        return Icons.water_drop_outlined;
    }
  }

  String getUnits(String data) {
    switch(this) {
      case CardType.WIND:
        if(data.isEmpty || data == "NA") {
          return "NA";
        } else {
          return "$data km/h";
        }
      case CardType.HUMIDITY:
        if(data.isEmpty || data == "NA") {
          return "NA";
        } else {
          return "$data%";
        }
      case CardType.RAIN:
        if(data.isEmpty || data == "NA") {
          return "NA";
        } else {
          return "$data%";
        }
    }
  }
}