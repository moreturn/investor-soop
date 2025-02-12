import 'package:fl_query/fl_query.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:investor_soop/component/color.dart';
import 'package:investor_soop/component/skeleton.dart';
import 'package:investor_soop/component/typograph.dart';
import 'package:investor_soop/model/chart_data.dart';
import 'package:investor_soop/model/fetched_value.dart';
import 'package:investor_soop/model/property.dart';
import 'package:investor_soop/page/@bottom_sheet.dart';
import 'package:investor_soop/page/property/controller/property_controller.dart';
import 'package:investor_soop/services/auth_service.dart';
import 'package:investor_soop/services/http_service.dart';
import 'package:investor_soop/util/extension.dart';
import 'package:investor_soop/util/numberToKor.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PropertyPage extends GetView<PropertyController> {
  PropertyPage({super.key});

  Future<FetchedValue> fetch() {
    return controller.fetchProperty();
  }

  @override
  Widget build(BuildContext context) {
    TooltipBehavior? onRunningTooltipBehavior;
    final tooltip = TooltipBehavior(
        enable: true,
        builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
            int seriesIndex) {
          return GestureDetector(
            onTap: () {
              onRunningTooltipBehavior?.hide();
            },
            child: Container(
                padding: const EdgeInsets.all(16),
                child: Text(
                  '${data.x.toString().substring(0, 4)}년${data.x.toString().substring(4, 6)}월 : ${numberToKor((data.y).toInt().toString(), isAll: true)}원',
                  style: const TextStyle(color: Colors.white),
                )),
          );
        });
    onRunningTooltipBehavior = tooltip;

    return RefreshIndicator(
      onRefresh: () {
        return fetch();
      },
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: QueryBuilder<FetchedValue, dynamic>(
            '${Get.find<AuthService>().userId}-property-summary', () => fetch(),
            onData: (value) {
          // Map<String, int> credit = value['data']['credit'];
        }, onError: (error) {
          print(error); /**/
        }, builder: (context, query) {
          // print(query.data);
          query.fetch();
          return Obx(
            () {
              print(controller.show);
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
                              Get.bottomSheet(Obx(() {
                                return PropertyBottomSheet(
                                  controller,
                                  controller.selector(
                                    query.data!.lastMonthCollateral,
                                    query.data!.lastMonthCredit,
                                    query.data!.lastMonthOther,
                                  ),
                                );
                              }),
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
                                Text('총 투자금',
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
                              onTap: () {
                                HttpService.launchURL(
                                    'https://pf.kakao.com/_xhxohxbxb/chat');
                              },
                              child:
                                  SvgPicture.asset('assets/images/kakao.svg'))
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
                            '${controller.selector(
                                  query.data!.lastMonthCollateral,
                                  query.data!.lastMonthCredit,
                                  query.data!.lastMonthOther,
                                ).setComma()} 원',
                            style: h1(bold: true, color: Colors.black)),
                    const SizedBox(height: 16),
                    SingleBarChart(query),
                    const SizedBox(height: 24),
                    Column(
                      children: [
                        query.isLoading || query.data == null
                            ? const Skeleton(
                                width: double.infinity,
                                height: 64,
                              )
                            : (controller.show['collateral'] ?? false)
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: Container(
                                      height: 64,
                                      width: double.infinity,
                                      child: Material(
                                        color: warmGray50,
                                        child: InkWell(
                                          onTap: () {
                                            Get.toNamed('/property_detail',
                                                arguments: {
                                                  "type": "COLLATERAL"
                                                });
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
                                                        decoration:
                                                            BoxDecoration(
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
                                                          CrossAxisAlignment
                                                              .end,
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
                            : (controller.show['credit'] ?? false)
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: Container(
                                      height: 64,
                                      width: double.infinity,
                                      child: Material(
                                        color: warmGray50,
                                        child: InkWell(
                                          onTap: () {
                                            Get.toNamed('/property_detail',
                                                arguments: {"type": "CREDIT"});
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
                                                        decoration:
                                                            BoxDecoration(
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
                                                          CrossAxisAlignment
                                                              .end,
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
                        const SizedBox(height: 8),
                        query.isLoading || query.data == null
                            ? const Skeleton(
                                width: double.infinity,
                                height: 64,
                              )
                            : (controller.show['other'] ?? false)
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: Container(
                                      height: 64,
                                      width: double.infinity,
                                      child: Material(
                                        color: warmGray50,
                                        child: InkWell(
                                          onTap: () {
                                            Get.toNamed('/property_detail',
                                                arguments: {"type": "OTHER"});
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
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4),
                                                          color: mint01,
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
                                                            '벤처투자',
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
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Text(
                                                          '${query.data!.lastMonthOther.setComma()}원',
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
                      '투자금 현황',
                      style: h4(color: gray900, bold: true),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      '지난 6개월 (백만원)',
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
                            controller: controller.scrollController,
                            reverse: true,
                            child: Container(
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.transparent)),
                              constraints: BoxConstraints(
                                minWidth: MediaQuery.of(context).size.width,
                                maxWidth: MediaQuery.of(context).size.width *
                                    (controller
                                                .selector(
                                                    query.data!
                                                        .collateralChartData,
                                                    query.data!.creditChartData,
                                                    query.data!.otherChartData)
                                                .length <=
                                            6
                                        ? 1
                                        : controller
                                                .selector(
                                                    query.data!
                                                        .collateralChartData,
                                                    query.data!.creditChartData,
                                                    query.data!.otherChartData)
                                                .length /
                                            6),
                              ),
                              child: SfCartesianChart(
                                  plotAreaBorderWidth: 0,
                                  primaryXAxis: CategoryAxis(
                                    isVisible: true,
                                    axisLabelFormatter: (s) {
                                      return ChartAxisLabel(
                                          '${s.text.substring(2, 4)}년${s.text.substring(4, 6)}월',
                                          label4(color: deepBlue));
                                    },
                                    majorGridLines:
                                        const MajorGridLines(width: 0),
                                  ),
                                  primaryYAxis: const NumericAxis(
                                    isVisible: false,
                                    // minimum: controller
                                    //     .selector(
                                    //         query.data!.chartMin,
                                    //         query.data!.collateralChartMin,
                                    //         query.data!.creditChartMin)
                                    //     .toDouble(),
                                    rangePadding: ChartRangePadding.round,
                                    majorGridLines: MajorGridLines(width: 0),
                                  ),
                                  tooltipBehavior: tooltip,
                                  series: <CartesianSeries<ChartData, String>>[
                                    ColumnSeries<ChartData, String>(
                                      dataLabelSettings:
                                          const DataLabelSettings(
                                        isVisible: true,
                                      ),
                                      dataLabelMapper: (d, i) {
                                        return '${NumberFormat('###,###,###,###,###.##').format((d.y / 1000000).toInt())}';
                                      },
                                      selectionBehavior: SelectionBehavior(
                                        enable: true,
                                        selectedColor: yellow,
                                        unselectedColor: grayLight2,
                                        unselectedOpacity: 1,
                                      ),
                                      spacing: 0.2,
                                      dataSource: controller.selector(
                                          query.data!.collateralChartData,
                                          query.data!.creditChartData,
                                          query.data!.otherChartData),
                                      xValueMapper: (ChartData cd, _) => cd.x,
                                      yValueMapper: (ChartData cd, _) => cd.y,
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
      ),
    );
  }

  Widget SingleBarChart(Query<FetchedValue, dynamic> query) {
    if (query.isLoading || query.data == null) {
      return const Skeleton(
        width: double.infinity,
        height: 24,
      );
    }

    return Row(mainAxisSize: MainAxisSize.max, children: [
      Flexible(
          flex: (controller.show['collateral'] ?? false)
              ? (query.data!.lastMonthCollateral )
                  .toInt()
              : 0,
          child: Container(
            color: green1,
            height: 30,
          )),
      Flexible(
          flex: (controller.show['credit'] ?? false)
              ? (query.data!.lastMonthCredit )
                  .toInt()
              : 0,
          child: Container(
            color: yellow,
            height: 30,
          )),
      Flexible(
          flex: (controller.show['other'] ?? false)
              ? (query.data!.lastMonthOther )
                  .toInt()
              : 0,
          child: Container(
            color: mint01,
            height: 30,
          )),
    ]);
    //
    //     : (controller.show['collateral'] ?? false)
    //     ? ClipRRect(
    //   borderRadius: BorderRadius.circular(4),
    //   child: query.data!.lastMonth == 0
    //       ? const LinearProgressIndicator(
    //     backgroundColor: grayLight2,
    //     value: 0,
    //     minHeight: 24,
    //   )
    //       : LinearProgressIndicator(
    //     backgroundColor: yellow,
    //     color: green1,
    //     value: controller.selector(
    //       (query.data!.lastMonthCollateral /
    //           query.data!.lastMonth),
    //       1,
    //       0,
    //     ),
    //     minHeight: 24,
    //   ),
    // )
  }
}

/*


 */
