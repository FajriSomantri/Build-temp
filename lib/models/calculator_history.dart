class CalculatorHistory {
  final double number1;
  final double number2;
  final String operation;
  final double result;
  final DateTime timestamp;

  CalculatorHistory({
    required this.number1,
    required this.number2,
    required this.operation,
    required this.result,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'number1': number1,
      'number2': number2,
      'operation': operation,
      'result': result,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory CalculatorHistory.fromJson(Map<String, dynamic> json) {
    return CalculatorHistory(
      number1: json['number1'],
      number2: json['number2'],
      operation: json['operation'],
      result: json['result'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}