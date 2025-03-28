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
          onPressed: () => Navigator.pop(context), // Возврат на предыдущий экран
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
            // Кнопка для валют
            _buildButton(context, 'ВАЛЮТЫ', Colors.white, Colors.black),
            const SizedBox(height: 15),

            // Кнопка для пользователей
            _buildButton(context, 'ПОЛЬЗОВАТЕЛИ', Colors.white, Colors.black),
            const SizedBox(height: 15),

            // Кнопка для очистки базы данных
            _buildButton(context, 'ОЧИСТИТЬ БАЗУ ДАННЫХ', Colors.white, Colors.black),
            const SizedBox(height: 15),

            // Пустая кнопка-заглушка
            _buildButton(context, '', Colors.grey[400]!, Colors.black),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(), // Нижняя панель навигации
    );
  }

  // Метод для отображения диалогового окна при очистке базы данных
  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Предупреждение"), // Заголовок диалога
          content: const Text("Выбранная информация будет удалена навсегда!"), // Основной текст предупреждения
          actions: [
            // Кнопка "Отмена" для закрытия диалога
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Закрыть диалог
              },
              child: const Text("Отмена"),
            ),

            // Кнопка "Удалить" для выполнения действия
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 255, 240, 239)), // Красная кнопка
              onPressed: () {
                // Логика удаления базы данных
                Navigator.of(context).pop(); // Закрыть диалог после нажатия
              },
              child: const Text("Удалить"),
            ),
          ],
        );
      },
    );
  }

  // Метод создания кнопки с заданным текстом и цветом
  Widget _buildButton(BuildContext context, String text, Color bgColor, Color textColor) {
    return SizedBox(
      width: 250,
      height: 45,
      child: ElevatedButton(
        // Проверка: если кнопка "ОЧИСТИТЬ БАЗУ ДАННЫХ" - показываем диалог
        onPressed: text == 'ОЧИСТИТЬ БАЗУ ДАННЫХ'
            ? () => _showDeleteDialog(context) // Показать предупреждение
            : () {}, // Для других кнопок ничего не делаем
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

  // Нижняя панель навигации
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
