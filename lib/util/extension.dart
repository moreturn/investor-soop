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

extension MapWithIndex<T, R> on List<T> {
  List<R> indexedMap<R>(
      R Function(T element, int index, List<T> array) callback) {
    List<R> result = [];
    for (int index = 0; index < length; index++) {
      result.add(callback(this[index], index, this));
    }
    return result;
  }

  Iterable<T> indexedWhere(bool Function(T element, int index) test) sync* {
    for (int index = 0; index < length; index++) {
      if (test(this[index], index)) {
        yield this[index];
      }
    }
  }

  T reduceWithSeed(T Function(T accumulator, T element) combine, T seed) {
    T result = seed;
    for (T element in this) {
      result = combine(result, element);
    }
    return result;
  }
}
