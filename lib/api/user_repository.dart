import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:tracery_app/api/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:tracery_app/models/anon_user_model.dart';
import 'package:tracery_app/models/thread_from_person_model.dart';
import 'package:tracery_app/models/thread_from_venue_model.dart';
import 'dart:async';

import 'package:tracery_app/models/user_model.dart';
import 'package:tracery_app/models/venue_model.dart';
import 'package:tracery_app/models/vp_handshake_model.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class UserRepository with ChangeNotifier {
  Status _status = Status.Uninitialized;
  User _user;
  Venue _venue;
  ThreadFromVenue currentThread;
  ThreadFromPerson currentThreadFromPerson;
  Venue get venue => _venue;
  Status get status => _status;
  User get user => _user;

  UserRepository() {
    print("calling constructor");
    _getUser();
    notifyListeners();
  }
  Map<String, String> getHeaders(SharedPreferences sharedPrefrences) {
    if (_user.isPrivate) {
      String public_id = sharedPrefrences.getString("public_id") ?? "";
      String passtoken = sharedPrefrences.getString("passtoken") ?? "";
      print(public_id);
      print(passtoken);
      return {"ANONAUTH_ID": public_id, 'ANONAUTH_PASSTOKEN': passtoken};
    } else {
      String token = sharedPrefrences.getString("token") ?? "";
      return {"Authorization": "Token " + token};
    }
  }

  Future<bool> openAnonymousAccount() async {
    _status = Status.Authenticating;
    notifyListeners();
    var jsonData;
    var response = await http.post(Urls.ANON_SIGNUP);
    SharedPreferences sharedPrefrences = await SharedPreferences.getInstance();
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      sharedPrefrences.setString("passtoken", jsonData["passtoken"]);
      sharedPrefrences.setString("public_id", jsonData["public_id"]);
      sharedPrefrences.setString("is_private", true.toString());
      AnonUser privateUser = AnonUser.fromJson(jsonData);
      _user = User();
      _user.anonUser = privateUser;
      _user.isPrivate = true;
      _user.isGovAgent = false;
      _user.isVenueAdmin = false;
      _status = Status.Authenticated;
      notifyListeners();
      return true;
    }
  }

  Future<List<Venue>> getVenues() async {
    var response = await http.get(Urls.GET_VENUES);
    var responseJson;
    print(response.body);
    if (response.statusCode == 200) {
      // Set _user.programs
      responseJson = json.decode(response.body);
      print(responseJson);
      List<Venue> venues = [];
      for (var venue in responseJson) {
        print(Venue.fromJson(venue));
        venues.add(Venue.fromJson(venue));
      }
      return venues;
    }
    return List<Venue>();
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
      SharedPreferences sharedPrefrences =
          await SharedPreferences.getInstance();
      if (response.statusCode == 200) {
        jsonData = json.decode(response.body);
        sharedPrefrences.setString("token", jsonData["auth_token"]);
        sharedPrefrences.setString("is_private", false.toString());
        _getUser();
        _status = Status.Authenticated;
        notifyListeners();
        return true;
      }
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    } catch (e) {
      print(e);
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<bool> resetPassword({@required String email}) async {
    try {
      var token = await _getToken();
      Map data = {
        "email": email,
      };
      var response = await http.get(Urls.PASSWORD_RESET_URL + "?email=" + email,
          headers: {"Authorization": "Token " + token});
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.body);
      } else {
        print(response.body);
      }
      return true;
    } catch (e) {
      print(e);
      print("Error on sending");
      return false;
    }
  }

  Future<Map> signUp({@required Map<String, dynamic> jsonData}) async {
    _status = Status.Authenticating;
    notifyListeners();
    try {
      print(jsonData);
      var response = await http.post(Urls.SIGNUP_URL, body: jsonData);
      print(response.statusCode);
      if (response.statusCode == 201) {
        Map responseJsonData = json.decode(response.body);
        print(jsonData);
        bool validity = await signIn(
            email: responseJsonData["email"], password: jsonData['password']);
        print(validity);
        print(_status);
        return {"validity": validity};
      } else {
        jsonData = json.decode(response.body);
        print(jsonData);
        _status = Status.Unauthenticated;
        if (jsonData["password"] != null) {
          return {
            "validity": false,
            "response": jsonData,
            "message":
                "Please provide valid entries to all fields. Note your password must not be too short or common."
          };
        }
        if (jsonData["email"] != null &&
            jsonData["email"]
                .contains("account with this Email already exists.")) {
          return {
            "validity": false,
            "response": jsonData,
            "message":
                "Please provide valid entries to all fields. Note this email is already associated with an account."
          };
        }
        return {
          "validity": false,
          "response": jsonData,
          "message": "Please provide valid entries to all fields."
        };
      }
    } catch (e) {
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

  Future _getAuthUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? "";
    http.Response response;
    try {
      response = await http.get(Urls.USER_URL, headers: {
        "Authorization": "Token " + token,
        'Accept': "application/json"
      });
    } catch (e) {
      _getUser();
      print("connc error " + e.toString());
      return;
    }
    var responseJson;
    if (response.statusCode == 200) {
      responseJson = json.decode(response.body);
      this._user = User.fromJson(responseJson);
      prefs.setString("is_private", false.toString());
      _user.isPrivate = false;
      _status = Status.Authenticated;
      notifyListeners();
      if (_user.isVenueAdmin) {
        _getVenue();
      }
    } else {
      print(json.decode(response.body));
      print("unauth");
      _status = Status.Unauthenticated;
    }
  }

  Future _getAnonUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String public_id = prefs.getString("public_id") ?? "";
    String passtoken = prefs.getString("passtoken") ?? "";
    print(public_id);
    print(passtoken);
    http.Response response;
    try {
      response = await http.get(Urls.GET_ANON_USER,
          headers: {"ANONAUTH_ID": public_id, 'ANONAUTH_PASSTOKEN': passtoken});
    } catch (e) {
      print("connc error " + e.toString());
      _getUser();
      return;
    }
    if (response.statusCode == 200) {
      print(response.body);
      Map<String, dynamic> responseJson = json.decode(response.body);
      prefs.setString("passtoken", responseJson["passtoken"]);
      prefs.setString("public_id", responseJson["public_id"]);
      prefs.setString("is_private", true.toString());
      if (this._user == null) {
        this._user = User();
      }
      this._user.anonUser = AnonUser.fromJson(responseJson);
      _status = Status.Authenticated;
      _user.isPrivate = true;
      _user.isGovAgent = false;
      _user.isVenueAdmin = false;
      notifyListeners();
    } else {
      print(json.decode(response.body));
      print("unauth");
      _status = Status.Unauthenticated;
      notifyListeners();
    }
  }

  Future _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String isPrivate = prefs.getString("is_private");
    if (isPrivate == "true") {
      print("private");
      _getAnonUser();
    } else if (isPrivate == "false") {
      print("not private");
      _getAuthUser();
    } else {
      print("no prefs");
      print(isPrivate);
      _status = Status.Unauthenticated;
      notifyListeners();
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
    Map<String, String> headers = getHeaders(prefs);
    print(headers);
    var response = await http.post(
      Urls.TOGGLE_LOCK_STATE,
      headers: headers,
    );
    print(response.body);
    if (response.statusCode == 200) {
      _user.anonUser.isLocked = !_user.anonUser.isLocked;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> confirmThreadAsVenue(String threadId, bool sentBySelf) async {
    print("Confirming thread as venue");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response response;
    try {
      response = await http.post(
        Urls.VENUE_CONFIRM_ENTRY,
        headers: getHeaders(prefs),
        body: {'thread': threadId, 'sent_by_self': sentBySelf.toString()},
      );
    } catch (e) {
      print(e);
      return false;
    }
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> confirmThreadAsUser(String threadId, bool sentBySelf) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response response;
    try {
      response = await http.post(Urls.USER_CONFIRM_ENTRY,
          headers: getHeaders(prefs),
          body: {'thread': threadId, 'sent_by_self': sentBySelf.toString()});
    } catch (e) {
      print(e);
      return false;
    }
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<Map<String, dynamic>> checkForScan() async {
    print("checking for venue scan");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response response;
    try {
      response = await http.post(
        Urls.CHECK_FOR_VENUE_SCAN,
        headers: getHeaders(prefs),
      );
    } catch (e) {
      return {"success": false, "Thread": null, "message-id": "network-error"};
    }
    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      print(responseJson);
      if (!responseJson["success"]) {
        // User is locked
        return {"success": false, "Thread": null, "message-id": "locked-error"};
      } else {
        currentThread = ThreadFromVenue.fromJson(responseJson);
        return {"success": true, "Thread": currentThread};
      }
    }
    return {"success": false, "Thread": null, "message-id": "unknown-error"};
  }

  Future<Map<String, dynamic>> checkForPersonScan() async {
    print("checking for person scan");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response response;
    try {
      response = await http.post(
        Urls.CHECK_FOR_PERSON_SCAN,
        headers: getHeaders(prefs),
      );
    } catch (e) {
      return {"success": false, "Thread": null, "message-id": "network-error"};
    }
    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      print(responseJson);
      if (!responseJson["success"]) {
        // User is locked
        return {"success": false, "Thread": null, "message-id": "locked-error"};
      } else {
        currentThreadFromPerson = ThreadFromPerson.fromJson(responseJson);
        return {"success": true, "Thread": currentThread};
      }
    }
    return {"success": false, "Thread": null, "message-id": "unknown-error"};
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

  Future<List<VenuePeerHandshake>> getPVHandshakes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response response;
    try {
      if (_user.isVenueAdmin) {
        response =
          await http.get(Urls.GET_PV_HANDSHAKES_AS_VENUE, headers: getHeaders(prefs));
      } else {
        response =
          await http.get(Urls.GET_PV_HANDSHAKES, headers: getHeaders(prefs));
      }
    } catch (e) {
      print("connc error " + e.toString());
      return null;
    }
    print(response.body);
    var responseJson;
    if (response.statusCode == 200) {
      responseJson = json.decode(response.body);
      List<VenuePeerHandshake> res = [];
      for (var item in responseJson) {
        res.add(VenuePeerHandshake.fromJson(item));
      }
      return res;
    }
  }

  Future<ThreadFromPerson> scanVenue(String puid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response response;
    try {
      response = await http.post(Urls.SCAN_VENUE,
          headers: getHeaders(prefs), body: {"puid": puid});
    } catch (e) {
      print("connc error " + e.toString());
      return null;
    }
    var responseJson;
    print(response.body);
    if (response.statusCode == 200) {
      responseJson = json.decode(response.body);
      ThreadFromPerson res = ThreadFromPerson.fromJson(responseJson);
      return res;
    }
    return null;
  }

  _getVenue() async {
    print("getting main venue");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response response;
    try {
      response = await http.get(Urls.GET_VENUE, headers: getHeaders(prefs));
    } catch (e) {
      print("connc error " + e.toString());
      return null;
    }
    var responseJson;
    print(response.body);
    if (response.statusCode == 200) {
      responseJson = json.decode(response.body);
      _venue = Venue.fromJson(responseJson);
      return;
    }
    _getVenue();
  }

  Future<ThreadFromVenue> scanPerson(String puid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response response;
    try {
      response = await http.post(Urls.SCAN_PERSON,
          headers: getHeaders(prefs), body: {"puid": puid});
    } catch (e) {
      print("connc error " + e.toString());
      return null;
    }
    var responseJson;
    print(response.body);
    if (response.statusCode == 200) {
      responseJson = json.decode(response.body);
      ThreadFromVenue res = ThreadFromVenue.fromJson(responseJson);
      return res;
    }
    return null;
  }

  Future<void> deleteToken() async {
    final pref = await SharedPreferences.getInstance();
    await pref.clear();
  }
}
