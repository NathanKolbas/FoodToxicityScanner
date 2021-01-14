part of api;

class Auth {
  static const NOT_AUTHORIZED = 1;
  static const EXPIRED_TOKEN = 2;
  static const INVALID_TOKEN = 3;
  static const MISSING_TOKEN = 4;
  static const INVALID_CREDENTIALS = 5;

  static Future<String> getToken(String email, String password) async {
    Map<String, String> params = {
      "email": email,
      "password": password
    };

    final response = await http.post(_url + "authenticate", body: params);

    final body = jsonDecode(response.body);
    if (response.statusCode == ok) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // Need to handle when the response is []
      return body['auth_token'];
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw ApiException(body);
    }
  }

  // Handling tokens, stored encrypted
  static Future<String> get getUserToken async {
    final storage = new FlutterSecureStorage();
    return await storage.read(key: 'userToken');
  }

  static void setUserToken(String token) {
    final storage = new FlutterSecureStorage();
    storage.write(key: 'userToken', value: token);
  }

  static void deleteUserToken() async {
    final storage = new FlutterSecureStorage();
    storage.delete(key: 'userToken');
  }
}

class AuthException implements Exception {
  final cause;
  AuthException(this.cause);
}
