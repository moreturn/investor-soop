import 'package:get/get.dart';
import 'package:investor_soop/middleware/AuthGuard.dart';
import 'package:investor_soop/page/auth/login.dart';
import 'package:investor_soop/page/income/income.dart';
import 'package:investor_soop/page/property/detail/tab.dart';
import 'package:investor_soop/page/property/property.dart';
import 'package:investor_soop/page/setting/change_password.dart';
import 'package:investor_soop/page/setting/setting.dart';
import 'package:investor_soop/page/tab/tab.dart';

abstract class Routes {
  static const tab = '/tab';
  static const login = '/login';
  static const income = '/income';
  static const property = '/property';
  static const propertyDetailTab = '/property_detail';
  static const setting = '/setting';
  static const changePassword = '/change_password';
}

final appPages = [
  GetPage(
    name: Routes.login,
    page: () => LoginPage(),
  ),
  GetPage(
    name: Routes.tab,
    page: () => TabPage(),
    middlewares: [AuthGuard()],
  ),
  GetPage(
    name: Routes.income,
    page: () => IncomePage(),
    middlewares: [AuthGuard()],
  ),
  GetPage(
    name: Routes.property,
    page: () => PropertyPage(),
    middlewares: [AuthGuard()],
  ),
  GetPage(
    name: Routes.propertyDetailTab,
    page: () => const PropertyDetailTab(),
    middlewares: [AuthGuard()],
  ),
  GetPage(
    name: Routes.setting,
    page: () => SettingPage(),
    middlewares: [AuthGuard()],
  ),
  GetPage(
      name: Routes.changePassword,
      page: () => ChangePasswordPage(),
      middlewares: [AuthGuard()])
];
