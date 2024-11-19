import 'package:flutter/material.dart';

const String baseUrl = "www.weatherunion.com";
const String urlAddress = "/gw/weather/external/v0/get_weather_data/";
const String apiKey = "42bdbb8d00e9e9168e4ec1e0bd1c4ac9";

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