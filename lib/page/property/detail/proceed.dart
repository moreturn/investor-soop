import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invesotr_soop/component/color.dart';
import 'package:invesotr_soop/component/typograph.dart';
import 'package:invesotr_soop/page/property/controller/proceed_scroll_controller.dart';

class ProceedPage extends StatelessWidget {
  final controller =
      Get.put<ProceedScrollController>(ProceedScrollController());

  ProceedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 36,
          padding: EdgeInsets.only(left: 16, right: 44),
          color: grayLight2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '담보 단지명',
                style: h6(color: gray300),
              ),
              Text(
                '투자금액',
                style: h6(color: gray300),
              )
            ],
          ),
        ),
        Flexible(
          child: Obx(
            () => ListView.separated(
              controller: controller.scrollController.value,
              separatorBuilder: (_, index) => Container(
                color: grayLight2,
                height: 1,
                width: double.infinity,
              ),
              itemCount: controller.data.length + 1,
              itemBuilder: (_, index) {
                if (index < controller.data.length) {
                  var datum = controller.data[index];
                  return Theme(
                    data: ThemeData(
                      dividerColor: Colors.transparent,
                    ),
                    child: ExpansionTile(
                      collapsedTextColor: gray800,
                      iconColor: gray800,
                      collapsedIconColor: gray800,
                      textColor: gray800,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text('123호 은마아파트'), Text('123,000,000원')],
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            child: Container(
                              width: double.infinity,
                              height: 360,
                              padding: EdgeInsets.all(16),
                              color: warmGray50,
                              child: Column(
                                children: [
                                  Wrap(
                                    direction: Axis.horizontal,
                                    runSpacing: 16,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.start,
                                    children: [
                                      Container(
                                        child: Text('aaa'),
                                      ),
                                      Container(
                                          child: Container(
                                        color: Colors.blue,
                                        alignment: Alignment.topRight,
                                        child: Text(
                                            'aas fasdfasdfsadflkajsdlfk jasdf asdkfj haslkjdfh lkasjdhflkas jdhflkajshf '),
                                      ))
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        )
                      ],
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
        ),
      ],
    );
  }
}
