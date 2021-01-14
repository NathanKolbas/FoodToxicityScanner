part of api;

class User {
  static Future<String> _getUserJsonStringByToken(String token) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": token,
    };

    final response = await http.get(_url + "users", headers: headers);

    if (response.statusCode == ok) {
      return response.body;
    } else {
      throw ApiException(jsonDecode(response.body));
    }
  }

  static Future<String> _getUserJsonStringById(int id) async {
    final response = await http.get(_url + "users/$id");

    if (response.statusCode == ok) {
      return response.body;
    } else {
      throw ApiException(jsonDecode(response.body));
    }
  }

  static Future<Model.User> getUser({int id, String token}) async {
    ApiException('No id or token provided to get user');

    Model.User user;
    if (id != null) {
      final String userJson = await _getUserJsonStringById(id);
      user = Model.userFromJson(userJson);
    } else {
      final String userJson = await _getUserJsonStringByToken(token);
      user = Model.userFromJson(userJson);
      user.setToken = token;
    }

    return user;
  }

  static Future<Model.User> signIn(String email, String password) async {
    final String token = await Auth.getToken(email, password);
    final Model.User user = await getUser(token: token);

    return user;
  }

  static Future<Model.User> signUp(String name, String email, String password) async {
    String body = jsonEncode({
      "user": {
        "name": name,
        "email": email,
        "password": password,
      }
    });

    // http package doesn't like to use a map in a map so use this approach
    final response = await http.post(
        _url + "users",
        headers: {"Content-Type": "application/json"},
        body: body
    );

    if (response.statusCode == ok) {
      final Model.User user = Model.userFromJson(response.body);
      final String token = await Auth.getToken(email, password);
      user.setToken = token;

      return user;
    } else {
      throw ApiException(jsonDecode(response.body));
    }
  }

  /// Sends an HTTP PUT request to update a user.
  ///
  /// If the user is successfully update then true will be returned. Otherwise,
  /// an [ApiException] will be thrown.
  static Future<bool> updateUser(int id, String token, {String name, String email, String password, bool admin}) async {
    Map userJson = {
      "user": {
        "name": name,
        "email": email,
        "password": password,
        "admin": admin
      }
    };
    userJson["user"].removeWhere((key, value) => value == null);

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": token
    };
    headers.removeWhere((key, value) => value == null);

    // http package doesn't like to use a map in a map so use this approach
    final response = await http.put(
        _url + "users/$id",
        headers: headers,
        body: jsonEncode(userJson)
    );

    if (response.statusCode == ok) {
      return true;
    } else if (response.statusCode == unauthorized) {
      throw AuthException(jsonDecode(response.body));
    } else {
      throw ApiException(jsonDecode(response.body));
    }
  }
}
