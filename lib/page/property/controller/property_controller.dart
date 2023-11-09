import 'package:get/get.dart';
import 'package:invesotr_soop/services/http_service.dart';

class PropertyController extends GetxController {
  RxBool _isLoading = false.obs;
  HttpService _httpService = Get.find<HttpService>();

  final show = RxMap({"collateral": true, "credit": true});

  PropertyShowType get showType =>
      !(show['collateral'] ?? false) && !(show['credit'] ?? false)
          ? PropertyShowType.none
          : (show['collateral'] ?? false) && (show['credit'] ?? false)
              ? PropertyShowType.all
              : (show['collateral'] ?? false)
                  ? PropertyShowType.collateral
                  : PropertyShowType.credit;

  Future<FetchedPropertyValue> fetchProperty() async {
    print('fetch property');
    dynamic value = await _httpService.get<Map<String, dynamic>>('property');
    return FetchedPropertyValue(value['data']);
  }

  @override
  void onInit() {
    // ever(listData, (value) {
    //   print('listData changed');
    //   calc();
    // });
    // ever(show, (value) {
    //   print('show changed');
    // calc();
    // });
    super.onInit();
  }

  calc() {}

  T selector<T>(T both, T collateral, T credit, {T? none}) {
    switch (showType) {
      case PropertyShowType.all:
        return both;
      case PropertyShowType.credit:
        return credit;
      case PropertyShowType.collateral:
        return collateral;
      case PropertyShowType.none:
        return none ?? both;
    }
  }
}

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

  FetchedPropertyValue(dynamic data) {
    // lastMonth = 2;
    // lastMonthCollateral = 1;
    // lastMonthCredit = 1;
    collateralChartData = [];
    creditChartData = [];
    chartData = [];
    // collateralChartMin = 1;
    // collateralChartMax = 1;
    // creditChartMin = 1;
    // creditChartMax = 1;
    // chartMin = 1;
    // chartMax = 1;

    lastMonthCollateral =
        int.parse((data['collateral'] as Map).entries.last.value ?? 0);
    lastMonthCredit =
        int.parse((data['credit'] as Map).entries.last.value ?? 0);
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
    chartMin = min ?? 0;
    chartMax = max ?? 0;

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
    collateralChartMin = min ?? 0;
    collateralChartMax = max ?? 0;

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
    creditChartMin = min ?? 0;
    creditChartMax = max ?? 0;
  }
}

enum PropertyShowType { all, credit, collateral, none }
