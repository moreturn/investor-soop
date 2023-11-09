import 'package:flutter/material.dart';
import 'package:invesotr_soop/component/typograph.dart';
import 'package:invesotr_soop/page/property/detail/end.dart';
import 'package:invesotr_soop/page/property/detail/proceed.dart';

class PropertyDetailTab extends StatelessWidget {
  const PropertyDetailTab({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("GPL"),
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
          ProceedPage(),
          EndPage(),
        ]),
      ),
    );
  }
}
