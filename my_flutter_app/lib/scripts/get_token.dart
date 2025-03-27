import 'dart:convert';
import 'package:http/http.dart' as http;

// Global variable to store the access token
String? accessToken;

Future<Map<String, dynamic>?> getToken(String username, String password) async {
  const String url = "http://192.168.158.129:8000/api/token/";

  try {
    final response = await http.post(
      Uri.parse(url),
      body: {
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      accessToken = responseData['token'];
      print('Authentication successful: $responseData');
      return responseData; // Return the full response data
    } else {
      print('Failed to authenticate. Status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error occurred during authentication: $e');
    return null;
  }
}
