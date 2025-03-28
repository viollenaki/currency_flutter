import 'package:flutter/material.dart';
import 'package:EXCHANGER/scripts/get_history.dart';
import 'package:intl/intl.dart'; // Import intl package

class HistoryView extends StatefulWidget {
  const HistoryView({Key? key}) : super(key: key);

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  late Future<List<Map<String, dynamic>>> _historyFuture;
  String _filterOption = 'Newest'; // Default filter option

  @override
  void initState() {
    super.initState();
    _historyFuture = fetchHistory(); // Fetch history data
  }

  Future<List<Map<String, dynamic>>> _getFilteredHistory() async {
    final history = await fetchHistory();
    if (_filterOption == 'Newest') {
      history.sort((a, b) => b['date'].compareTo(a['date'])); // Sort by newest
    } else {
      history.sort((a, b) => a['date'].compareTo(b['date'])); // Sort by oldest
    }
    return history;
  }

  void _showCurrencyModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        final TextEditingController _currencyController =
            TextEditingController();
        final List<String> currencies = [
          'USD',
          'EUR',
          'KGS'
        ]; // Example currencies

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
                      return ListTile(
                        title: Text(currencies[index]),
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
                      currencies.add(newCurrency); // Add the new currency
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F0E8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'История операций',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Фильтр:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  value: _filterOption,
                  items: const [
                    DropdownMenuItem(
                      value: 'Newest',
                      child: Text('Сначала новые'),
                    ),
                    DropdownMenuItem(
                      value: 'Oldest',
                      child: Text('Сначала старые'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _filterOption = value!;
                      _historyFuture = _getFilteredHistory(); // Update the data
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _historyFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Ошибка загрузки данных'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('Нет данных для отображения'));
                }

                final history = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    final item = history[index];
                    return _buildHistoryCard(item);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> item) {
    // Split the date string by 'T' to separate date and time
    final String rawDate = item['date'];
    final List<String> dateTimeParts = rawDate.split('T');
    final String datePart = dateTimeParts[0]; // Extract the date (yyyy-mm-dd)
    final String timePart =
        dateTimeParts[1].split('.')[0]; // Extract the time (hh:mm:ss)

    // Reformat the date and time
    final List<String> dateComponents = datePart.split('-');
    final String formattedDate =
        '${dateComponents[2]}-${dateComponents[1]}-${dateComponents[0]}'; // Convert to dd-mm-yyyy
    final String formattedTime = timePart.substring(0, 5); // Extract hh:mm

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Операция: ${item['operation_type']}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text('Сумма: ${item['amount']}'),
            Text('Курс: ${item['exchange_rate']}'),
            Text('Дата: $formattedDate   Время: $formattedTime'),
            if (item['description'] != null && item['description'].isNotEmpty)
              Text('Описание: ${item['description']}'),
          ],
        ),
      ),
    );
  }
}
