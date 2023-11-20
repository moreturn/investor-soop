import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:invesotr_soop/services/auth_service.dart';

class EnvService extends GetxController {
  get serviceCode => '1';

  get companyGroupCode => isProd.isTrue ? '28ab2275' : devGroupCode;

  get apiEndPoint => isProd.isFalse
      // ? 'http://localhost:3005/investor/'
      ? 'https://tapi.moneyparking.co.kr/investor/'
      : 'https://api.moneyparking.co.kr/investor/';

  late String devGroupCode;

  Future<EnvService> init() async {
    String? value = await _storage.read(key: 'isDev');
    if (value == 'true') {
      isProd(false);
      devGroupCode = (await _storage.read(key: 'devGroupCode')) ?? '6b0eb29f';
    } else {
      isProd(true);
    }
    return this;
  }

  final RxBool isProd = false.obs;
  final _storage = const FlutterSecureStorage();

  Future<bool> prodMode() async {
    await _storage.delete(key: 'isDev');
    isProd(true);
    try {
      await Get.find<AuthService>().logout();
      SystemNavigator.pop();
      exit(0);
    } catch (e) {}
    return true;
  }

  Future<bool> devMode() async {
    await _storage.write(key: 'isDev', value: 'true');
    isProd(false);
    try {
      await Get.find<AuthService>().logout();
      SystemNavigator.pop();
      exit(0);
    } catch (e) {}
    return true;
  }

  Future<bool> setDevGroupCode(String str) async {
    await _storage.write(key: 'devGroupCode', value: str);
    isProd(false);
    try {
      await Get.find<AuthService>().logout();
      SystemNavigator.pop();
      exit(0);
    } catch (e) {}
    return true;
  }
}
