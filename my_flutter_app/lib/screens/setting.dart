import 'package:flutter/material.dart';
import 'package:EXCHANGER/scripts/get_currencies.dart';
import 'package:EXCHANGER/scripts/globals.dart';
import 'package:http/http.dart' as http;

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
              () => _showCurrencyModal(context),
            ),
            const SizedBox(height: 15),

            // Button for "ПОЛЬЗОВАТЕЛИ"
            _buildButton(
              context,
              'ПОЛЬЗОВАТЕЛИ',
              Colors.white,
              Colors.black,
              () => _showUsersPage(context),
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

  // Show modal page for "ВАЛЮТА"
  void _showCurrencyModal(BuildContext context) async {
    // Fetch currencies from the API
    await getCurrencies();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        final TextEditingController _currencyController =
            TextEditingController();

        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height *
                0.5, // Set modal height to 50% of screen height
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Валюты',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: currencies.length,
                    itemBuilder: (context, index) {
                      final currencyCode = currencies.values.toList()[index];
                      return ListTile(
                        title: Text(currencyCode),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _currencyController,
                  decoration: InputDecoration(
                    labelText: 'Добавить валюту',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    final newCurrency = _currencyController.text.trim();
                    if (newCurrency.isNotEmpty) {
                      // Add the new currency to the currencies map
                      currencies[currencies.length + 1] = newCurrency;
                      Navigator.of(context).pop(); // Close the modal
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Валюта $newCurrency добавлена')),
                      );
                    }
                  },
                  child: const Text('Добавить'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Show empty page for "ПОЛЬЗОВАТЕЛИ"
  void _showUsersPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Пользователи'),
            centerTitle: true,
          ),
          body: const Center(
            child: Text('Страница пользователей пока пуста'),
          ),
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
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('База данных успешно очищена')),
        );
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: ${response.body}')),
        );
      }
    } catch (e) {
      // Show error message
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
