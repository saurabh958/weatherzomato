/// status : "200"
/// message : ""
/// device_type : 1
/// locality_weather_data : {"temperature":24.1,"humidity":70.73,"wind_speed":1.24,"wind_direction":119.8,"rain_intensity":0,"rain_accumulation":0}

class WeatherModel {
  WeatherModel({
      this.status, 
      this.message, 
      this.deviceType, 
      this.localityWeatherData,});

  WeatherModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    deviceType = json['device_type'];
    localityWeatherData = json['locality_weather_data'] != null ? LocalityWeatherData.fromJson(json['locality_weather_data']) : null;
  }
  String? status;
  String? message;
  int? deviceType;
  LocalityWeatherData? localityWeatherData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['device_type'] = deviceType;
    if (localityWeatherData != null) {
      map['locality_weather_data'] = localityWeatherData?.toJson();
    }
    return map;
  }

}

/// temperature : 24.1
/// humidity : 70.73
/// wind_speed : 1.24
/// wind_direction : 119.8
/// rain_intensity : 0
/// rain_accumulation : 0

class LocalityWeatherData {
  LocalityWeatherData({
      this.temperature, 
      this.humidity, 
      this.windSpeed, 
      this.windDirection, 
      this.rainIntensity, 
      this.rainAccumulation,});

  LocalityWeatherData.fromJson(dynamic json) {
    temperature = json['temperature'];
    humidity = json['humidity'];
    windSpeed = json['wind_speed'];
    windDirection = json['wind_direction'];
    rainIntensity = json['rain_intensity'];
    rainAccumulation = json['rain_accumulation'];
  }
  double? temperature;
  double? humidity;
  double? windSpeed;
  double? windDirection;
  int? rainIntensity;
  int? rainAccumulation;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['temperature'] = temperature;
    map['humidity'] = humidity;
    map['wind_speed'] = windSpeed;
    map['wind_direction'] = windDirection;
    map['rain_intensity'] = rainIntensity;
    map['rain_accumulation'] = rainAccumulation;
    return map;
  }

}