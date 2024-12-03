import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _cedula = '';


  String get cedula => _cedula;


  void setUserData(String cedula, String email) {
    _cedula = cedula;

    notifyListeners();
  }
}
