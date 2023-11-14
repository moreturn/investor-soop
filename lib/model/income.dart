class IncomeChartData {
  IncomeChartData(this.x, this.y);

  final String x;
  final double y;
}

class FetchedIncomeValue {
  late final int lastMonth;
  late final int lastMonthCollateral;
  late final int lastMonthCredit;
  late final List<IncomeChartData> collateralChartData;
  late final List<IncomeChartData> creditChartData;
  late final List<IncomeChartData> chartData;

  late final int chartMin;
  late final int chartMax;
  late final int collateralChartMin;
  late final int collateralChartMax;
  late final int creditChartMin;
  late final int creditChartMax;
  final minFactor = 0.5;
  final maxFactor = 1.02;

  FetchedIncomeValue(dynamic data) {
    collateralChartData = [];
    creditChartData = [];
    chartData = [];

    try {
      lastMonthCollateral = int.parse(
          (data['collateral'] as Map).entries.lastOrNull?.value ?? '0');
    } catch (e) {

    }
    try {
      lastMonthCredit =
          int.parse((data['credit'] as Map).entries.lastOrNull?.value ?? '0');
    } catch (e) {

    }

    lastMonth = lastMonthCredit + lastMonthCollateral;

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


    int? min = null;
    int max = 0;
    chartRawData.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key))
      ..every((element) {
        if (min == null || element.value.toDouble() < min!) {
          min = element.value;
        }
        max += element.value;
        chartData.add(
            IncomeChartData(element.key.toString(), element.value.toDouble()));
        return true;
      });
    chartMin = minCalc(min, max);
    chartMax = maxCalc(min, max);


    min = null;
    max = 0;
    collateralChartRawData.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key))
      ..every((element) {
        if (min == null || element.value.toDouble() < min!) {
          min = element.value;
        }
        max += element.value;
        collateralChartData.add(
            IncomeChartData(element.key.toString(), element.value.toDouble()));
        return true;
      });
    collateralChartMin = minCalc(min, max);
    collateralChartMax = maxCalc(min, max);

    min = null;
    max = 0;
    creditChartRawData.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key))
      ..every((element) {
        if (min == null || element.value.toDouble() < min!) {
          min = element.value;
        }
        if (element.value.toDouble() > max) {
          max += element.value;
        }
        creditChartData.add(
            IncomeChartData(element.key.toString(), element.value.toDouble()));
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

enum IncomeShowType { all, credit, collateral, none }
