import 'package:intl/intl.dart';

String formatCents(int cents, {String currency = 'USD'}) {
  final f = NumberFormat.currency(symbol: currency == 'USD' ? '\$' : '$currency ');
  return f.format(cents / 100.0);
}
