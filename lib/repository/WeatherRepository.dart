import 'package:weatherzomato/model/WeatherModel.dart';
import 'package:weatherzomato/services/ApiServices.dart';

class WeatherRepository {
  final ApiService apiService;

  WeatherRepository(this.apiService);

  Future<WeatherModel> getDataForWeather(String longitude, String latitude) {
    return apiService.callWeatherApi(longitude, latitude);
  }
}