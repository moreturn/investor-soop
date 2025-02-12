String numberToKor(String arg,
    {bool isAll = true, String suffix = '', bool isNum = true}) {
  if (arg == '0') {
    return '0$suffix';
  }

  if (arg.length < 1) {
    return '';
  }

  try {
    String num = (int.parse(arg.replaceAll(',', '')) ~/ 1).toString();
    final korUnits = ['', '일', '이', '삼', '사', '오', '육', '칠', '팔', '구'];
    final numUnits = ['', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    final smallUnits = ['천', '백', '십', ''];
    final bigUnits = [
      '',
      '만',
      '억',
      '조',
      '경',
      '해',
      '자',
      '양',
      '구',
      '간',
      '정',
      '재',
      '극',
    ];
    int len = num.length;

    String changeUnit(String arg) {
      if (arg == '0000') {
        return '';
      }

      String ret = '';
      String toKor = '';
      for (int i = 0; i < arg.length; i++) {
        if (arg[i] == '0') {
          continue;
        } else {
          toKor = (arg[i] == '1' && i != 3) ? '' : korUnits[int.parse(arg[i])];
          ret += '$toKor${smallUnits[i]}';
        }
      }
      return ret;
    }

    if (len % 4 != 0) {
      num = num.padLeft(4 - (num.length % 4) + num.length, '0');
    }

    len = num.length;
    List<String> pairs = List.generate(
      len ~/ 4,
      (i) => num.substring(i * 4, (i + 1) * 4),
    );

    if (isNum) {
      String ret = '';
      for (int i = 1; i <= pairs.length; i++) {
        final n = (pairs[i - 1] == '0000') ? '' : int.parse(pairs[i - 1]);
        if (n == '' || n == null) {
          continue;
        }

        if (pairs.length - i > -1) {
          ret += '$n${bigUnits[pairs.length - i]}';
        } else {
          ret += n.toString();
        }
      }

      return ret + suffix;
    } else {
      String ret = '';
      for (int i = 0; i < pairs.length; i++) {
        final check = pairs.length - i - 2;
        String trans;
        if (isAll) {
          trans = changeUnit(pairs[i]);
        } else {
          trans = int.parse(pairs[i]).toString();
          if (trans == '0') {
            continue;
          }
        }
        ret += '$trans${check < 0 || trans == '0' ? '' : bigUnits[check]} ';
      }
      return (ret
              .replaceAll(RegExp(r'억 만', caseSensitive: false), '억')
              .replaceAll(RegExp(r'억만', caseSensitive: false), '억')
              .replaceAll(RegExp(r'조 억', caseSensitive: false), '조')
              .replaceAll(RegExp(r'조억', caseSensitive: false), '조')) +
          suffix;
    }
  } catch (e) {
    return arg;
  }
}

int calcWithholdingTax(double taxRate, double amount) {

  double nationalTax = double.parse((taxRate / 1.1 / 100).toStringAsFixed(2));
  print('n :${(amount * nationalTax).floor() / 10 * 10}');
  double localTax = double.parse((taxRate / 11 / 100).toStringAsFixed(4));
  print('l ${(amount * localTax).floor() / 10 * 10}');

  double remainder = amount * nationalTax % 10 + (amount * localTax) % 10;
  return ((amount * nationalTax / 10).floor() * 10 + (amount * localTax / 10).floor() * 10).toInt();
}
