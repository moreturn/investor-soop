
import 'package:intl/intl.dart';

extension StringExtension on String {
  String setComma() {
    final formatter = NumberFormat("#,###");
    return formatter.format(int.parse(this));
  }
}
extension IntExtension on int {
  String setComma() {
    final formatter = NumberFormat("#,###");
    return formatter.format(this);
  }
}
