import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:invesotr_soop/controller/tab_controller.dart';
import 'package:invesotr_soop/navigation.dart';
import 'package:invesotr_soop/page/income/controller/income_controller.dart';
import 'package:invesotr_soop/page/income/income.dart';
import 'package:invesotr_soop/page/property/controller/property_controller.dart';
import 'package:invesotr_soop/page/property/property.dart';

class TabPage extends GetView<MainTabController> {
  const TabPage({Key? key}) : super(key: key);

  static List<Widget> tabPages = <Widget>[
    appPages.firstWhere((GetPage d) => d.name == Routes.property).page(),
    appPages.firstWhere((GetPage d) => d.name == Routes.income).page(),
    appPages.firstWhere((GetPage d) => d.name == Routes.setting).page(),
  ];

  @override
  Widget build(BuildContext context) {

    Get.lazyPut(() => IncomeController());
    Get.lazyPut(() => PropertyController());


    return Scaffold(
      body: Obx(() => SafeArea(
          child:
              // static 변수를 이용해 컨트롤러 접근
              tabPages[controller.selectedIndex.toInt()])),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            // 현재 인덱스를 selectedIndex에 저장
            currentIndex: controller.selectedIndex.value,
            // 요소(item)을 탭 할 시 실행)
            onTap: controller.changeIndex,
            // 선택에 따라 icon·label 색상 변경

            // 선택에 따라 label text style 변경
            unselectedLabelStyle: TextStyle(fontSize: 10),
            selectedLabelStyle: TextStyle(fontSize: 10),
            // 탭 애니메이션 변경 (fixed: 없음)
            type: BottomNavigationBarType.fixed,

            // Bar에 보여질 요소. icon과 label로 구성.
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: controller.selectedIndex.value ==
                          0 // 선택된 탭은 채워진 아이콘, 나머지는 line 아이콘
                      ? SvgPicture.asset(
                          'assets/icons/ic_card_active.svg',
                        )
                      : SvgPicture.asset(
                          'assets/icons/ic_card.svg',
                        ),
                  label: "tap1"),
              BottomNavigationBarItem(
                  icon: controller.selectedIndex.value == 1
                      ? SvgPicture.asset(
                          'assets/icons/ic_sign_active.svg',
                        )
                      : SvgPicture.asset(
                          'assets/icons/ic_sign.svg',
                        ),
                  label: "tap2"),
              BottomNavigationBarItem(
                  icon: controller.selectedIndex.value == 2
                      ? SvgPicture.asset(
                          'assets/icons/ic_gear_active.svg',
                        )
                      : SvgPicture.asset(
                          'assets/icons/ic_gear.svg',
                        ),
                  label: "tap3"),
            ],
          )),
    );
  }
}
