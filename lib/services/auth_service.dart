import 'dart:convert';

import 'package:fl_query/fl_query.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:invesotr_soop/controller/tab_controller.dart';
import 'package:invesotr_soop/services/env_service.dart';
import 'package:invesotr_soop/services/http_service.dart';

class AuthService extends GetxController {
  final RxBool isLogin = false.obs;
  final RxBool isGuest = false.obs;
  final storage = const FlutterSecureStorage();
  RxList<Token> tokens = RxList([]);
  String userId = 'guest';

  Future<AuthService> init() async {
    String? value = await storage.read(key: 'tokens');
    if (value != null) {
      tokens.addAll(((jsonDecode(await storage.read(key: 'tokens') ?? '[]'))
              as List<dynamic>)
          .map((d) => Token.fromJson(d))
          .toList());
      userId = tokens.where((element) => element.active).first.id;

      isLogin.value = true;
    } else {
      isLogin.value = false;
    }
    return this;
  }

  Future<bool> guestLogin() async {
    try {
      isLogin(true);
      isGuest(true);
      userId = 'guest';
      return true;
    } catch (e) {
      throw 'ee';
    }
  }

  Future<bool> login({required String id, required String password}) async {
    try {
      dynamic b =
          await HttpService().post('login', {"id": id, "password": password});

      List<Token> tokens =
          ((jsonDecode(await storage.read(key: 'tokens') ?? '[]'))
                  as List<dynamic>)
              .map((d) => Token.fromJson(d))
              .toList();

      if (tokens.where((d) => d.id == id).isEmpty) {
        tokens.add(Token(active: tokens.isEmpty, token: b['data'], id: id));
      }

      userId = tokens.where((element) => element.active).first.id;

      this.tokens(tokens);
      await storage.write(
          key: 'tokens',
          value: jsonEncode(tokens.map((d) => d.toJson()).toList()));

      isLogin(true);
      isGuest(false);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> logout() async {
    isLogin(false);
    isGuest(false);
    await storage.delete(key: 'tokens');
    await Future.delayed(
      Duration(seconds: 1),
    );
    Get.find<MainTabController>().selectedIndex(0);
    return true;
  }

  Future<bool> active(String id) async {
    isLogin(true);
    isGuest(false);

    List<dynamic> list =
        ((jsonDecode(await storage.read(key: 'tokens') ?? '[]'))
            as List<dynamic>);

    List<dynamic> list2 =
        list.map((d) => {...d, "active": id == d['id']}).toList();

    await storage.write(key: 'tokens', value: jsonEncode(list2));

    tokens.clear();
    tokens.addAll(list2.map((d) => Token.fromJson(d)));
    userId = tokens.where((element) => element.active).first.id;

    print(tokens[0].id + ' / ' + tokens[0].active.toString());
    print(tokens[1].id + ' / ' + tokens[1].active.toString());
    return true;
  }

  Future<String?> getToken() async {
    List<Token> tokens =
        ((jsonDecode(await storage.read(key: 'tokens') ?? '[]'))
                as List<dynamic>)
            .map((d) => Token.fromJson(d))
            .toList();
    return tokens.where((d) => d.active).firstOrNull?.token;
  }
}

class Token {
  bool active;
  String token;
  String id;

  Token({required this.token, required this.active, required this.id});

  factory Token.fromJson(Map<dynamic, dynamic> json) {
    return Token(token: json['token'], active: json['active'], id: json['id']);
  }

  Map<String, dynamic> toJson() {
    return {
      "active": active,
      "token": token,
      "id": id,
    };
  }
}
