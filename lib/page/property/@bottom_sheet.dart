import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:investor_soop/component/button.dart';
import 'package:investor_soop/component/color.dart';
import 'package:investor_soop/component/typograph.dart';
import 'package:investor_soop/page/property/controller/property_controller.dart';
import 'package:investor_soop/util/extension.dart';

class PropertyBottomSheet extends StatelessWidget {
  final PropertyController controller;
  final int lastMonth;

  const PropertyBottomSheet(
    this.controller,
    this.lastMonth, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 350,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 105,
              child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 32, 20, 20),
                  child: RichText(
                      text: TextSpan(style: h2(), children: <TextSpan>[
                    TextSpan(
                        text: '총 자산\n',
                        style: h5(color: Colors.black, bold: true)),
                    TextSpan(
                        text: lastMonth.setComma() + '원',
                        style: h2(color: Colors.black, bold: true)),
                  ]))),
            ),
            Obx(
              () => Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 32,
                      child: Text(
                        '상품선택',
                        style: h7(color: gray300),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        print(controller.show);
                        controller.show({
                          "credit": controller.show["credit"] ?? false,
                          "collateral":
                              !(controller.show["collateral"] ?? false)
                        });
                      },
                      child: Container(
                        height: 56,
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'GPL',
                              style: h3().copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                            (controller.show['collateral'] ?? false)
                                ? Icon(
                                    Icons.done,
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                    Divider(),
                    InkWell(
                      onTap: () {
                        controller.show({
                          "credit": !(controller.show["credit"] ?? false),
                          "collateral": controller.show["collateral"] ?? false
                        });
                      },
                      child: Container(
                        height: 56,
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '담보대출',
                              style: h3().copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                            (controller.show['credit'] ?? false)
                                ? Icon(
                                    Icons.done,
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                    Divider(),
                    SizedBox(
                      height: 20,
                    ),
                    Button(
                      onPressed: Get.back,
                      child: Text(
                        '닫기',
                        style: label2(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            )

            // ElevatedButton(
            //   onPressed: () {
            //     controller.show({
            //       "credit": controller.show["credit"] ?? false,
            //       "collateral": !(controller.show["collateral"] ?? false)
            //     });
            //   },
            //   child: const Text('GPL'),
            // ),
            // const SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: () {
            //     controller.show({
            //       "credit": !(controller.show["credit"] ?? false),
            //       "collateral": controller.show["collateral"] ?? false
            //     });
            //   },
            //   child: const Text('담보'),
            // ),
            // const SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: Get.back,
            //   child: const Text('닫기'),
            // )
          ],
        ),
      ),
    );
  }
}
