import 'package:flutter/material.dart';

class TokenProvider with ChangeNotifier {
  String _token = '';

  String get token => _token;

  void setToken(String newToken) {
    _token = newToken;
    notifyListeners(); // Notify all listeners that the token has changed
  }
  void clearToken() {
    _token = '';
    notifyListeners();
  }
}