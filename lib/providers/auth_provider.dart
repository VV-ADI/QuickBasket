import 'package:flutter/foundation.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String _phoneNumber = '';
  String _name = '';
  String _email = '';

  bool get isLoggedIn => _isLoggedIn;
  String get phoneNumber => _phoneNumber;
  String get name => _name;
  String get email => _email;

  void setUserDetails({
    required String name,
    required String email,
    required String phone,
  }) {
    _name = name;
    _email = email;
    _phoneNumber = phone;
  }

  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _phoneNumber = '';
    _name = '';
    _email = '';
    notifyListeners();
  }
}
