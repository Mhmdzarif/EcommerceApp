import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get apiBase =>
      dotenv.env['API_BASE'] ?? 'http://10.0.2.2:5264';

  static int get taxRatePercent =>
      int.tryParse(dotenv.env['TAX_RATE_PERCENT'] ?? '0') ?? 0;
}
