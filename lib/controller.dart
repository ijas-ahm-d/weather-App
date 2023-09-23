import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:kalibre/utils/constants.dart' as k;

class HomeController extends GetxController {
  var isLoaded = false.obs; // Define it as an observable
  num? temp;
  num? press;
  num? hum;
  num? cover;
  var cityname = ''.obs; // Define it as an observable
  TextEditingController controller = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
  }

  getCurrentLocation() async {
    var p = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
      forceAndroidLocationManager: true,
    );

    // ignore: unnecessary_null_comparison
    if (p != null) {
      getCurrentCityWeather(p);
    } else {
      log('Data unavailable');
    }
  }

  getCityWeather(String cityname) async {
    var client = http.Client();

    var uri = '${k.domain}q=$cityname&appid=${k.apiKey}';
    var url = Uri.parse(uri);
    var response = await client.get(url);
    if (response.statusCode == 200) {
      var data = response.body;
      var decodeData = json.decode(data);
      updateUI(decodeData);
      isLoaded.value = true; // Use .value to update observable
    } else {
      log(response.statusCode.toString());
    }
  }

  getCurrentCityWeather(Position position) async {
    var client = http.Client();
    var uri =
        '${k.domain}lat=${position.latitude}&lon=${position.longitude}&appid=${k.apiKey}';
    var url = Uri.parse(uri);
    var response = await client.get(url);
    if (response.statusCode == 200) {
      var data = response.body;
      var decodeData = json.decode(data);
      updateUI(decodeData);
      isLoaded.value = true; // Use .value to update observable
    } else {
      log(response.statusCode.toString());
    }
  }

  updateUI(var decodedData) {
    if (decodedData == null) {
      temp = 0;
      press = 0;
      hum = 0;
      cover = 0;
      cityname.value = 'Not available'; // Use .value to update observable
    } else {
      temp = decodedData['main']['temp'] - 273;
      press = decodedData['main']['pressure'];
      hum = decodedData['main']['humidity'];
      cover = decodedData['clouds']['all'];
      cityname.value = decodedData['name']; // Use .value to update observable
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
