import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ConnectivityService extends ChangeNotifier {

  //Constructor
  ConnectivityService._privateConstructor();

  static final ConnectivityService instance = ConnectivityService._privateConstructor();

  bool isOnline = true;

  final Connectivity connectivity = Connectivity();

  Stream<List<ConnectivityResult>> get stream => connectivity.onConnectivityChanged;

  //Checking if the device is connected to Wi-Fi or mobile data
  Future<bool> hasConnection() async {
    final result = await connectivity.checkConnectivity();

    return !result.contains(ConnectivityResult.none);
  }

  //Checking if the device is connected to the vacation app server
  Future<bool> canReachServer() async {

    print("Checking server...");

    try {
      final response = await http.get(Uri.parse("https://vacation-xhxd.onrender.com/health")).timeout(const Duration(seconds: 15));

      print("Status: ${response.statusCode}");

      return response.statusCode == 200;

    } catch (error) {
      print("Server unreachable: $error");
      return false;
    }
  }

  //Checking whether both connections can be made
  Future<bool> checkConnection() async {

    print("Checking connection...");
    
    //Checking connections
    bool online = await hasConnection() && await canReachServer();

    if(online != isOnline) {
      isOnline = online;

      notifyListeners();
    }
    print("Online: $online");
    return online;
  }

   void connectionFailed() {

    if(isOnline) {

      isOnline = false;

      notifyListeners();

    }
  }


  void connectionRestored() {

    if(!isOnline) {

      isOnline = true;

      notifyListeners();

    }
  }
}