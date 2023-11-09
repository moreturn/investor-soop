import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invesotr_soop/navigation.dart';
import 'package:invesotr_soop/services/auth_service.dart';

class AuthGuard extends GetMiddleware {
  final authService = Get.find<AuthService>();

  @override
  RouteSettings? redirect(String? route) {
    return authService.isLogin.value
        ? null
        : const RouteSettings(name: Routes.login);
  }
}
