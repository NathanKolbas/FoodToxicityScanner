import 'dart:convert';

import 'package:food_toxicity_scanner/controllers/api/api.dart' as Api;
import 'package:food_toxicity_scanner/models/ingredient.dart';

// Reverse so the newest update is first
List<IngredientLog> ingredientLogFromJson(String str) => List<IngredientLog>.from(json.decode(str).map((x) => IngredientLog.fromJson(x))).reversed.toList();

String ingredientLogToJson(List<IngredientLog> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class IngredientLog extends Ingredient {
  IngredientLog({
    this.id,
    this.ingredientId,
    this.userId,
    this.name,
    this.description,
    this.safetyRating,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  int ingredientId;
  int userId;
  String name;
  String description;
  String safetyRating;
  DateTime createdAt;
  DateTime updatedAt;

  factory IngredientLog.fromJson(Map<String, dynamic> json) => IngredientLog(
    id: json["id"] == null ? null : json["id"],
    ingredientId: json["ingredient_id"] == null ? null : json["ingredient_id"],
    userId: json["user_id"] == null ? null : json["user_id"],
    name: json["name"] == null ? null : json["name"],
    description: json["description"] == null ? null : json["description"],
    safetyRating: json["safety_rating"] == null ? null : json["safety_rating"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "ingredient_id": ingredientId == null ? null : ingredientId,
    "user_id": userId == null ? null : userId,
    "name": name == null ? null : name,
    "description": description == null ? null : description,
    "safety_rating": safetyRating == null ? null : safetyRating,
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
  };

  Future<Ingredient> get getIngredient => Api.Ingredient.getIngredient(ingredientId);

  Future<Ingredient> get asIngredient => Api.Ingredient.getIngredient(ingredientId).then((value) {
    return new Ingredient(
      id: ingredientId,
      name: name,
      description: description,
      safetyRating: safetyRating,
      createdBy: value.createdBy,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  });
}