import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:investor_soop/model/property.dart';
import 'package:investor_soop/services/auth_service.dart';
import 'package:investor_soop/services/http_service.dart';
import 'package:investor_soop/util/toast.dart';

class ProceedScrollController extends GetxController {
  var scrollController = ScrollController().obs;
  final HttpService _httpService = Get.find<HttpService>();
  final AuthService _authService = Get.find<AuthService>();
  final String type;

  var data = <ProceedProperty>[].obs;
  var isLoading = false.obs;
  var hasMore = false.obs;
  var isShow = true.obs;
  int page = 1;

  ProceedScrollController({required this.type});

  @override
  void onInit() {
    _getData();

    scrollController.value.addListener(() {
      if (scrollController.value.position.pixels ==
              scrollController.value.position.maxScrollExtent &&
          hasMore.value) {
        _getData();
      }

      final direction = scrollController.value.position.userScrollDirection;
      if (direction == ScrollDirection.forward) {
        isShow.value = true;
      } else {
        isShow.value = false;
      }
    });

    super.onInit();
  }

  _getData() async {
    if (_authService.isGuest.isTrue) {
      List<ProceedProperty> listData = (sample['data'] as List<dynamic>)
          .map((d) => ProceedProperty.fromJson(d))
          .toList();
      data.addAll(listData);
      hasMore.value = false;
    } else {
      isLoading.value = true;
      try {
        var d = (await _httpService.get<Map<String, dynamic>>(
            'property_proceed?page=${page}&type=${type}'));
        List<ProceedProperty> listData = (d['data'] as List<dynamic>)
            .map((d) => ProceedProperty.fromJson(d))
            .toList();
        page++;
        data.addAll(listData);
        hasMore.value = data.length < d['maxCount'];
      } catch (e) {
        Toast.error(e.toString());
      } finally {
        isLoading.value = false;
      }
    }
  }
}

const sample = {
  "data": [
    {
      "idx": 1,
      "companyName": "숲자산관리대부",
      "address": "서울특별시 마포구 래미안공덕5차 101동 0000호",
      "executeDate": "2023-01-12T15:00:00.000Z",
      "expireDate": "2024-01-12T15:00:00.000Z",
      "interestRate": 12,
      "amount": 39740000,
      "balance": 39740000,
      "interestPaymentType": "MONTHLY",
      "title": "래미안 공덕 5차",
      "currency": "KRW",
      "amountByCurrency": 0,
      "regularInterest": 1000000,
      "tax": 27.5
    },
    {
      "idx": 2,
      "companyName": "근저당권업체명123",
      "address": "1231",
      "executeDate": "2022-11-12T15:00:00.000Z",
      "expireDate": "2024-11-12T15:00:00.000Z",
      "interestRate": 18,
      "amount": 3650000,
      "balance": 3650000,
      "interestPaymentType": "MONTHLY",
      "title": "김종원아파트",
      "currency": "KRW",
      "amountByCurrency": 0,
      "regularInterest": 54750,
      "tax": 3.3
    }
  ],
  "maxCount": 2
};
