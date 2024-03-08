import 'package:investor_soop/model/chart_data.dart';
enum ShowType { all, credit, collateral, none ,other }
class FetchedValue {
  late final int lastMonth;
  late final int lastMonthCollateral;
  late final int lastMonthCredit;
  late final int lastMonthOther;
  late final List<ChartData> collateralChartData;
  late final List<ChartData> creditChartData;
  late final List<ChartData> otherChartData;
  late final List<ChartData> chartData;

  late final int chartMin;
  late final int chartMax;
  late final int collateralChartMin;
  late final int collateralChartMax;
  late final int creditChartMin;
  late final int creditChartMax;
  late final int otherChartMin;
  late final int otherChartMax;
  final minFactor = 0.5;
  final maxFactor = 1.02;

  FetchedValue(dynamic data) {
    collateralChartData = [];
    creditChartData = [];
    otherChartData = [];
    chartData = [];

    lastMonthCollateral = data['lastMonthCollateral'];
    lastMonthOther = data['lastMonthOther'];
    lastMonthCredit = data['lastMonthCredit'];

    lastMonth = (lastMonthCredit + lastMonthCollateral + lastMonthOther);

    Map<int, int> chartRawData = {};
    Map<int, int> collateralChartRawData = {};
    Map<int, int> otherChartRawData = {};
    Map<int, int> creditChartRawData = {};

    (data['credit'] as Map).entries.every((element) {
      if (chartRawData[int.parse(element.key)] != null) {
        chartRawData[int.parse(element.key)] =
        (element.value + chartRawData[int.parse(element.key)]!);
      } else {
        chartRawData[int.parse(element.key)] = element.value;
      }
      creditChartRawData[int.parse(element.key)] = element.value;
      return true;
    });

    (data['collateral'] as Map).entries.every((element) {
      if (chartRawData[int.parse(element.key)] != null) {
        chartRawData[int.parse(element.key)] =
        (element.value + chartRawData[int.parse(element.key)]!);
      } else {
        chartRawData[int.parse(element.key)] = element.value;
      }
      collateralChartRawData[int.parse(element.key)] = element.value;
      return true;
    });

    (data['other'] as Map).entries.every((element) {
      if (chartRawData[int.parse(element.key)] != null) {
        chartRawData[int.parse(element.key)] =
        (element.value + chartRawData[int.parse(element.key)]!);
      } else {
        chartRawData[int.parse(element.key)] = element.value;
      }
      otherChartRawData[int.parse(element.key)] = element.value;
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
        chartData.add(ChartData(
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
        collateralChartData.add(ChartData(
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
        creditChartData.add(ChartData(
            element.key.toString(), element.value.toDouble()));
        return true;
      });
    creditChartMin = minCalc(min, max);
    creditChartMax = maxCalc(min, max);

    print('7');
    min = null;
    max = null;
    otherChartRawData.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key))
      ..every((element) {
        if (min == null || element.value.toDouble() < min!) {
          min = element.value;
        }
        if (max == null || element.value.toDouble() > max!) {
          max = element.value;
        }
        otherChartData.add(ChartData(
            element.key.toString(), element.value.toDouble()));
        return true;
      });
    otherChartMin = minCalc(min, max);
    otherChartMax = maxCalc(min, max);
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
