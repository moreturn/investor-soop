import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:investor_soop/component/button.dart';
import 'package:investor_soop/component/color.dart';
import 'package:investor_soop/component/typograph.dart';
import 'package:investor_soop/model/property.dart';
import 'package:investor_soop/services/http_service.dart';
import 'package:investor_soop/util/extension.dart';
import 'package:investor_soop/util/numberToKor.dart';
import 'package:investor_soop/util/toast.dart';
import 'package:intl/intl.dart';

class DetailPage extends StatelessWidget {
  final controller;

  const DetailPage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 36,
          padding: const EdgeInsets.only(left: 16, right: 44),
          color: grayLight2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '투자계약번호',
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
                  ProceedProperty p = controller.data[index];
                  return PropertyTile(proceedProperty: p);
                }
                if (controller.hasMore.value || controller.isLoading.value) {
                  return const Center(child: RefreshProgressIndicator());
                }
                return Container(
                  padding: const EdgeInsets.all(10.0),
                  child: const Center(
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

class PropertyTile extends StatelessWidget {
  const PropertyTile({
    super.key,
    required this.proceedProperty,
  });

  final ProceedProperty proceedProperty;

  @override
  Widget build(BuildContext context) {

    int tax = calcWithholdingTax( proceedProperty.tax,proceedProperty.regularInterest.toDouble());

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
          children: [
            Text(proceedProperty.title, style: h5(color: gray800, bold: true)),
            Text('${proceedProperty.balance.setComma()}원',
                style: h5(color: gray800, bold: true))
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: warmGray50,
                child: Wrap(
                  runSpacing: 6,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '주관사',
                          style: h6(color: gray300),
                        ),
                        const SizedBox(width: 16),
                        Flexible(
                          child: Text(
                            proceedProperty.companyName,
                            textAlign: TextAlign.end,
                            style: h6(color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                    Get.arguments['type'] == 'COLLATERAL'
                        ? proceedProperty.collateral.isEmpty
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '담보주소',
                                    style: h6(color: gray300),
                                  ),
                                  const SizedBox(width: 16),
                                  Flexible(
                                    child: Text(
                                      '투자대기중',
                                      textAlign: TextAlign.end,
                                      style: h6(color: Colors.black87),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                children: proceedProperty.collateral
                                    .indexedMap<Widget>((d, i, c) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    i == 0
                                        ? Text(
                                            '담보주소',
                                            style: h6(color: gray300),
                                          )
                                        : Container(),
                                    const SizedBox(width: 16),
                                    Flexible(
                                      child: Text(
                                        proceedProperty.collateral[i].address ??
                                            '-',
                                        textAlign: TextAlign.end,
                                        style: h6(color: Colors.black87),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList())
                        : Container(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '투자시작일',
                          style: h6(color: gray300),
                        ),
                        const SizedBox(width: 16),
                        Flexible(
                          child: Text(
                            DateFormat.yMMMd('ko_KR').format(
                              proceedProperty.executeDate,
                            ),
                            textAlign: TextAlign.end,
                            style: h6(color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '투자만기일',
                          style: h6(color: gray300),
                        ),
                        const SizedBox(width: 16),
                        Flexible(
                          child: Text(
                            DateFormat.yMMMd()
                                .format(proceedProperty.expireDate),
                            textAlign: TextAlign.end,
                            style: h6(color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '금리',
                          style: h6(color: gray300),
                        ),
                        const SizedBox(width: 16),
                        Flexible(
                          child: Text(
                            '연 ${proceedProperty.interestRate}%',
                            textAlign: TextAlign.end,
                            style: h6(color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      color: grayLight2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '월간 수익',
                          style: h6(color: gray300),
                        ),
                        const SizedBox(width: 16),
                        Flexible(
                          child: Text(
                            '${proceedProperty.regularInterest.setComma()}원',
                            textAlign: TextAlign.end,
                            style: h6(color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '세금\n(원천징수세율)',
                          style: h6(color: gray300),
                        ),
                        const SizedBox(width: 16),
                        Flexible(
                          child: Text(
                            '${tax.setComma()}원\n(${proceedProperty.tax}%)',
                            textAlign: TextAlign.end,
                            style: h6(color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '월 실수령',
                          style: h6(color: gray300),
                        ),
                        const SizedBox(width: 16),
                        Flexible(
                          child: Text(
                            '${(proceedProperty.regularInterest - tax).setComma()}원',
                            textAlign: TextAlign.end,
                            style: h6(color: Colors.black87, bold: true),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      child: Wrap(
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.spaceBetween,
                        spacing: 8,
                        runSpacing: 8,
                        children: proceedProperty.files
                            .map<Widget>((Map<String, dynamic> file) =>
                                Container(
                                  height: 42,
                                  width: MediaQuery.of(context).size.width / 2 -
                                      40,
                                  child: Button(
                                    onPressed: () {
                                      HttpService.launchURL(file['location']);
                                    },
                                    width: double.infinity,
                                    color: warmGray50,
                                    borderColor: gray300,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            file['name'],
                                            style: label3(color: gray300)
                                                .copyWith(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    fontWeight:
                                                        FontWeight.w500),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                      ],
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          )
        ],
      ),
    );
  }
}

class ButtonInfo {
  final String text;
  final IconData icon;

  ButtonInfo(this.text, this.icon);
}

List<ButtonInfo> buttons = [
  ButtonInfo('물건 안내서', Icons.description_outlined),
  ButtonInfo('심사 보고서', Icons.description_outlined),
  // Add more ButtonInfos as necessary
];
