import 'package:EXCHANGER/scripts/get_currencies.dart';
import 'package:EXCHANGER/scripts/globals.dart';
import 'package:flutter/material.dart';
import 'package:EXCHANGER/screens/home.dart';
import 'package:EXCHANGER/scripts/get_token.dart';
import 'package:EXCHANGER/screens/main_container.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _exchangeRateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;
  String? _operationType;
  String? _selectedCurrency;
  String? accessToken;
  String? user_id;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _amountController.dispose();
    _exchangeRateController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _login() async {
    // Get username and password from controllers
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    // Validate input
    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter username and password')),
      );
      return;
    }

    // Set loading state
    setState(() {
      _isLoading = true;
    });

    try {
      // Attempt to get token with provided credentials
      final response = await getToken(username, password);

      if (response != null && response.containsKey('token')) {
        accessToken = response['token']?.toString();
        user_id =
            response['user_id']?.toString(); // Ensure user_id is retrieved

        if (accessToken != null &&
            accessToken!.isNotEmpty &&
            user_id != null &&
            user_id!.isNotEmpty) {
          // Navigate to main container screen
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const MainContainer(initialIndex: 0),
            ),
          );
        } else {
          _showErrorSnackBar('Invalid token or user ID');
        }
      } else {
        _showErrorSnackBar('Authentication failed');
      }
    } catch (e) {
      _showErrorSnackBar('An error occurred: $e');
    } finally {
      // Reset loading state
      setState(() {
        _isLoading = false;
      });
    }
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

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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
      _selectedCurrency = currencies.isNotEmpty ? currencies[1] : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F0E8),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(
                controller: _usernameController,
                hint: 'Имя пользователя',
              ),
              const SizedBox(height: 10),
              _buildTextField(
                controller: _passwordController,
                hint: 'Пароль',
                isPassword: true,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Войти',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
