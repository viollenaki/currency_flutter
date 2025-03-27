import 'package:flutter/material.dart';

class AddCurrencyView extends StatefulWidget {
  const AddCurrencyView({Key? key}) : super(key: key);

  @override
  State<AddCurrencyView> createState() => _AddCurrencyViewState();
}

class _AddCurrencyViewState extends State<AddCurrencyView> {
  final TextEditingController _newCurrencyController = TextEditingController();
  String? _selectedCurrency;
  final List<String> _currencies = ['USD', 'EUR', 'RUB'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F0E8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
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
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDropdown(),
              const SizedBox(height: 10),
              _buildTextField('Новая валюты', _newCurrencyController),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    // Logic to add currency
                    Navigator.pop(context); // Return to HomeView
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Добавить валюту',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: DropdownButton<String>(
        value: _selectedCurrency,
        hint: const Text('Валюты'),
        isExpanded: true,
        underline: const SizedBox(),
        items: _currencies.map((currency) {
          return DropdownMenuItem(
            value: currency,
            child: Text(currency),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedCurrency = value;
          });
        },
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
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

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: 0,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.black,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.compare_arrows), label: 'Продажа/покупка'),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: 'История'),
        BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart), label: 'Статистика'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Настройки'),
      ],
    );
  }
}
