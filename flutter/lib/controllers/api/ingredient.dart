part of api;

class Ingredient {
  static Future<List<Model.Ingredient>> scan(String scanData) async {
    final response = await http.get(_url + "scan?scan_data=$scanData");

    if (response.statusCode == ok) {
      return Model.ingredientsFromJson(response.body);
    } else {
      throw ApiException(jsonDecode(response.body));
    }
  }

  static Future<List<Model.Ingredient>> getIngredients() async {
    final response = await http.get(_url + "ingredients");

    if (response.statusCode == ok) {
      return Model.ingredientsFromJson(response.body);
    } else {
      throw ApiException(jsonDecode(response.body));
    }
  }

  static Future<Model.Ingredient> getIngredient(int id) async {
    final response = await http.get("${_url}ingredients/$id");

    if (response.statusCode == ok) {
      return Model.Ingredient.fromJson(jsonDecode(response.body));
    } else {
      throw ApiException(jsonDecode(response.body));
    }
  }

  static Future<Model.Ingredient> createIngredient(Model.Ingredient ingredient, String token) async {
    String body = jsonEncode({
      "ingredient": ingredient.toJson(),
    });

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": token
    };
    headers.removeWhere((key, value) => value == null);

    final response = await http.post(
      _url + "ingredients",
      headers: headers,
      body: body,
    );

    if (response.statusCode == ok) {
      return Model.Ingredient.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == unauthorized) {
      throw AuthException(jsonDecode(response.body));
    } else {
      throw ApiException(jsonDecode(response.body));
    }
  }

  static Future<bool> updateIngredient(Model.Ingredient ingredient, String token) async {
    Map body = {
      "ingredient": ingredient.toJson(),
    };
    body["ingredient"].removeWhere((key, value) => value == null);

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": token
    };
    headers.removeWhere((key, value) => value == null);

    final response = await http.put(
      _url + "ingredients/${ingredient.id}",
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == ok) {
      return true;
    } else if (response.statusCode == unauthorized) {
      throw AuthException(jsonDecode(response.body));
    } else {
      throw ApiException(jsonDecode(response.body));
    }
  }

  static Future<List<IngredientLog>> getIngredientLog(int ingredientId) async {
    final response = await http.get(_url + "ingredients/$ingredientId/log",);

    if (response.statusCode == ok) {
      return ingredientLogFromJson(response.body);
    } else {
      throw ApiException(jsonDecode(response.body));
    }
  }
}
