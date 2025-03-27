import 'package:flutter/material.dart';
import 'events.dart';
import 'package:EXCHANGER/screens/add_currensy.dart';
import 'package:EXCHANGER/scripts/get_currencies.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String? _selectedCurrency = 'KGS';
  List<String> _currencyList = ['KGS'];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCurrencies();
  }

  Future<void> _loadCurrencies() async {
    setState(() {
      _isLoading = true;
    });

    await getCurrencies();

    setState(() {
      _currencyList = getCurrencyCodes();
      // If selected currency is not in the list, set it to the first item
      if (!_currencyList.contains(_selectedCurrency) &&
          _currencyList.isNotEmpty) {
        _selectedCurrency = _currencyList[0];
      }
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F0E8),
      body: SafeArea(
        child: Center(
          child:
              _isLoading
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
                              _buildCircleAction(
                                Icons.arrow_downward,
                                'ПОКУПКА',
                                Colors.green,
                              ),
                              _buildCircleAction(
                                Icons.arrow_upward,
                                'ПРОДАЖА',
                                Colors.red,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _buildDropdownField(_selectedCurrency, _currencyList),
                          const SizedBox(height: 10),
                          _buildInputField('Количество'),
                          const SizedBox(height: 10),
                          _buildInputField('Курс валюты'),
                          const SizedBox(height: 10),
                          _buildInputField('Общий'),
                          const SizedBox(height: 20),
                          _buildKeypad(),
                          const SizedBox(height: 20),
                          _buildActionButton('Добавить событие'),
                          const SizedBox(height: 10),
                          _buildActionButton('События'),
                        ],
                      ),
                    ),
                  ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildCircleAction(IconData icon, String label, Color color) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: color,
          radius: 30,
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
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
        items:
            items.map((currency) {
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

  Widget _buildInputField(String hint) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildKeypadButton(String text, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: SizedBox(
        width: 70,
        height: 40,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.grey[400],
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

  Widget _buildKeypad() {
    final keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['0', '00', '000'],
      ['⌫', '', '↩'],
    ];
    return Column(
      children:
          keys.map((row) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  row.map((key) {
                    return key.isEmpty
                        ? const SizedBox(width: 70, height: 40)
                        : _buildKeypadButton(
                          key,
                          color: key == '⌫' || key == '↩' ? Colors.grey : null,
                        );
                  }).toList(),
            );
          }).toList(),
    );
  }

  Widget _buildActionButton(String text) {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        onPressed: () {
          if (text == 'Добавить событие') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddCurrencyView()),
            );
          } else if (text == 'События') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EventsView()),
            );
          }
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
