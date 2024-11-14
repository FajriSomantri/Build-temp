import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/calculator_history.dart';

class StorageService {
  static const String calculatorHistoryKey = 'calculator_history';
  static const String bmiHistoryKey = 'bmi_history';

  Future<void> saveCalculatorHistory(List<CalculatorHistory> history) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final historyJson = history.map((h) => h.toJson()).toList();
    await prefs.setString(calculatorHistoryKey, jsonEncode(historyJson));
  }

  Future<List<CalculatorHistory>> getCalculatorHistory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString(calculatorHistoryKey);
    if (historyJson == null) return [];

    final List<dynamic> decodedJson = jsonDecode(historyJson);
    return decodedJson
        .map((item) => CalculatorHistory.fromJson(item))
        .toList();
  }

  Future<void> saveBMIResult(double bmi, DateTime date) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final history = await getBMIHistory();
    history.add({'bmi': bmi, 'date': date.toIso8601String()});
    await prefs.setString(bmiHistoryKey, jsonEncode(history));
  }

  Future<List<Map<String, dynamic>>> getBMIHistory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString(bmiHistoryKey);
    if (historyJson == null) return [];

    return List<Map<String, dynamic>>.from(jsonDecode(historyJson));
  }
}