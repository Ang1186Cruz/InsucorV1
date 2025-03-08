import 'dart:async';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_shop_app/models/http_exception.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  String? _rolId;
  Timer? _authTimer;
  String? _operation;
  String _idRuta = '';
  bool splash = true;

  bool get IsDplash {
    return splash;
  }

  bool get isAuth {
    return token != '';
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token ?? '';
    }
    return '';
  }

  String get userId {
    return _userId ?? '';
  }

  String get rolId {
    return _rolId ?? '';
  }

  String get IdRuta {
    return _idRuta;
  }

  String get operation {
    return _operation ?? '';
  }

  void changeSplash() {
    splash = false;
  }

  void setOperacion(String valor) {
    _operation = valor;
  }

  void setIdRuta(String idRuta) {
    _idRuta = idRuta;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = "https://distribuidorainsucor.com/APP_Api/api/login.php";
    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({'email': email, 'password': password}));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _rolId = responseData['rolId'];
      _userId = responseData['localId'];

      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'rolId': _rolId,
        'expiryDate': _expiryDate?.toIso8601String()
      });
      setOperacion('pedido');
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData') ?? '') as Map<String, Object>;

    final expiryDate = extractedUserData['expiryDate'] is String
        ? DateTime.parse(extractedUserData['expiryDate'] as String)
        : throw ArgumentError('expiryDate is not a valid string');

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = extractedUserData['token'] as String;
    _userId = extractedUserData['userId'] as String;
    _rolId = extractedUserData['rolId'] as String;
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  void logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer?.cancel();
      _authTimer = null;
    }
    setOperacion('');
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    _autoLogout();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer?.cancel();
    }
    final timeToExpiry = _expiryDate?.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry ?? 0), logout);
  }
}
