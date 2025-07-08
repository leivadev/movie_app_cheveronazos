import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  String _currentUser = '';
  final Map<String, String> _users = {}; 

  bool get isAuthenticated => _isAuthenticated;
  String get currentUser => _currentUser;

  bool register(String email, String password) {
    if (_users.containsKey(email)) {
      return false; 
    }

    _users[email] = password;
    return true;
  }


  bool login(String email, String password) {
    if (_users.containsKey(email) && _users[email] == password) {
      _isAuthenticated = true;
      _currentUser = email;
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _isAuthenticated = false;
    _currentUser = '';
    notifyListeners();
  }


  bool userExists(String email) {
    return _users.containsKey(email);
  }
}
