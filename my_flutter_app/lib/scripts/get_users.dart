import 'dart:convert';
import 'package:http/http.dart' as http;
import 'globals.dart';

Future<List<Map<String, dynamic>>> fetchUsers() async {
  const String url = '${baseUrl}api/users/';
  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Token $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> results = json.decode(response.body);
      return results.map((e) => e as Map<String, dynamic>).toList();
    } else {
      print('Failed to fetch users. Status code: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('Error occurred while fetching users: $e');
    return [];
  }
}

Future<bool> deleteUser(String userId) async {
  final String url = '${baseUrl}api/users/$userId/';
  try {
    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Authorization': 'Token $accessToken',
      },
    );

    if (response.statusCode == 204) {
      return true;
    } else {
      print('Failed to delete user. Status code: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('Error occurred while deleting user: $e');
    return false;
  }
}
