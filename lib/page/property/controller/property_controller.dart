import 'package:investor_soop/controller/base_controller.dart';
import 'package:investor_soop/model/fetched_value.dart';
import 'package:get/get.dart';

class PropertyController extends BaseController {
  Future<FetchedValue> fetchProperty() async {
    dynamic value;
    if (authService.isGuest.isTrue) {
      value = sample;
    } else {
      value = await httpService.get<Map<String, dynamic>>('property_summary');
    }

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
