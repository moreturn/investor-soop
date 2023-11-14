import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invesotr_soop/component/typograph.dart';
import 'package:invesotr_soop/page/property/controller/end_scroll_controller.dart';
import 'package:invesotr_soop/page/property/controller/proceed_scroll_controller.dart';
import 'package:invesotr_soop/page/property/detail/detail.dart';

class PropertyDetailTab extends StatelessWidget {
  const PropertyDetailTab({super.key});

  @override
  Widget build(BuildContext context) {
    String title = Get.arguments['type'] == 'COLLATERAL' ? "GPL" : "담보대출";

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          bottom: TabBar(
            automaticIndicatorColorAdjustment: true,
            indicatorColor: Colors.black,
            indicatorSize: TabBarIndicatorSize.tab,
            unselectedLabelStyle: h3(),
            unselectedLabelColor: Colors.black,
            labelStyle: h3(bold: true),
            labelColor: Colors.black,
            indicatorPadding: const EdgeInsets.symmetric(horizontal: 16),
            tabs: const [
              Tab(text: '진행중'),
              Tab(text: '상환완료'),
            ],
          ),
        ),
        body: TabBarView(children: [
          DetailPage(key: GlobalKey(),controller : Get.put(ProceedScrollController(type: Get.arguments['type']))),
          DetailPage(key: GlobalKey(),controller : Get.put(EndScrollController(type:  Get.arguments['type']))),
        ]),
      ),
    );
  }
}
