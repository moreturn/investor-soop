import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:invesotr_soop/services/auth_service.dart';

class EnvService extends GetxController {
  get serviceCode => '1';
  get companyGroupCode => isProd.isTrue ? '28ab2275' : '6b0eb29f';
  get apiEndPoint => isProd.isFalse
      ? 'http://localhost:3005/investor/'
      : 'https://api.moneyparking.co.kr/investor/';

  Future<EnvService> init() async {
    String? value = await _storage.read(key: 'isProd');
    if (value == 'true') {
      isProd(true);
    } else {
      isProd(false);
    }
    return this;
  }

  final RxBool isProd = false.obs;
  final _storage = const FlutterSecureStorage();

  Future<bool> prodMode() async {
    await _storage.write(key: 'isProd', value: 'true');
    isProd(true);
    try {
      await Get.find<AuthService>().logout();
      SystemNavigator.pop();
      exit(0);
    } catch (e) {}
    return true;
  }

  Future<bool> devMode() async {
    await _storage.delete(key: 'isProd');
    isProd(false);
    try {
      await Get.find<AuthService>().logout();
      SystemNavigator.pop();
      exit(0);
    } catch (e) {}
    return true;
  }
}
