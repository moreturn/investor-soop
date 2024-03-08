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
      "202201": '15100000',
      "202302": '35100000',
      "202403": '55100000',
      "202104": '35100000',
      "202105": '35100000',
      "202106": '15100000'
    },
    "collateral": {
      "202401": '15100000',
      "202302": '35100000',
      "202203": '45100000',
      "202104": '15100000',
      "202505": '25100000',
      "202106": '35100000'
    }
  }
};
