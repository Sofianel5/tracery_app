import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:tracery_app/api/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:tracery_app/models/user_model.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class UserRepository with ChangeNotifier {
  Status _status = Status.Unauthenticated;
  User _user;

  Status get status => _status;
  User get user => _user;

  UserRepository() {
    print("calling constructor");
    _getUser();
  }

  Future<bool> signIn({
    @required String email,
    @required String password,
  }) async {
    _status = Status.Authenticating;
    notifyListeners();
    try {
      Map data = {
        "email": email,
        "password": password,
      };
      var jsonData;
      var response = await http.post(Urls.LOGIN_URL, body: data);
      SharedPreferences sharedPrefrences = await SharedPreferences.getInstance();
      if (response.statusCode == 200) {
        jsonData = json.decode(response.body);
        sharedPrefrences.setString("token", jsonData["auth_token"]);
        _getUser();
        print("in sign up, _user is " + (_user == null ? "null" : _user.toString()));
        _status = Status.Authenticated;
        notifyListeners();
        return true;
      }
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }
  Future<bool> resetPassword({
    @required String email
  }) async {
    try {
      var token = await _getToken();
      Map data = {
        "email": email,
      };
      var response = await http.get(Urls.PASSWORD_RESET_URL + "?email="+email, headers: {"Authorization": "Token " + token});
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response);
      } else {
        print(response);
      }
      return true;
    } catch (e) {
      print(e);
      print("Error on sending");
      return false;
    }
  }
  Future<Map> signUp({
    @required String email,
    @required String password,
    @required String firstName,
    @required String lastName,
  }) async {
    _status = Status.Authenticating;
    notifyListeners();
    try {
      Map data = {
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "password": password,
      };
      var jsonData;
      var response = await http.post(Urls.SIGNUP_URL, body: data);
      if (response.statusCode == 201) {
        print(response);
        jsonData = json.decode(response.body);
        bool validity = await signIn(email: jsonData["email"], password: password);
        print(validity);
        print(_status);
        return {"validity": validity};
      } else {
        jsonData = json.decode(response.body);
        if (jsonData["password"] != null) {
          return {"validity": false, "response": jsonData, "message": "Please provide valid entries to all fields. Note your password must not be too short or common."};
        }
        if (jsonData["email"] != null && jsonData["email"].contains("account with this Email already exists.")) {
          return {"validity": false, "response": jsonData, "message": "Please provide valid entries to all fields. Note this email is already associated with an account."};
        }
        return {"validity": false, "response": jsonData, "message": "Please provide valid entries to all fields."};
      }
    } catch(e) {
      print(e);
      return {"validity": false, "message": "Error connecting to server."};
    }
  }
  Future<String> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    if (token == null) {
      _user = null;
      _status = Status.Unauthenticated;
      notifyListeners();
      return null; 
    } else {
      return token;
    }
  }
  
  Future _getUser() async {
    print("getting user, currently " + (_user == null ? "null" : _user.toString()));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? "";
    http.Response response;
    try {
     response = await http.get(Urls.USER_URL, 
      headers: {"Authorization": "Token " +token, 'Accept': "application/json"}
    );
    } catch(e) {
      print("connc error " + e.toString());
      return;
    }
    print(response);
    var responseJson;
    if (response.statusCode == 200) {
      _status = Status.Authenticated;
      notifyListeners();
      responseJson = json.decode(response.body);
      this._user = User.fromJson(responseJson);
      print("set this._user to " + this._user.toString());
    }
  }

  Future signOut() async {
    deleteToken();
    _user = null;
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }
  Future<bool> toggleLockState() async {
    print("toggling lock");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? "";
    var response = await http.post(Urls.TOGGLE_LOCK_STATE, 
      headers: {"Authorization": "Token " +token, 'Accept': "application/json"},
    );
    if (response.statusCode == 200) {
      _user.isLocked = !_user.isLocked;
      notifyListeners();
      return true;
    }
    return false;
  }
  Future<bool> checkForScan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? "";
    var response = await http.post(Urls.CHECK_FOR_VENUE_SCAN, 
      headers: {"Authorization": "Token " +token, 'Accept': "application/json"},
    );
    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      return responseJson["success"];
    }
    return false;
  }
  Future<void> _onAuthStateChanged(User user) async {
    if (user == null) {
      _status = Status.Unauthenticated;
    } else {
      _user = user;
      _status = Status.Authenticated;
    }
    notifyListeners();
  }

  Future<void> deleteToken() async {
    final pref = await SharedPreferences.getInstance();
    await pref.clear();
  }

}
