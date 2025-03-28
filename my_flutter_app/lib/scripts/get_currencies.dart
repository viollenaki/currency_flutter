import 'dart:convert';
import 'package:http/http.dart' as http;
import 'get_token.dart'; // Import the file that provides authentication token

// Make it public for access from other files
List<dynamic> currencies = [];

Future<Map<String, dynamic>?> getCurrencies() async {
  const String url = 'http://192.168.51.116:8000/api/currencies/';
  try {
    // Get the authentication token
    final Map<String, dynamic>? tokenResponse = await getToken('qwe', 'qwe'); // Pass required credentials

    if (tokenResponse == null || !tokenResponse.containsKey('token')) {
      print('Failed to get authentication token');
      return null;
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
      final Map<String, dynamic> responseData = json.decode(response.body);
      // Store the currencies from the results array
      currencies = responseData['results'];
      print('Currencies received: $currencies');
      return responseData;
    } else {
      print('Failed to get currencies. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null;
    }
  } catch (e) {
    print('Error occurred while getting currencies: $e');
    return null;
  }
}

// Helper function to get currency codes as strings
List<String> getCurrencyCodes() {
  // If currencies is empty, return a default list
  if (currencies.isEmpty) {
    return ['KGS', 'USD', 'EUR', 'RUB'];
  }

  // Extract currency codes from the API response
  return currencies
      .map<String>((currency) => currency['code'] as String)
      .toList();
}
