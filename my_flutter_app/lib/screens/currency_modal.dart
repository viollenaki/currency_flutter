import 'package:flutter/material.dart';
import 'package:EXCHANGER/scripts/add_currency.dart';
import 'package:EXCHANGER/scripts/get_currencies.dart';

class CurrencyPage extends StatefulWidget {
  const CurrencyPage({Key? key}) : super(key: key);

  @override
  State<CurrencyPage> createState() => _CurrencyPageState();
}

class _CurrencyPageState extends State<CurrencyPage> {
  final TextEditingController _currencyController = TextEditingController();
  List<String> _currencies = []; // List to store currency codes

  @override
  void initState() {
    super.initState();
    _loadCurrencies(); // Load currencies when the page is initialized
  }

  Future<void> _loadCurrencies() async {
    await getCurrencies(); // Fetch currencies from the API
    setState(() {
      _currencies = getCurrencyCodes(); // Get currency codes from the HashMap
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Валюты',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop(); // Go back to the previous page
          },
        ),
      ),
      backgroundColor: const Color(0xFFF9F0E8),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: _currencies.isEmpty
                  ? const Center(
                      child:
                          CircularProgressIndicator()) // Show a loader while fetching data
                  : ListView.builder(
                      itemCount: _currencies.length,
                      itemBuilder: (context, index) {
                        final currencyCode = _currencies[index];
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
                labelText: 'Новая валюта',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final currencyCode = _currencyController.text.trim();
                if (currencyCode.isNotEmpty) {
                  final success = await addCurrency(currencyCode);
                  if (success) {
                    await _loadCurrencies(); // Reload currencies after adding a new one
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Валюта успешно добавлена')),
                    );
                    _currencyController.clear(); // Clear the input field
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Ошибка при добавлении валюты')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Введите код валюты')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Добавить валюту'),
            ),
          ],
        ),
      ),
    );
  }
}
