import 'package:flutter/material.dart';
import 'events.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // Dropdown value for currency
  String? _selectedCurrency = 'USD';
  
  // List of currencies
  final List<String> _currencies = ['USD', 'EUR', 'RUB'];

  Widget _buildNavItemWithRoute(IconData icon, String label) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, color: Colors.blue),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EventsView()),
            );
          },
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.blue, fontSize: 12),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: screenSize.width, // Tablet-friendly max width
              maxHeight: screenSize.height, // Tablet-friendly max height
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top section
                Column(
                  children: [
                    // Top buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildCircularButton(Icons.arrow_downward, 'Покупка', Colors.green),
                          const SizedBox(width: 20),
                          _buildCircularButton(Icons.arrow_upward, 'Продажа', Colors.red),
                        ],
                      ),
                    ),

                    // Dropdown and input fields
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          // Currency Dropdown
                          _buildDropdownField(_selectedCurrency, _currencies),
                          const SizedBox(height: 10),

                          // Quantity Input
                          _buildInputField('Количество'),
                          const SizedBox(height: 10),

                          // Rate Input
                          _buildInputField('Курс'),
                          const SizedBox(height: 10),

                          // Total Input
                          _buildInputField('Общий'),
                        ],
                      ),
                    ),
                  ],
                ),

                // Numeric Keypad
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // First three rows of digits
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: ['7', '8', '9'].map((digit) => _buildKeypadButton(digit)).toList(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: ['4', '5', '6'].map((digit) => _buildKeypadButton(digit)).toList(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: ['1', '2', '3'].map((digit) => _buildKeypadButton(digit)).toList(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildKeypadButton('0'),
                          _buildKeypadButton('00'),
                          _buildKeypadButton('000'),
                        ],
                      ),
                      // Control buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildKeypadButton('⌫', color: Colors.grey),
                          _buildKeypadButton('C', color: Colors.grey),
                          _buildKeypadButton('➜', color: Colors.grey),
                        ],
                      ),
                    ],
                  ),
                ),

                // Bottom Navigation
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildNavItem(Icons.compare_arrows, 'Продажа/покупка'),
                      const SizedBox(width: 40),
                      _buildNavItem(Icons.history, 'История'),
                      const SizedBox(width: 40),
                      _buildNavItem(Icons.bar_chart, 'Статистика'),
                      const SizedBox(width: 40),
                      _buildNavItemWithRoute(Icons.event, 'Events'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to create circular buttons
  Widget _buildCircularButton(IconData icon, String label, Color color) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 5),
        Text(label),
      ],
    );
  }

  // Helper method to create dropdown field
  Widget _buildDropdownField(String? selectedValue, List<String> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: DropdownButton<String>(
        value: selectedValue,
        items: items.map((String currency) {
          return DropdownMenuItem<String>(
            value: currency,
            child: Text(currency),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedCurrency = newValue;
          });
        },
        underline: Container(),
        isExpanded: true,
      ),
    );
  }

  // Helper method to create input fields
  Widget _buildInputField(String hint) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
        ),
      ),
    );
  }

  // Helper method to create keypad buttons
  Widget _buildKeypadButton(String text, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: SizedBox(
        width: 80,
        height: 40,
        child: ElevatedButton(
          onPressed: () {
            // Add button press logic here
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.white,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: color != null ? Colors.white : Colors.black,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to create bottom navigation items
  Widget _buildNavItem(IconData icon, String label) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, color: Colors.blue),
          onPressed: () {
            // Add navigation logic here
          },
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.blue, fontSize: 12),
        ),
      ],
    );
  }
}