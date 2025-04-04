import 'package:flutter/material.dart';
import 'package:EXCHANGER/scripts/globals.dart';
import 'package:http/http.dart' as http;
import 'package:EXCHANGER/screens/currency_modal.dart';
import 'package:EXCHANGER/screens/users_page.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F0E8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Настройки',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Button for "ВАЛЮТА"
            _buildButton(
              context,
              'ВАЛЮТА',
              Colors.white,
              Colors.black,
              () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CurrencyPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 15),

            // Button for "ПОЛЬЗОВАТЕЛИ"
            _buildButton(
              context,
              'ПОЛЬЗОВАТЕЛИ',
              Colors.white,
              Colors.black,
              () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const UsersPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 15),

            // Conditionally show the "DELETE DB" button for non-staff users
            if (isStuff == true) // Check if the user is not staff
              _buildButton(
                context,
                'ОЧИСТИТЬ БАЗУ ДАННЫХ',
                Colors.white,
                Colors.black,
                () => _showDeleteDialog(context),
              ),
          ],
        ),
      ),
    );
  }

  // Show delete confirmation dialog
  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Предупреждение"),
          content: const Text("Данные будут удалены навсегда!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Отмена"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 240, 239),
              ),
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                await _resetDatabase(
                    context); // Call the reset database function
              },
              child: const Text("Удалить"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _resetDatabase(BuildContext context) async {
    const String url =
        '${baseUrl}api/reset-database/'; // API endpoint for resetting the database

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Token $accessToken', // Use the global access token
        },
      );

      if (response.statusCode == 200) {
        // Show success message with response data
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('База данных успешно очищена: ${response.body}')),
        );
      } else {
        // Show error message with response data
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Ошибка: ${response.statusCode}, ${response.body}')),
        );
      }
    } catch (e) {
      // Show exception message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при очистке базы данных: $e')),
      );
    }
  }

  // Create a button with the given text and action
  Widget _buildButton(
    BuildContext context,
    String text,
    Color bgColor,
    Color textColor,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: 250,
      height: 45,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: const BorderSide(color: Colors.black),
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
