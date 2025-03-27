import 'package:flutter/material.dart';
import 'package:EXCHANGER/screens/home.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:EXCHANGER/screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ru', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Flutter App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LoginView(), // Set LoginView as the initial screen
    );
  }
}
