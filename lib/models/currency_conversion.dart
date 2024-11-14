import 'package:flutter/material.dart';

class CurrencyPage extends StatefulWidget {
  const CurrencyPage({super.key});

  @override
  _CurrencyPageState createState() => _CurrencyPageState();
}

class _CurrencyPageState extends State<CurrencyPage> {
  double amount = 0;
  String fromCurrency = 'USD';
  String toCurrency = 'IDR';
  double result = 0;
  bool isDarkMode = false;

  final Map<String, double> exchangeRates = {
    'USD': 1.0,
    'IDR': 15500.0,
    'EUR': 0.85,
    'GBP': 0.73,
    'JPY': 110.0,
  };

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Konversi Mata Uang'),
          actions: [
            Switch(
              value: isDarkMode,
              onChanged: (value) {
                setState(() {
                  isDarkMode = value;
                });
              },
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDarkMode 
                ? [Colors.grey[800]!, Colors.grey[900]!]
                : [Colors.green[200]!, Colors.green[50]!],
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
                        labelText: 'Jumlah',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                      onChanged: (value) {
                        setState(() {
                          amount = double.tryParse(value) ?? 0;
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
                                value: fromCurrency,
                                items: exchangeRates.keys.map((String currency) {
                                  return DropdownMenuItem(
                                    value: currency,
                                    child: Text(currency),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    fromCurrency = newValue!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.swap_horiz),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Ke:'),
                              DropdownButton<String>(
                                isExpanded: true,
                                value: toCurrency,
                                items: exchangeRates.keys.map((String currency) {
                                  return DropdownMenuItem(
                                    value: currency,
                                    child: Text(currency),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    toCurrency = newValue!;
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
                      icon: const Icon(Icons.currency_exchange),
                      label: const Text('Konversi'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          result = convertCurrency();
                          showResultDialog();
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    Card(
                      color: isDarkMode ? Colors.grey[700] : Colors.green[100],
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const Text(
                              'Hasil Konversi:',
                              style: TextStyle(fontSize: 18),
                            ),
                            Text(
                              '${result.toStringAsFixed(2)} $toCurrency',
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
                    ExpansionTile(
                      title: const Text('Kurs Mata Uang'),
                      children: exchangeRates.entries.map((entry) {
                        return ListTile(
                          title: Text('1 USD = ${entry.value} ${entry.key}'),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Informasi Kurs',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text('Kurs yang ditampilkan adalah kurs indikatif'),
                    Text('Update terakhir: ${DateTime.now()}'),
                  ],
                ),
              ),
            );
          },
          child: const Icon(Icons.info),
        ),
      ),
    );
  }

  double convertCurrency() {
    double usdAmount = amount;
    if (fromCurrency != 'USD') {
      usdAmount = amount / exchangeRates[fromCurrency]!;
    }
    return usdAmount * exchangeRates[toCurrency]!;
  }

  void showResultDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hasil Konversi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('$amount $fromCurrency ='),
            Text(
              '${result.toStringAsFixed(2)} $toCurrency',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}