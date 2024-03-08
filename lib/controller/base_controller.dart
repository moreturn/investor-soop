import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:investor_soop/model/chart_data.dart';
import 'package:investor_soop/services/auth_service.dart';
import 'package:investor_soop/services/http_service.dart';

class BaseController extends GetxController {
  final RxBool isLoading = false.obs;
  final HttpService httpService = Get.find<HttpService>();
  final AuthService authService = Get.find<AuthService>();

  final show = RxMap({"collateral": true, "credit": true, "other": true});
  final ScrollController scrollController = ScrollController();

  void calc() {}

  T selector<T>(T collateral, T credit, T other) {
    bool addCollateral = show["collateral"] ?? false;
    bool addCredit = show["credit"] ?? false;
    bool addOther = show["other"] ?? false;

    if (T == List || T.toString().startsWith('List<')) {
      List<ChartData> result = [];

      if (addCollateral) result.addAll(collateral as List<ChartData>);
      if (addCredit) result.addAll(credit as List<ChartData>);
      if (addOther) result.addAll(other as List<ChartData>);

      return consolidateChartData(result) as T;
    } else if (T == double ||
        T == int ||
        T == num ||
        T.toString() == "double?" ||
        T.toString() == "int?" ||
        T.toString() == "num?") {
      num result = 0;

      if (addCollateral) result += collateral as num;
      if (addCredit) result += credit as num;
      if (addOther) result += other as num;

      return result as T;
    } else {
      throw Exception('Unsupported type $T');
    }
  }

  // Add the consolidateChartData function here in BaseController so it can be used by both PropertyController and IncomeController

  List<ChartData> consolidateChartData(List<ChartData> originalData) {
    var map = <String, double>{};

    for (var data in originalData) {
      var existingY = map[data.x];
      if (existingY != null) {
        map[data.x] = existingY + data.y;
      } else {
        map[data.x] = data.y;
      }
    }

    return map.entries.map((e) => ChartData(e.key, e.value)).toList();
  }
}
