import 'package:get/get.dart';
import 'package:investor_soop/controller/base_controller.dart';
import 'package:investor_soop/model/fetched_value.dart';

class IncomeController extends BaseController {
  Future<FetchedValue> fetchIncome(String start) async {
    dynamic value;
    try {
      if (authService.isGuest.isTrue) {
        value = sample;
      } else {
        value = await httpService
            .get<Map<String, dynamic>>('income_summary?start=$start');
      }
    } catch (e) {}

    return FetchedValue(value['data']);
  }

  @override
  void onInit() {
    super.onInit();
  }

// Your remaining code here...
}

const dynamic sample = {
  "data": {
    "credit": {
      "202101": 15100000,
      "202102": 35100000,
      "202103": 55100000,
      "202104": 35100000,
      "202105": 35100000,
      "202106": 1510000
    },
    "collateral": {
      "202101": 15100000,
      "202102": 35100000,
      "202103": 45100000,
      "202104": 15100000,
      "202105": 25100000,
      "202106": 3510000
    },
    "other": {
      "202101": 15100000,
      "202102": 35100000,
      "202103": 45100000,
      "202104": 15100000,
      "202105": 25100000,
      "202106": 3510000
    },
    "lastMonthCredit": 35100000,
    "lastMonthOther": 35100000,
    "lastMonthCollateral": 35100000
  }
};
