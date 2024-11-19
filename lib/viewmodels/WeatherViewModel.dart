import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weatherzomato/repository/WeatherRepository.dart';
import 'package:weatherzomato/services/ApiServices.dart';

import '../model/CustomWeatherModel.dart';
import '../model/WeatherModel.dart';

class WeatherViewModel extends ChangeNotifier {

  String _date = "";
  String get date => _date;
  String _day = "";
  String get day => _day;
  final CustomWeatherModel _customWeatherModel = CustomWeatherModel();
  CustomWeatherModel get customWeatherModel => _customWeatherModel;
  String _subLocality = "";
  String get subLocality => _subLocality;
  bool _isApiFailure = false;
  bool get isApiFailure => _isApiFailure;


  WeatherModel model = WeatherModel();
  final ApiService apiService = ApiService();
  late final WeatherRepository weatherRepository;



  void getCurrentDateTime() {
    DateTime now = DateTime.now();
    _date = DateFormat('dd MMMM,').format(now);
    _day = DateFormat('EEEE').format(now);
    print('Formatted date: $date $day');
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
    weatherRepository = WeatherRepository(apiService);
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    print(position.latitude);
    print(position.longitude);
    var localityString = getPlacemarks(position.latitude, position.longitude);
    print("locality is ${localityString.toString()}");
    var data = weatherRepository.getDataForWeather("77.625825","12.933756");
    //var data = weatherRepository.getDataForWeather(position.longitude.toString(),position.latitude.toString());
    model = await data;
    if(int.parse(model.status ?? "500") == 200) {
      var finalModel = model.localityWeatherData;
      if(finalModel != null) {
        _customWeatherModel.temperature = finalModel.temperature?.toString() ?? "NA";
        _customWeatherModel.humidity = finalModel.humidity?.toString() ?? "NA";
        _customWeatherModel.windSpeed = finalModel.windSpeed?.toString() ?? "NA";
        _customWeatherModel.windDirection = finalModel.windDirection?.toString() ?? "NA";
        _customWeatherModel.rainIntensity = finalModel.rainIntensity?.toString() ?? "NA";
        _customWeatherModel.rainAccumulation = finalModel.rainAccumulation?.toString() ?? "NA";
        print('custom weather data is ${_customWeatherModel.temperature}');
        notifyListeners();
      }
    } else {
      _isApiFailure = true;
      notifyListeners();
    }
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

      _subLocality = placemarks.reversed.last.subLocality ?? "SubLocality Not Found";
      notifyListeners();

      return address;
    } catch (e) {
      print("Error getting placemarks: $e");
      return "No Address found";
    }
  }


  bool checkForApiFailure() {
    var finalModel = _customWeatherModel.temperature ?? "NA";
    if(finalModel.isEmpty || finalModel == "NA") {
      return true;
    } else {
      return false;
    }
  }

}