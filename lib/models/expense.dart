import 'package:intl/intl.dart';

class Expense {
  final String id;
  final String title;
  final double amount;
  final DateTime dateTime;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.dateTime,
  });

  /// Format the amount as currency
  String get formattedAmount {
    return '₹${amount.toStringAsFixed(2)}';
  }

  /// Format the date and time
  String get formattedDateTime {
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }

  /// Get just the date
  String get formattedDate {
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }
}
