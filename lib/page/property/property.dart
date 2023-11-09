import 'package:fl_query/fl_query.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:invesotr_soop/component/color.dart';
import 'package:invesotr_soop/component/skeleton.dart';
import 'package:invesotr_soop/component/typograph.dart';
import 'package:invesotr_soop/page/property/@bottom_sheet.dart';
import 'package:invesotr_soop/page/property/controller/property_controller.dart';
import 'package:invesotr_soop/services/auth_service.dart';
import 'package:invesotr_soop/util/extension.dart';
import 'package:invesotr_soop/util/numberToKor.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PropertyPage extends GetView<PropertyController> {
  PropertyPage({super.key});

  Future<FetchedPropertyValue> fetch() {
    return controller.fetchProperty();
  }

  @override
  Widget build(BuildContext context) {
    final _tooltip = TooltipBehavior(
        enable: true,
        builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
            int seriesIndex) {
          return Container(
              padding: EdgeInsets.all(16),
              child: Text(
                '${data.x.toString().substring(0, 4)}년${data.x.toString().substring(4, 6)}월 : ${numberToKor((data.y).toInt().toString(), isAll: true)}원',
                style: const TextStyle(color: Colors.white),
              ));
        });
    print(Get.find<AuthService>().userId);
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: QueryBuilder<FetchedPropertyValue, dynamic>(
          Get.find<AuthService>().userId, () => fetch(), onData: (value) {
        // Map<String, int> credit = value['data']['credit'];
      }, onError: (error) {
        print(error); /**/
      }, builder: (context, query) {
        // print(query.data);
        return Obx(
          () {
            print(controller.showType);
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 32,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 32,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.bottomSheet(
                                PropertyBottomSheet(
                                    controller, query.data!.lastMonth),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    topLeft: Radius.circular(20),
                                  ),
                                ),
                                clipBehavior: Clip.hardEdge,
                                backgroundColor: Colors.white);
                          },
                          child: Row(
                            children: [
                              Text('총 자산',
                                  style: h2(bold: true, color: gray900)),
                              const SizedBox(
                                width: 8,
                              ),
                              SvgPicture.asset(
                                'assets/icons/ic_chevron_down_s.svg',
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                            onTap: () {},
                            child: SvgPicture.asset('assets/images/kakao.svg'))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 28,
                  ),
                  query.isLoading || query.data == null
                      ? const Skeleton(
                          width: 200,
                          height: 40,
                        )
                      : Text(
                          '${controller.selector(query.data!.lastMonth, query.data!.lastMonthCollateral, query.data!.lastMonthCredit).setComma()} 원',
                          style: h1(bold: true, color: Colors.black)),
                  const SizedBox(height: 16),
                  query.isLoading || query.data == null
                      ? const Skeleton(
                          width: double.infinity,
                          height: 24,
                        )
                      : controller.showType != PropertyShowType.none
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                backgroundColor: yellow,
                                color: green1,
                                value: controller.selector(
                                    query.data!.lastMonthCollateral /
                                        query.data!.lastMonthCredit /
                                        2,
                                    1,
                                    0),
                                minHeight: 24,
                              ),
                            )
                          : Container(),
                  const SizedBox(height: 24),
                  Column(
                    children: [
                      query.isLoading || query.data == null
                          ? const Skeleton(
                              width: double.infinity,
                              height: 64,
                            )
                          : controller.showType == PropertyShowType.all ||
                                  controller.showType ==
                                      PropertyShowType.collateral
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Container(
                                    height: 64,
                                    width: double.infinity,
                                    child: Material(
                                      color: warmGray50,
                                      child: InkWell(
                                        onTap: () {
                                          Get.toNamed('/property_detail/collateral');
                                        },
                                        child: Stack(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 16,
                                                          horizontal: 12),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
                                                        color: green1,
                                                      ),
                                                      width: 6,
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'GPL',
                                                          style: h5(
                                                              color: gray800,
                                                              bold: true),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 48),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        '${query.data!.lastMonthCollateral.setComma()}원',
                                                        style: h5(
                                                            color: gray800,
                                                            bold: true),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Positioned(
                                                right: 12,
                                                top: 0,
                                                bottom: 0,
                                                child: SvgPicture.asset(
                                                    'assets/icons/ic_chevron_right_s.svg'))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                      const SizedBox(height: 8),
                      query.isLoading || query.data == null
                          ? const Skeleton(
                              width: double.infinity,
                              height: 64,
                            )
                          : controller.showType == PropertyShowType.all ||
                                  controller.showType == PropertyShowType.credit
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Container(
                                    height: 64,
                                    width: double.infinity,
                                    child: Material(
                                      color: warmGray50,
                                      child: InkWell(
                                        onTap: () {
                                          Get.toNamed('/property_detail/credit');
                                        },
                                        child: Stack(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 16,
                                                          horizontal: 12),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
                                                        color: yellow,
                                                      ),
                                                      width: 6,
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          '담보대출',
                                                          style: h5(
                                                              color: gray800,
                                                              bold: true),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 48),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        '${query.data!.lastMonthCredit.setComma()}원',
                                                        style: h5(
                                                            color: gray800,
                                                            bold: true),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Positioned(
                                                right: 12,
                                                top: 0,
                                                bottom: 0,
                                                child: SvgPicture.asset(
                                                    'assets/icons/ic_chevron_right_s.svg'))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                    ],
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Text(
                    '총 자산 변동 추이',
                    style: h4(color: gray900, bold: true),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    '지난 6개월 (만원)',
                    style: h7(color: gray300),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  query.isLoading || query.data == null
                      ? const Skeleton(
                          width: double.infinity,
                          height: 706,
                        )
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.transparent)),
                            constraints: BoxConstraints(
                              minWidth: MediaQuery.of(context).size.width,
                              maxWidth: MediaQuery.of(context).size.width *
                                  (controller
                                              .selector(
                                                  query.data!.chartData,
                                                  query.data!
                                                      .collateralChartData,
                                                  query.data!.creditChartData)
                                              .length <=
                                          6
                                      ? 1
                                      : controller
                                              .selector(
                                                  query.data!.chartData,
                                                  query.data!
                                                      .collateralChartData,
                                                  query.data!.creditChartData)
                                              .length /
                                          6),
                            ),
                            child: SfCartesianChart(
                                primaryXAxis: CategoryAxis(
                                  isVisible: false,
                                  majorGridLines:
                                      const MajorGridLines(width: 0),
                                ),
                                primaryYAxis: NumericAxis(
                                  isVisible: false,
                                  minimum: controller
                                      .selector(
                                          query.data!.chartMin,
                                          query.data!.collateralChartMin,
                                          query.data!.creditChartMin)
                                      .toDouble(),
                                  maximum: controller
                                      .selector(
                                          query.data!.chartMax,
                                          query.data!.collateralChartMax,
                                          query.data!.creditChartMax)
                                      .toDouble(),
                                  interval: 10,
                                  rangePadding: ChartRangePadding.round,
                                  majorGridLines:
                                      const MajorGridLines(width: 0),
                                ),
                                tooltipBehavior: _tooltip,
                                series: <ChartSeries<PropertyChartData,
                                    String>>[
                                  ColumnSeries<PropertyChartData, String>(
                                    dataLabelSettings: const DataLabelSettings(
                                      isVisible: true,
                                    ),
                                    dataLabelMapper: (d, i) {
                                      return NumberFormat('###,###,###,###,###')
                                          .format((d.y / 10000).toInt());
                                    },
                                    selectionBehavior: SelectionBehavior(
                                      enable: true,
                                      selectedColor: yellow,
                                      unselectedColor: grayLight2,
                                      unselectedOpacity: 1,
                                    ),
                                    spacing: 0.2,
                                    dataSource: controller.selector(
                                        query.data!.chartData,
                                        query.data!.collateralChartData,
                                        query.data!.creditChartData),
                                    xValueMapper: (PropertyChartData cd, _) =>
                                        cd.x,
                                    yValueMapper: (PropertyChartData cd, _) =>
                                        cd.y,
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(4),
                                        topRight: Radius.circular(4)),
                                    name: 'Gold',
                                    color: grayLight2,
                                    opacity: 1,
                                  )
                                ]),
                          ),
                        ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}

/*


 */
