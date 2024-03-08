import 'package:get/get.dart';

class MainTabController extends GetxController {
  static MainTabController get to => Get.find();
  final RxInt selectedIndex = 0.obs;

  void changeIndex(int index) {
    selectedIndex(index);
  }
}
