import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_toxicity_scanner/screens/sign_in/sign_in_screen.dart';
import 'package:food_toxicity_scanner/controllers/api/api.dart' as Api;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User extends ChangeNotifier {
  User({
    this.id,
    this.name,
    this.email,
    this.admin,
    this.createdAt,
    this.updatedAt,
    this.token,
  });

  int id;
  String name;
  String email;
  bool admin;
  DateTime createdAt;
  DateTime updatedAt;
  String token; // For the future, have getters and setters so this can automatically update. Somehow keep this private.

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    email: json["email"] == null ? null : json["email"],
    admin: json["admin"] == null ? null : json["admin"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "email": email == null ? null : email,
    "admin": admin == null ? null : admin,
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
  };

  void updateFromJson(String userJsonString) {
    Map<String, dynamic> decodedJson = json.decode(userJsonString);

    id = decodedJson["id"] == null ? null : decodedJson["id"];
    name = decodedJson["name"] == null ? null : decodedJson["name"];
    email = decodedJson["email"] == null ? null : decodedJson["email"];
    admin = decodedJson["admin"] == null ? null : decodedJson["admin"];
    createdAt = decodedJson["created_at"] == null ? null : DateTime.parse(decodedJson["created_at"]);
    updatedAt = decodedJson["updated_at"] == null ? null : DateTime.parse(decodedJson["updated_at"]);

    // Update the UI
    notifyListeners();
  }

  set setToken(String token) {
    this.token = token;
    // Also update the encrypted storage.
    Api.Auth.setUserToken(token);
    notifyListeners();
  }

  void updateFromUser(User user) {
    id = user.id;
    name = user.name;
    email = user.email;
    admin = user.admin;
    createdAt = user.createdAt;
    updatedAt = user.updatedAt;
    token = user.token;

    // Update the UI
    notifyListeners();
  }

  bool loggedInCheck(BuildContext context) {
    if (token == null) {
      Navigator.pushNamed(context, SignInScreen.routeName);
      return false;
    }

    return true;
  }

  static Future<User> getSignedIn() async {
    // If it is the first time opening the app
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('showSplashScreen') ?? true) return new User();

    String userToken;
    try {
      userToken = await Api.Auth.getUserToken;
    } catch(e) {
      print(e);
    }
    if (userToken == null) return new User();

    try {
      return Api.User.getUser(token: userToken);
    } catch(e) {
      // This NEEDS to be cleaned up. Basically, if it fails for whatever reason have them sign in.
      return new User();
    }
  }

  void signOut(BuildContext context) {
    Provider.of<User>(context, listen: false).updateFromUser(new User());
    Api.Auth.deleteUserToken();
    notifyListeners();
  }
}
