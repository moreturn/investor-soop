import 'package:get/get.dart';
import 'package:invesotr_soop/model/property.dart';
import 'package:invesotr_soop/services/auth_service.dart';
import 'package:invesotr_soop/services/http_service.dart';

class PropertyController extends GetxController {
  final RxBool _isLoading = false.obs;
  final HttpService _httpService = Get.find<HttpService>();
  final AuthService _authService = Get.find<AuthService>();

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
    dynamic value;

    if (_authService.isGuest.isTrue) {
      value = sample;
    } else {
      value = await _httpService.get<Map<String, dynamic>>('property_summary');
    }

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
