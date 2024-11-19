import 'dart:convert';

import 'package:weatherzomato/model/WeatherModel.dart';
import 'package:http/http.dart' as http;
import '../util/Constant.dart';

class ApiService {


  Future<WeatherModel> callWeatherApi(String longitude, String latitude) async {
    final queryParameters = {
      'latitude': latitude,
      'longitude': longitude,
    };
    final uri = Uri.https(baseUrl, urlAddress, queryParameters);
    print('final uri is ${uri.toString()}');
    final response = await http.get(
      uri,
      headers: {"x-zomato-api-key": "42bdbb8d00e9e9168e4ec1e0bd1c4ac9"},
    ).timeout(const Duration(seconds: 60));
    print('response => ${response.statusCode} and body is ${response.body}');
    return WeatherModel.fromJson(jsonDecode(response.body));
  }

}
