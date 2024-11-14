import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import 'package:intl/intl.dart';

class BMIPage extends StatefulWidget {
  const BMIPage({super.key});

  @override
  _BMIPageState createState() => _BMIPageState();
}

class _BMIPageState extends State<BMIPage> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final StorageService _storageService = StorageService();
  double _bmi = 0;
  List<Map<String, dynamic>> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final history = await _storageService.getBMIHistory();
    setState(() {
      _history = history;
    });
  }

  String _getBMICategory(double bmi) {
    if (bmi < 18.5) return 'Kurus';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Gemuk';
    return 'Obesitas';
  }

  Color _getBMICategoryColor(double bmi) {
    if (bmi < 18.5) return Colors.blue;
    if (bmi < 25) return Colors.green;
    if (bmi < 30) return Colors.orange;
    return Colors.red;
  }

  void _calculateBMI() async {
    if (_heightController.text.isEmpty || _weightController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon isi tinggi dan berat badan')),
      );
      return;
    }

    double height = double.parse(_heightController.text) / 100;
    double weight = double.parse(_weightController.text);
    double bmi = weight / (height * height);

    await _storageService.saveBMIResult(bmi, DateTime.now());
    await _loadHistory();

    setState(() {
      _bmi = bmi;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Tinggi (cm)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Berat (kg)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateBMI,
              child: const Text('Hitung BMI'),
            ),
            const SizedBox(height: 20),
            if (_bmi > 0) ...[
              Text(
                'BMI: ${_bmi.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 24),
              ),
              Text(
                'Kategori: ${_getBMICategory(_bmi)}',
                style: TextStyle(
                  fontSize: 20,
                  color: _getBMICategoryColor(_bmi),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
            const SizedBox(height: 20),
            const Text(
              'Riwayat BMI:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _history.length,
                itemBuilder: (context, index) {
                  final item = _history[index];
                  final bmi = item['bmi'] as double;
                  final date = DateTime.parse(item['date']);
                  return ListTile(
                    title: Text(
                      'BMI: ${bmi.toStringAsFixed(2)} - ${_getBMICategory(bmi)}',
                      style: TextStyle(
                        color: _getBMICategoryColor(bmi),
                      ),
                    ),
                    subtitle: Text(
                      DateFormat('dd/MM/yyyy HH:mm').format(date),
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
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }
}