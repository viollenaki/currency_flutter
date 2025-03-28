import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:EXCHANGER/scripts/globals.dart' as globals;

Future<List<Map<String, dynamic>>> fetchHistory() async {
  final String url = '${globals.baseUrl}api/operations/';

  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Token ${globals.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> results = json.decode(response.body);
      return results.map((e) => e as Map<String, dynamic>).toList();
    } else {
      print('Failed to fetch history. Status code: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('Error occurred while fetching history: $e');
    return [];
  }
}
