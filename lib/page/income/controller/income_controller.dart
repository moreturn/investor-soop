import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:investor_soop/model/income.dart';
import 'package:investor_soop/model/property.dart';
import 'package:investor_soop/services/auth_service.dart';
import 'package:investor_soop/services/http_service.dart';

class IncomeController extends GetxController {
  final RxBool _isLoading = false.obs;
  final HttpService _httpService = Get.find<HttpService>();
  final AuthService _authService = Get.find<AuthService>();

  final ScrollController scrollController = ScrollController();
  final show = RxMap({"collateral": true, "credit": true});

  IncomeShowType get showType =>
      !(show['collateral'] ?? false) && !(show['credit'] ?? false)
          ? IncomeShowType.none
          : (show['collateral'] ?? false) && (show['credit'] ?? false)
              ? IncomeShowType.all
              : (show['collateral'] ?? false)
                  ? IncomeShowType.collateral
                  : IncomeShowType.credit;

  Future<FetchedIncomeValue> fetchIncome(String start) async {
    print('start');
    print(start);
    dynamic value;
    try {
      if (_authService.isGuest.isTrue) {
        value = sample;
      } else {
        value = await _httpService
            .get<Map<String, dynamic>>('income_summary?start=$start');
      }
    } catch (e) {}

    return FetchedIncomeValue(value['data']);
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
      case IncomeShowType.all:
        return both;
      case IncomeShowType.credit:
        return credit;
      case IncomeShowType.collateral:
        return collateral;
      case IncomeShowType.none:
        return none ?? both;
    }
  }
}

const dynamic sample = {
  "data": {
    "credit": {
      "202101": '15100000',
      "202102": '35100000',
      "202103": '55100000',
      "202104": '35100000',
      "202105": '35100000',
      "202106": '15100000'
    },
    "collateral": {
      "202101": '15100000',
      "202102": '35100000',
      "202103": '45100000',
      "202104": '15100000',
      "202105": '25100000',
      "202106": '35100000'
    }
  }
};
