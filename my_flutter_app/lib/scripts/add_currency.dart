import 'dart:convert';
import 'package:http/http.dart' as http;
import 'globals.dart';

Future<bool> addCurrency(String currencyCode) async {
  const String url =
      '${baseUrl}api/currencies/'; // API endpoint for adding a currency

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Token $accessToken', // Use the global access token
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'code': currencyCode}),
    );

    if (response.statusCode == 201) {
      // Successfully added the currency
      return true;
    } else {
      // Handle error response
      print('Error: ${response.statusCode}, ${response.body}');
      return false;
    }
  } catch (e) {
    // Handle exceptions
    print('Exception: $e');
    return false;
  }
}
