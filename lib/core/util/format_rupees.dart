import 'package:intl/intl.dart';

String formatRupees(double amount) {
  //final format = NumberFormat.currency(locale: 'hi_IN', symbol: '₹');
  final format = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
  return format.format(amount);
}
