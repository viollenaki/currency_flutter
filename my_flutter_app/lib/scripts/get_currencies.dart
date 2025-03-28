import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'get_token.dart'; // Import the file that provides authentication token

// Make it public for access from other files
HashMap<int, String> currencies = HashMap<int, String>();

Future<void> getCurrencies() async {
  const String url = 'http://192.168.158.129:8000/api/currencies/';
  try {
    // Get the authentication token
    final Map<String, dynamic>? tokenResponse = await getToken('qwe', 'qwe'); // Pass required credentials

    if (tokenResponse == null || !tokenResponse.containsKey('token')) {
      print('Failed to get authentication token');
      return;
    }

    final String token = tokenResponse['token'];

    // Make the API request with the authorization header
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> results = json.decode(response.body)['results'];
      // Store the currencies from the results array
      currencies.clear(); // Clear existing data
      for (var entry in results) {
        currencies[entry['id']] = entry['code'];
      }
    } else {
      print('Failed to get currencies. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (e) {
    print('Error occurred while getting currencies: $e');
  }
}

// Helper function to get currency codes as strings
List<String> getCurrencyCodes() {
  // If currencies is empty, return a default list
  if (currencies.isEmpty) {
    return ['KGS', 'USD', 'EUR', 'RUB'];
  }

  // Extract currency codes from the API response
  return currencies.values.toList();
}
