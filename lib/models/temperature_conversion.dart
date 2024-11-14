import 'package:flutter/material.dart';

class TemperaturePage extends StatefulWidget {
  const TemperaturePage({super.key});

  @override
  _TemperaturePageState createState() => _TemperaturePageState();
}

class _TemperaturePageState extends State<TemperaturePage> {
  double inputValue = 0;
  String fromUnit = 'Celsius';
  String toUnit = 'Fahrenheit';
  double result = 0;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  final List<String> units = ['Celsius', 'Fahrenheit', 'Kelvin'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konversi Suhu'),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[200]!, Colors.blue[50]!],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Masukkan Nilai',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.thermostat),
                    ),
                    onChanged: (value) {
                      setState(() {
                        inputValue = double.tryParse(value) ?? 0;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Dari:'),
                            DropdownButton<String>(
                              isExpanded: true,
                              value: fromUnit,
                              items: units.map((String unit) {
                                return DropdownMenuItem(
                                  value: unit,
                                  child: Text(unit),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  fromUnit = newValue!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Ke:'),
                            DropdownButton<String>(
                              isExpanded: true,
                              value: toUnit,
                              items: units.map((String unit) {
                                return DropdownMenuItem(
                                  value: unit,
                                  child: Text(unit),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  toUnit = newValue!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.calculate),
                    label: const Text('Konversi'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        result = convertTemperature();
                        showResultSnackbar();
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Card(
                    color: Colors.blue[100],
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Text(
                            'Hasil Konversi:',
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            '${result.toStringAsFixed(2)} $toUnit',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.calendar_today),
                        label: const Text('Pilih Tanggal'),
                        onPressed: () => _selectDate(context),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.access_time),
                        label: const Text('Pilih Waktu'),
                        onPressed: () => _selectTime(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Tanggal: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Waktu: ${selectedTime.format(context)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  double convertTemperature() {
    if (fromUnit == toUnit) return inputValue;

    if (fromUnit == 'Celsius' && toUnit == 'Fahrenheit') {
      return (inputValue * 9/5) + 32;
    } else if (fromUnit == 'Celsius' && toUnit == 'Kelvin') {
      return inputValue + 273.15;
    } else if (fromUnit == 'Fahrenheit' && toUnit == 'Celsius') {
      return (inputValue - 32) * 5/9;
    } else if (fromUnit == 'Fahrenheit' && toUnit == 'Kelvin') {
      return (inputValue - 32) * 5/9 + 273.15;
    } else if (fromUnit == 'Kelvin' && toUnit == 'Celsius') {
      return inputValue - 273.15;
    } else if (fromUnit == 'Kelvin' && toUnit == 'Fahrenheit') {
      return (inputValue - 273.15) * 9/5 + 32;
    }
    return 0;
  }

  void showResultSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Konversi berhasil: $inputValue $fromUnit = ${result.toStringAsFixed(2)} $toUnit'
        ),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {},
        ),
      ),
    );
  }
}