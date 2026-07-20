import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class ConnectivityService {
  final Connectivity connectivity = Connectivity();

  Stream<List<ConnectivityResult>> get stream => connectivity.onConnectivityChanged;

  //Checking if the device is connected to Wi-Fi or mobile data
  Future<bool> hasConnection() async {
    final result = await connectivity.checkConnectivity();

    return !result.contains(ConnectivityResult.none);
  }

  //Checking if the device is connected to the vacation app server
  Future<bool> canReachServer() async {
    try {
      final response = await http.get(Uri.parse("https://vacation-xhxd.onrender.com/health")).timeout(const Duration(seconds: 15));

      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  //Checking whether both connections can be made
  Future<bool> isOnline() async {
    if(!await hasConnection()) {
      return false;
    }

    return await canReachServer();
  }
}