import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:food_toxicity_scanner/controllers/api/api.dart' as Api;
import 'package:food_toxicity_scanner/models/user.dart';

List<Ingredient> ingredientsFromJson(String str) => List<Ingredient>.from(json.decode(str).map((x) => Ingredient.fromJson(x)));

String ingredientsToJson(List<Ingredient> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Ingredient {
  Ingredient({
    this.id,
    this.name,
    this.description,
    this.safetyRating,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String name;
  String description;
  String safetyRating;
  int createdBy;
  DateTime createdAt;
  DateTime updatedAt;

  factory Ingredient.fromJson(Map<String, dynamic> json) => Ingredient(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    description: json["description"] == null ? null : json["description"],
    safetyRating: json["safety_rating"] == null ? null : json["safety_rating"],
    createdBy: json["created_by"] == null ? null : json["created_by"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "description": description == null ? null : description,
    "safety_rating": safetyRating == null ? null : safetyRating,
    "created_by": createdBy == null ? null : createdBy,
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
  };

  static const Map<String, int> safetyRatingEnum = {
    'unavailable': 0,
    'safe': 1,
    'caution': 2,
    'cut': 3,
    'cpsa': 4,
    'avoid': 5,
  };

  static const List<String> safetyRatingPicture = [
    'assets/images/na.png',
    'assets/images/safe.png',
    'assets/images/caution.png',
    'assets/images/cut.png',
    'assets/images/cpsa.png',
    'assets/images/avoid.png',
  ];

  int get safetyToInt => safetyRatingEnum[this.safetyRating];

  Widget get safetyToImage => Image.asset(safetyRatingPicture[safetyToInt], scale: 3.5,);

  Future<User> get getCreatedByUser async => await Api.User.getUser(id: createdBy);
}
