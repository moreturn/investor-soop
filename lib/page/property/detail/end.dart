import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invesotr_soop/page/property/controller/end_scroll_controller.dart';

class EndPage extends StatelessWidget {
  final controller = Get.put<EndScrollController>(EndScrollController());

  EndPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.separated(
          controller: controller.scrollController.value,
          separatorBuilder: (_, index) => Divider(),
          itemCount: controller.data.length + 1,
          itemBuilder: (_, index) {
            if (index < controller.data.length) {
              var datum = controller.data[index];
              return Material(
                elevation: 10.0,
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  color: Colors.lightBlue[100 * (index % 9)],
                  child: ListTile(
                    leading: Icon(Icons.android_sharp),
                    title: Text('$datum 번째 데이터'),
                    trailing: Icon(Icons.arrow_forward_outlined),
                  ),
                ),
              );
            }
            if (controller.hasMore.value || controller.isLoading.value) {
              return Center(child: RefreshProgressIndicator());
            }
            return Container(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Column(
                  children: [
                    Text('데이터의 마지막 입니다'),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
