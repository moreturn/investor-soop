import 'package:fl_query/fl_query.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:investor_soop/component/color.dart';
import 'package:investor_soop/component/skeleton.dart';
import 'package:investor_soop/component/typograph.dart';
import 'package:investor_soop/model/income.dart';
import 'package:investor_soop/model/property.dart';
import 'package:investor_soop/page/income/@bottom_sheet.dart';
import 'package:investor_soop/page/income/controller/income_controller.dart';
import 'package:investor_soop/page/property/controller/property_controller.dart';
import 'package:investor_soop/services/auth_service.dart';
import 'package:investor_soop/util/extension.dart';
import 'package:investor_soop/util/numberToKor.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class IncomePage extends StatefulWidget {
  IncomePage({super.key});

  @override
  State<IncomePage> createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  final controller = Get.find<IncomeController>();
  final Rx<DateTime> start =
      Rx(DateTime.now().subtract(const Duration(days: 365)));

  @override
  void initState() {
    super.initState();
  }

  Future<FetchedIncomeValue> fetch() {
    print(DateFormat('yyyy-MM-dd').format(start.value));
    return controller.fetchIncome(DateFormat('yyyy-MM-dd').format(start.value));
  }

  @override
  Widget build(BuildContext context) {
    final _tooltip = TooltipBehavior(
        enable: true,
        builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
            int seriesIndex) {
          return Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                '${data.x.toString().substring(0, 4)}년${data.x.toString().substring(4, 6)}월 : ${numberToKor((data.y).toInt().toString(), isAll: true)}원',
                style: const TextStyle(color: Colors.white),
              ));
        });
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: QueryBuilder<FetchedIncomeValue, dynamic>(
          '${Get.find<AuthService>().userId}-income-summary', () => fetch(),
          onData: (value) {
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
                                IncomeBottomSheet(
                                    controller,
                                    controller
                                        .selector(
                                            query.data!.chartData,
                                            query.data!.collateralChartData,
                                            query.data!.creditChartData)
                                        .map<int>((d) => (d.y).toInt())
                                        .toList()
                                        .reduceWithSeed(
                                            (acc, cur) => acc + cur, 0)),
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
                              Text('총 수익',
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
                          ''
                          '${controller.selector(query.data!.chartData, query.data!.collateralChartData, query.data!.creditChartData).map<int>((d) => (d.y).toInt()).toList().reduceWithSeed((acc, cur) => acc + cur, 0).toString().setComma()} 원',
                          style: h1(bold: true, color: Colors.black)),
                  const SizedBox(
                    height: 32,
                  ),
                  Text(
                    '수익 추이',
                    style: h4(color: gray900, bold: true),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Wrap(
                    direction: Axis.horizontal,
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      Button(
                        onPressed: () {
                          start(DateTime.now().subtract(Duration(days: 90)));
                          query.refresh();
                        },
                        start: start.value,
                        minDay: 90,
                        text: '3개월',
                      ),
                      Button(
                        onPressed: () {
                          start(DateTime.now().subtract(Duration(days: 180)));
                          query.refresh();
                        },
                        start: start.value,
                        minDay: 180,
                        text: '6개월',
                      ),
                      Button(
                        onPressed: () {
                          start(DateTime.now().subtract(Duration(days: 365)));
                          query.refresh();
                        },
                        start: start.value,
                        minDay: 365,
                        text: '1년 ',
                      ),
                      Button(
                        onPressed: () {
                          start(
                              DateTime.now().subtract(Duration(days: 365 * 3)));
                          query.refresh();
                        },
                        start: start.value,
                        minDay: 365 * 3,
                        text: '3년',
                      ),
                      Button(
                        onPressed: () {
                          start(
                              DateTime.now().subtract(Duration(days: 365 * 5)));
                          query.refresh();
                        },
                        start: start.value,
                        minDay: 365 * 5,
                        text: '5년 ',
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  query.isLoading || query.data == null
                      ? const Skeleton(
                          width: double.infinity,
                          height: 182,
                        )
                      : controller
                              .selector(
                                  query.data!.chartData,
                                  query.data!.collateralChartData,
                                  query.data!.creditChartData)
                              .isEmpty
                          ? Container(
                              width: double.infinity,
                              height: 182,
                              color: warmGray50,
                            )
                          : Container(
                              height: 182,
                              child: SfCartesianChart(
                                  plotAreaBorderWidth: 0,
                                  primaryXAxis: CategoryAxis(
                                    isVisible: false,
                                    majorGridLines:
                                        const MajorGridLines(width: 0),
                                  ),
                                  primaryYAxis: NumericAxis(
                                    isVisible: true,
                                    minimum: controller
                                        .selector(
                                            query.data!.chartMin,
                                            query.data!.collateralChartMin,
                                            query.data!.creditChartMin)
                                        .toDouble(),
                                    rangePadding: ChartRangePadding.round,

                                    majorGridLines: const MajorGridLines(
                                        width: 1, dashArray: [3.0, 6]),
                                  ),
                                  tooltipBehavior: _tooltip,
                                  series: <ChartSeries<IncomeChartData,
                                      String>>[
                                    FastLineSeries<IncomeChartData, String>(
                                      dataLabelSettings:
                                          const DataLabelSettings(
                                        isVisible: true,
                                        useSeriesColor: true,
                                        labelAlignment:
                                            ChartDataLabelAlignment.bottom,
                                      ),
                                      dataLabelMapper: (d, i)
                                      {

                                        return d.y.toInt() > 0 ? '${numberToKor(d.y.toInt().toString())}원' : '';
                                      },
                                      selectionBehavior: SelectionBehavior(
                                        enable: true,
                                        selectedColor: yellow,
                                        unselectedColor: grayLight2,
                                        unselectedOpacity: 1,
                                      ),
                                      dataSource: controller
                                          .selector(
                                              query.data!.chartData,
                                              query.data!.collateralChartData,
                                              query.data!.creditChartData)
                                          .indexedMap<IncomeChartData>(
                                              (element, index, array) {
                                        List<IncomeChartData> a = [];
                                        a.addAll(array);
                                        double sum = a
                                            .indexedWhere(
                                                (element, innerIndex) {
                                              return index > innerIndex;
                                            })
                                            .map<double>((d) => d.y)
                                            .toList()
                                            .reduceWithSeed(
                                                (acc, cur) => acc + cur, 0);
                                        return IncomeChartData(
                                            element.x, sum + element.y);
                                      }).toList(),
                                      xValueMapper: (IncomeChartData cd, _) =>
                                          cd.x,
                                      yValueMapper: (IncomeChartData cd, _) =>
                                          cd.y,
                                      color: deepBlue,
                                      opacity: 1,
                                    )
                                  ]),
                            ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    '월간 수익 (만원)',
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
                                plotAreaBorderWidth: 0,
                                primaryXAxis: CategoryAxis(
                                  isVisible: true,
                                  axisLabelFormatter: (s) {
                                    return ChartAxisLabel(
                                        '${s.text.substring(0,4)}년\n${s.text.substring(4, 6)}월',
                                        label3(color: deepBlue));
                                  },
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
                                  rangePadding: ChartRangePadding.round,
                                  majorGridLines:
                                      const MajorGridLines(width: 0),
                                ),
                                tooltipBehavior: _tooltip,
                                series: <ChartSeries<IncomeChartData, String>>[
                                  ColumnSeries<IncomeChartData, String>(
                                    dataLabelSettings: const DataLabelSettings(
                                      isVisible: true,
                                    ),
                                    dataLabelMapper: (d, i) {


                                      return (d.y / 10000).toInt() > 0 ? '${NumberFormat('###,###,###,###,###').format((d.y / 10000).toInt())}만원' : '';
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
                                    xValueMapper: (IncomeChartData cd, _) =>
                                        cd.x,
                                    yValueMapper: (IncomeChartData cd, _) =>
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

class Button extends StatelessWidget {
  final onPressed;
  final String text;
  final DateTime start;
  final int minDay;

  const Button(
      {super.key,
      required this.onPressed,
      required this.text,
      required this.start,
      required this.minDay});

  @override
  Widget build(BuildContext context) {
    final c = DateFormat.yMMMd().format(start);
    final d = DateFormat.yMMMd()
        .format(DateTime.now().subtract(Duration(days: minDay)));
    return Material(
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: c == d ? deepBlue3 : warmGray100,
        ),
        child: InkWell(
          onTap: () {
            onPressed();
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
              height: 28,
              alignment: Alignment.center,
              padding: EdgeInsets.all(4),
              constraints: BoxConstraints(minWidth: 44, maxWidth: 52),
              // You can remove the decoration from the Container
              child: Text(
                text,
                style: label4(color: c == d ? Colors.white : deepBlue1),
              )),
        ),
      ),
    );
  }
}
