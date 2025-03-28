import 'dart:collection';
import 'dart:convert';
import 'package:EXCHANGER/scripts/get_token.dart';
import 'package:http/http.dart' as http;

import 'package:EXCHANGER/screens/history.dart';
import 'package:EXCHANGER/screens/setting.dart';
import 'package:EXCHANGER/screens/statictics.dart';
import 'package:flutter/material.dart';
import 'package:EXCHANGER/scripts/get_currencies.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

HashMap<String, dynamic> data = HashMap<String, dynamic>();

class _HomeViewState extends State<HomeView> {
  String? _selectedCurrency = 'KGS';
  List<String> _currencyList = ['KGS'];
  bool _isLoading = true;
  String? _operationType; // "BUY" or "SELL"
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _exchangeRateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCurrencies();
  }

  Future<void> _loadCurrencies() async {
    setState(() {
      _isLoading = true;
    });

    await getCurrencies(); // Fetch currencies from the API

    setState(() {
      _currencyList = getCurrencyCodes(); // Update the currency list
      if (!_currencyList.contains(_selectedCurrency) && _currencyList.isNotEmpty) {
        _selectedCurrency = _currencyList[0];
      }
      _isLoading = false;
    });
  }

  Future<void> _addEvent() async {
    const String url = 'http://192.168.158.129:8000/api/operations/';
    if (accessToken == null || user_id == null) {
      _showErrorSnackBar('Token or user ID is missing. Please authenticate first.');
      return;
    }

    // Get the selected currency ID
    int? selectedCurrencyId;
    currencies.forEach((id, code) {
      if (code == _selectedCurrency) {
        selectedCurrencyId = id;
      }
    });

    if (selectedCurrencyId == null) {
      _showErrorSnackBar('Invalid currency selected.');
      return;
    }

    final Map<String, dynamic> data = {
      "amount": double.tryParse(_amountController.text) ?? 0, // Get amount from input
      "exchange_rate": double.tryParse(_exchangeRateController.text) ?? 0, // Get exchange rate from input
      "operation_type": _operationType,
      "description": _descriptionController.text, // Get description from input
      "user": int.parse(user_id!), // Convert user_id to integer
      "currency": selectedCurrencyId, // Use the selected currency ID
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Token $accessToken',
          'Content-Type': 'application/json',
        },
        body: json.encode(data),
      );

      if (response.statusCode == 201) {
        _showSuccessSnackBar('Event added successfully');
      } else {
        _showErrorSnackBar('Failed to add event. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      _showErrorSnackBar('Error occurred while adding event: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _buildCircleAction(String type, String label, Color color) {
    final bool isSelected = _operationType == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          _operationType = type;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: isSelected ? 80 : 60,
        height: isSelected ? 80 : 60,
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.grey,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F0E8),
      body: SafeArea(
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator()
              : Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildCircleAction("BUY", "ПОКУПКА", Colors.green),
                            _buildCircleAction("SELL", "ПРОДАЖА", Colors.red),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildDropdownField(_selectedCurrency, _currencyList),
                        const SizedBox(height: 20),
                        _buildTextField(_amountController, 'Amount'),
                        const SizedBox(height: 20),
                        _buildTextField(_exchangeRateController, 'Exchange Rate'),
                        const SizedBox(height: 20),
                        _buildTextField(_descriptionController, 'Description'),
                        const SizedBox(height: 20),
                        _buildActionButton('ДОБАВИТЬ СОБЫТИЕ'),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildDropdownField(String? selectedValue, List<String> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: DropdownButton<String>(
        value: selectedValue,
        isExpanded: true,
        underline: const SizedBox(),
        items: items.map((currency) {
          return DropdownMenuItem(value: currency, child: Text(currency));
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedCurrency = value;
          });
        },
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      keyboardType: label == 'Amount' || label == 'Exchange Rate'
          ? TextInputType.number
          : TextInputType.text,
    );
  }

  Widget _buildActionButton(String text) {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        onPressed: () {
          if (_operationType == null) {
            print('Please select an operation type (BUY or SELL)');
            return;
          }
          _addEvent();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(text, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: 0,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.black,
      onTap: (index) {
        if (index == 1) { // Index for "История"
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HistoryView()),
          );
        } else if (index == 2) { // Index for "Статистика"
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const StaticticsView()),
          );
        } else if (index == 3) { // Index for "Настройки"
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsView()),
          );
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.compare_arrows),
          label: 'Продажа/покупка',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: 'История'),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          label: 'Статистика',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Настройки'),
      ],
    );
  }
}
