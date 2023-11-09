import 'package:fl_query/fl_query.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invesotr_soop/controller/tab_controller.dart';
import 'package:invesotr_soop/navigation.dart';
import 'package:invesotr_soop/page/income/controller/income_controller.dart';
import 'package:invesotr_soop/page/property/controller/property_controller.dart';
import 'package:invesotr_soop/services/auth_service.dart';
import 'package:invesotr_soop/services/env_service.dart';
import 'package:invesotr_soop/services/http_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync(() => AuthService().init());
  EnvService env = await Get.putAsync(() => EnvService().init());
  await Get.putAsync(() => HttpService().init());
  Get.put<MainTabController>(MainTabController());


  await QueryClient.initialize(
      cachePrefix: env.isProd.isTrue ? 'fl_query_prod' : 'fl_query_dev');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthService>();
    final env = Get.find<EnvService>();
    return QueryClientProvider(
      child: GetMaterialApp(
        title: 'Investor',
        debugShowCheckedModeBanner: !env.isProd.value,
        getPages: appPages,
        initialRoute: auth.isLogin.value ? Routes.tab : Routes.login,
        initialBinding: InitialBinding(),
        theme: ThemeData(
          fontFamily: 'SpoqaHanSansNeo',
          colorScheme:
              ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 30, 41, 72)),
          useMaterial3: true,
        ),
      ),
    );
  }
}

class InitialBinding implements Bindings {
  @override
  void dependencies() {

  }
}
