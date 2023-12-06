import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:investor_soop/component/button.dart';
import 'package:investor_soop/component/color.dart';
import 'package:investor_soop/component/typograph.dart';
import 'package:investor_soop/model/property.dart';
import 'package:investor_soop/util/extension.dart';
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
                Get.arguments['type'] == 'COLLATERAL' ? '담보 단지명' : '투자기간',
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
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '담보주소',
                                style: h6(color: gray300),
                              ),
                              const SizedBox(width: 16),
                              Flexible(
                                child: Text(
                                  proceedProperty.address ?? '-',
                                  textAlign: TextAlign.end,
                                  style: h6(color: Colors.black87),
                                ),
                              ),
                            ],
                          )
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
                            '${(proceedProperty.regularInterest * (proceedProperty.tax / 100)).toInt().setComma()}원\n(${proceedProperty.tax}%)',
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
                            '${(proceedProperty.regularInterest - (proceedProperty.regularInterest * (proceedProperty.tax / 100)).toInt()).setComma()}원',
                            textAlign: TextAlign.end,
                            style: h6(color: Colors.black87, bold: true),
                          ),
                        ),
                      ],
                    ),
                    Get.arguments['type'] == 'COLLATERAL'
                        ? Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Flexible(
                                child: Button(
                                  onPressed: () {
                                    Toast.warn('준비중');
                                  },
                                  width: double.infinity,
                                  color: warmGray50,
                                  borderColor: gray300,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        '물건 안내서',
                                        style: label3(color: gray300).copyWith(
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      const Icon(
                                        Icons.description_outlined,
                                        color: gray300,
                                        size: 16,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Flexible(
                                child: Button(
                                  onPressed: () {
                                    Toast.warn('준비중');
                                  },
                                  width: double.infinity,
                                  color: warmGray50,
                                  borderColor: gray300,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        '심사 보고서',
                                        style: label3(color: gray300).copyWith(
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      const Icon(
                                        Icons.description_outlined,
                                        color: gray300,
                                        size: 16,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Container()
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
