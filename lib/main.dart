import 'package:flutter/material.dart';
import 'models/currency_conversion.dart';
import 'models/temperature_conversion.dart';
import 'screens/calculator_page.dart';
import 'screens/bmi_page.dart';
import 'screens/temperature_page.dart';
import 'screens/currency_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multi Calculator App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  
  final List<Widget> _pages = [
    const CalculatorPage(),
    const BMIPage(),
    const TemperaturePage(),
    const CurrencyPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Kalkulator',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monitor_weight),
            label: 'BMI',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.thermostat),
            label: 'Suhu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            label: 'Mata Uang',
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}