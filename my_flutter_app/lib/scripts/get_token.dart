import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:EXCHANGER/scripts/globals.dart';

// Global variables to store the access token and user ID

Future<Map<String, dynamic>?> getToken(String username, String password) async {
  const String url = "${baseUrl}api/token/";

  try {
    final response = await http.post(
      Uri.parse(url),
      body: {
        'username': username, // Use the provided username
        'password': password, // Use the provided password
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      // Extract and save the access token and user ID
      accessToken = responseData['token'];
      isStuff = responseData['is_staff'] ?? false; // Ensure is_staff is a boolean
      user_id = responseData['user_id']?.toString(); // Ensure user_id is stored as a string

      print('Authentication successful: $responseData');
      return responseData; // Return the full response data
    } else {
      print('Failed to authenticate. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null;
    }
  } catch (e) {
    print('Error occurred during authentication: $e');
    return null;
  }
}
