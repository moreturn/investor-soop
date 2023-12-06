class PropertyChartData {
  PropertyChartData(this.x, this.y);

  final String x;
  final double y;
}

class FetchedPropertyValue {
  late final int lastMonth;
  late final int lastMonthCollateral;
  late final int lastMonthCredit;
  late final List<PropertyChartData> collateralChartData;
  late final List<PropertyChartData> creditChartData;
  late final List<PropertyChartData> chartData;

  late final int chartMin;
  late final int chartMax;
  late final int collateralChartMin;
  late final int collateralChartMax;
  late final int creditChartMin;
  late final int creditChartMax;
  final minFactor = 0.5;
  final maxFactor = 1.02;

  FetchedPropertyValue(dynamic data) {
    collateralChartData = [];
    creditChartData = [];
    chartData = [];

    try {
      lastMonthCollateral = int.parse(
          (data['collateral'] as Map).entries.lastOrNull?.value ?? '0');
    } catch (e) {}
    try {
      lastMonthCredit =
          int.parse((data['credit'] as Map).entries.lastOrNull?.value ?? '0');
    } catch (e) {}

    lastMonth = lastMonthCredit + lastMonthCollateral;
    //
    //
    Map<int, int> chartRawData = {};
    Map<int, int> collateralChartRawData = {};
    Map<int, int> creditChartRawData = {};

    (data['credit'] as Map).entries.every((element) {
      if (chartRawData[int.parse(element.key)] != null) {
        chartRawData[int.parse(element.key)] =
            (int.parse(element.value) + chartRawData[int.parse(element.key)]!);
      } else {
        chartRawData[int.parse(element.key)] = int.parse(element.value);
      }
      creditChartRawData[int.parse(element.key)] = int.parse(element.value);
      return true;
    });

    (data['collateral'] as Map).entries.every((element) {
      if (chartRawData[int.parse(element.key)] != null) {
        chartRawData[int.parse(element.key)] =
            (int.parse(element.value) + chartRawData[int.parse(element.key)]!);
      } else {
        chartRawData[int.parse(element.key)] = int.parse(element.value);
      }
      collateralChartRawData[int.parse(element.key)] = int.parse(element.value);
      return true;
    });

    print('4');
    int? min = null;
    int? max = null;
    chartRawData.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key))
      ..every((element) {
        if (min == null || element.value.toDouble() < min!) {
          min = element.value;
        }
        if (max == null || element.value.toDouble() > max!) {
          max = element.value;
        }
        chartData.add(PropertyChartData(
            element.key.toString(), element.value.toDouble()));
        return true;
      });
    chartMin = minCalc(min, max);
    chartMax = maxCalc(min, max);
    print('5');
    min = null;
    max = null;
    collateralChartRawData.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key))
      ..every((element) {
        if (min == null || element.value.toDouble() < min!) {
          min = element.value;
        }
        if (max == null || element.value.toDouble() > max!) {
          max = element.value;
        }
        collateralChartData.add(PropertyChartData(
            element.key.toString(), element.value.toDouble()));
        return true;
      });
    collateralChartMin = minCalc(min, max);
    collateralChartMax = maxCalc(min, max);
    print('6');
    min = null;
    max = null;
    creditChartRawData.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key))
      ..every((element) {
        if (min == null || element.value.toDouble() < min!) {
          min = element.value;
        }
        if (max == null || element.value.toDouble() > max!) {
          max = element.value;
        }
        creditChartData.add(PropertyChartData(
            element.key.toString(), element.value.toDouble()));
        return true;
      });
    creditChartMin = minCalc(min, max);
    creditChartMax = maxCalc(min, max);
  }

  int minCalc(int? min, int? max) {
    int n = min ?? 0;
    int x = max ?? 0;
    int gap = x - n;
    int ret = n - (gap ~/ 6);
    return n == x
        ? 0
        : ret < 0
            ? 0
            : ret;
  }

  int maxCalc(int? min, int? max) {
    int n = min ?? 0;
    int x = max ?? 0;
    int gap = x - n;
    int ret = x + gap ~/ 6;
    return gap == 0 ? x + x ~/ 6 : ret;
  }
}

class ProceedProperty {
  late final String companyName;
  late final String? address;
  late final DateTime executeDate;
  late final DateTime expireDate;
  late final double interestRate;
  late final int amount;
  late final int balance;
  late final String currency;
  late final int? amountByCurrency;
  late final String title;
  late final int regularInterest;
  late final double tax;
  late final String interestPaymentType;

  ProceedProperty(
      {required this.companyName,
      this.address,
      required this.executeDate,
      required this.expireDate,
      required this.interestRate,
      required this.amount,
      required this.currency,
      required this.balance,
      required this.interestPaymentType,
      this.amountByCurrency,
      required this.title,
      required this.regularInterest,
      required this.tax});

  ProceedProperty.fromJson(Map<String, dynamic> json) {
    try {
      companyName = json['companyName'];
      address = json['address'];
      executeDate = DateTime.parse(json['executeDate']).toLocal();
      expireDate = DateTime.parse(json['expireDate']).toLocal();
      interestRate = double.parse(json['interestRate'].toString());
      amount = json['amount'];
      currency = json['currency'];
      amountByCurrency = json['amountByCurrency'];
      regularInterest = json['regularInterest'];
      title = json['title'];
      tax = double.parse(json['tax'].toString());
      balance = json['balance'];
      interestPaymentType = json['interestPaymentType'];
    } catch (e) {}
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['companyName'] = companyName;
    data['address'] = address;
    data['executeDate'] = executeDate;
    data['expireDate'] = expireDate;
    data['interestRate'] = interestRate;
    data['amount'] = amount;
    data['currency'] = currency;
    data['amountByCurrency'] = amountByCurrency;
    data['regularInterest'] = regularInterest;
    data['title'] = title;
    data['tax'] = tax;
    data['balance'] = balance;
    data['interestPaymentType'] = interestPaymentType;
    return data;
  }
}

enum PropertyShowType { all, credit, collateral, none }
