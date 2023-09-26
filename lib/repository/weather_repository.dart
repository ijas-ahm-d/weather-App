import 'package:kalibre/data/network/http_api_service.dart';
import 'package:kalibre/data/network/network_api_service.dart';
import 'package:kalibre/model/temperature_model.dart';

class WeatherRepository {
  HttpApiServices apiServices = NetWorkApiServices();

  Future getTemperature({required String url}) async {
    try {
      final response = await apiServices.httpGetMethod(url: url);
      return temperaturesFromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
