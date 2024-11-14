import 'package:flutter/material.dart';
import '../models/calculator_history.dart';
import '../services/storage_service.dart';
import 'package:intl/intl.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final TextEditingController _num1Controller = TextEditingController();
  final TextEditingController _num2Controller = TextEditingController();
  final StorageService _storageService = StorageService();
  double _result = 0;
  List<CalculatorHistory> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final history = await _storageService.getCalculatorHistory();
    setState(() {
      _history = history;
    });
  }

  void _calculate(String operation) async {
    if (_num1Controller.text.isEmpty || _num2Controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon isi kedua angka')),
      );
      return;
    }

    final num1 = double.parse(_num1Controller.text);
    final num2 = double.parse(_num2Controller.text);
    double result;

    switch (operation) {
      case '+':
        result = num1 + num2;
        break;
      case '-':
        result = num1 - num2;
        break;
      case '*':
        result = num1 * num2;
        break;
      case '/':
        if (num2 == 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tidak bisa membagi dengan nol')),
          );
          return;
        }
        result = num1 / num2;
        break;
      default:
        return;
    }

    final history = CalculatorHistory(
      number1: num1,
      number2: num2,
      operation: operation,
      result: result,
      timestamp: DateTime.now(),
    );

    _history.insert(0, history);
    if (_history.length > 10) _history.removeLast(); // Batasi 10 riwayat

    await _storageService.saveCalculatorHistory(_history);

    setState(() {
      _result = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _num1Controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Angka Pertama',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _num2Controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Angka Kedua',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _calculate('+'),
                  child: const Text('+'),
                ),
                ElevatedButton(
                  onPressed: () => _calculate('-'),
                  child: const Text('-'),
                ),
                ElevatedButton(
                  onPressed: () => _calculate('*'),
                  child: const Text('×'),
                ),
                ElevatedButton(
                  onPressed: () => _calculate('/'),
                  child: const Text('÷'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Hasil: ${_result.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            const Text(
              'Riwayat Perhitungan:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _history.length,
                itemBuilder: (context, index) {
                  final item = _history[index];
                  return ListTile(
                    title: Text(
                      '${item.number1} ${item.operation} ${item.number2} = ${item.result.toStringAsFixed(2)}',
                    ),
                    subtitle: Text(
                      DateFormat('dd/MM/yyyy HH:mm').format(item.timestamp),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _num1Controller.dispose();
    _num2Controller.dispose();
    super.dispose();
  }
}