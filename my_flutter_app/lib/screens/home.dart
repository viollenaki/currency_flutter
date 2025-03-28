import 'dart:collection';
import 'dart:convert';
import 'package:EXCHANGER/scripts/get_token.dart';
import 'package:http/http.dart' as http;

import 'package:EXCHANGER/screens/history.dart';
import 'package:EXCHANGER/screens/setting.dart';
import 'package:EXCHANGER/screens/statictics.dart';
import 'package:flutter/material.dart';
import 'package:EXCHANGER/scripts/get_currencies.dart';
import 'package:EXCHANGER/scripts/globals.dart';
import 'package:flutter/services.dart';

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
      if (!_currencyList.contains(_selectedCurrency) &&
          _currencyList.isNotEmpty) {
        _selectedCurrency = _currencyList[0];
      }
      _isLoading = false;
    });
  }

  Future<void> _addEvent() async {
    const String url = '${baseUrl}api/operations/';
    if (accessToken == null || user_id == null) {
      _showSnackBar(
          'Error: Token or user ID is missing. Please authenticate first.');
      return;
    }

    // Validate input fields
    if (_operationType == null) {
      _showSnackBar('Error: Please choose an operation type (BUY or SELL).');
      return;
    }
    if (_amountController.text.isEmpty ||
        _exchangeRateController.text.isEmpty ||
        _descriptionController.text.isEmpty) {
      _showSnackBar('Error: Please fill in all the fields.');
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
      _showSnackBar('Error: Invalid currency selected.');
      return;
    }

    final Map<String, dynamic> data = {
      "amount": double.tryParse(_amountController.text) ?? 0,
      "exchange_rate": double.tryParse(_exchangeRateController.text) ?? 0,
      "operation_type": _operationType,
      "description": _descriptionController.text,
      "user": int.parse(user_id!),
      "currency": selectedCurrencyId,
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
        _showSnackBar('Success: Operation added successfully.');
        _clearInputs(); // Clear all input fields
      } else {
        _showSnackBar(
            'Error: Failed to add operation. Status code: ${response.statusCode}');
      }
    } catch (e) {
      _showSnackBar('Error: An error occurred while adding the operation: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _clearInputs() {
    setState(() {
      _amountController.clear();
      _exchangeRateController.clear();
      _descriptionController.clear();
      _operationType = null;
      _selectedCurrency = _currencyList.isNotEmpty ? _currencyList[0] : null;
    });
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
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
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
                        _buildTextField(
                            _exchangeRateController, 'Exchange Rate'),
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
          ? TextInputType.numberWithOptions(
              decimal: true) // Show numeric keyboard with decimal
          : TextInputType.text,
      inputFormatters: label == 'Amount' || label == 'Exchange Rate'
          ? [
              FilteringTextInputFormatter.allow(
                  RegExp(r'^\d*\.?\d*')), // Allow digits and a single dot
            ]
          : null,
    );
  }

  Widget _buildActionButton(String text) {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        onPressed: _operationType == null
            ? null
            : () {
                _addEvent();
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: _operationType == null ? Colors.grey : Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(text, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
