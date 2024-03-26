import 'package:flutter/material.dart';
import 'package:generic_project/core/components/custom_scaffold.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GraphsPage extends StatefulWidget {
  const GraphsPage({super.key});

  @override
  State<GraphsPage> createState() => _GraphsPageState();
}

class _GraphsPageState extends State<GraphsPage> {
  List<_TempData> data = [
    _TempData(DateTime.now(), 16),
    _TempData(DateUtils.addDaysToDate(DateTime.now(), -1), -5),
    _TempData(DateUtils.addDaysToDate(DateTime.now(), -2), 9),
    _TempData(DateUtils.addDaysToDate(DateTime.now(), -3), 8),
    _TempData(DateUtils.addDaysToDate(DateTime.now(), -4), 14),
    _TempData(DateUtils.addDaysToDate(DateTime.now(), -5), 12),
    _TempData(DateUtils.addDaysToDate(DateTime.now(), -6), 10),
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        showLeading: const BackButton(
          color: Colors.black,
        ),
        body: Column(
          children: [
            SizedBox(
              height: 300,
              child: SfCartesianChart(
                primaryXAxis: DateTimeAxis(),
                primaryYAxis: NumericAxis(),
                title: ChartTitle(text: 'Temperature Data'),
                series: <ChartSeries<_TempData, dynamic>>[
                  LineSeries(
                      dataSource: data,
                      xValueMapper: (_TempData temps, _) => temps.date,
                      yValueMapper: (_TempData temps, _) => temps.tempValue,
                      name: 'Temps',
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: true))
                ],
              ),
            ),
          ],
        ));
  }
}

class _TempData {
  final DateTime date;
  final double tempValue;
  _TempData(this.date, this.tempValue);
}
