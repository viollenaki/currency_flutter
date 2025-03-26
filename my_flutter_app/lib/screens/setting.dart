import 'package:flutter/material.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

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
            _buildButton(context, 'ВАЛЮТЫ', Colors.white, Colors.black),
            const SizedBox(height: 15),
            _buildButton(context, 'ПОЛЬЗОВАТЕЛИ', Colors.white, Colors.black),
            const SizedBox(height: 15),
            _buildButton(context, 'ОЧИСТИТЬ БАЗУ ДАННЫХ', Colors.white, Colors.black),
            const SizedBox(height: 15),
            _buildButton(context, '', Colors.grey[400]!, Colors.black),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildButton(BuildContext context, String text, Color bgColor, Color textColor) {
    return SizedBox(
      width: 250,
      height: 45,
      child: ElevatedButton(
        onPressed: text.isNotEmpty ? () {} : null,
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

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: 3,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.black,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.compare_arrows), label: 'Продажа/покупка'),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: 'История'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Статистика'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Настройки'),
      ],
    );
  }
}
