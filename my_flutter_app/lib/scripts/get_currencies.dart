import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'globals.dart'; // Import the file that provides the base URL

// Make it public for access from other files
HashMap<int, String> currencies = HashMap<int, String>();

Future<void> getCurrencies() async {
  const String url = '${baseUrl}api/currencies/';
  try {
    // Get the authentication token

    // Make the API request with the authorization header
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Token $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> results = json.decode(response.body);
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
