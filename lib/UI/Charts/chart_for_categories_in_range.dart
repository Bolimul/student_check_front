import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_check/Controller%20and%20Middleware/controller.dart';
import 'package:student_check/UI/Providers/user_provider.dart';

class ChartForCategoriesInRange extends StatelessWidget{
  const ChartForCategoriesInRange({super.key});

  @override
  Widget build(BuildContext context) {
    final Controller controller = Controller();
    return LineChart(
      LineChartData(
        lineTouchData: const LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            fitInsideVertically: true,
            fitInsideHorizontally: true
          )
        ),
        lineBarsData: [
          if(context.watch<UserProvider>().checkBoxes[0] && context.watch<UserProvider>().studentName != "" && context.watch<UserProvider>().groupName != "") ...[
            LineChartBarData(
              show: true,
              spots: context.watch<UserProvider>().spots['1'] ?? List<FlSpot>.empty(),
              color: Colors.red,
              barWidth: 4,
              isCurved: true,
              preventCurveOverShooting: true,
              curveSmoothness: 0.35,
            ),
          ], if(context.watch<UserProvider>().checkBoxes[1] && context.watch<UserProvider>().studentName != "" && context.watch<UserProvider>().groupName != "") ...[
            LineChartBarData(
              show: true,
              spots: context.watch<UserProvider>().spots['2'] ?? List<FlSpot>.empty(),
              color: Colors.blue,
              barWidth: 4,
              isCurved: true,
              preventCurveOverShooting: true,
              curveSmoothness: 0.35,
            ),
          ], if(context.watch<UserProvider>().checkBoxes[2] && context.watch<UserProvider>().studentName != "" && context.watch<UserProvider>().groupName != "") ...[
            LineChartBarData(
              show: true,
              spots: context.watch<UserProvider>().spots['3'] ?? List<FlSpot>.empty(),
              color: Colors.green,
              barWidth: 4,
              isCurved: true,
              preventCurveOverShooting: true,
              curveSmoothness: 0.35,
            ),
          ] ,if(context.watch<UserProvider>().checkBoxes[3] && context.watch<UserProvider>().studentName != "" && context.watch<UserProvider>().groupName != "") ...[
            LineChartBarData(
              show: true,
              spots: context.watch<UserProvider>().spots['4'] ?? List<FlSpot>.empty(),
              color: Colors.black,
              barWidth: 4,
              isCurved: true,
              preventCurveOverShooting: true,
              curveSmoothness: 0.35,
            ),
          ], 
        ],
        titlesData: FlTitlesData(
          show: true,
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (double value, TitleMeta meta) {
                return Text(meta.formattedValue, style: const TextStyle(color: Colors.blueAccent),);
              },
            )
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              minIncluded: true,
              maxIncluded: true,
              showTitles: true,
              reservedSize: 20,
              getTitlesWidget: (double value, TitleMeta meta) {
                bool isExist = false;
                Widget text = const Text("", style: TextStyle(color: Colors.blueAccent));
                try {
                  isExist = context.watch<UserProvider>().spots.isNotEmpty;
                } catch (e) {
                  isExist = false;
                }
                if(isExist == true && context.watch<UserProvider>().groupName != "" && context.watch<UserProvider>().studentName != "" && context.watch<UserProvider>().checkBoxes.contains(true)){
                  
                  DateTime date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                  double middle = (meta.max-meta.min)/2 + meta.min;
                  if(value <= middle + meta.appliedInterval && value >= middle - meta.appliedInterval && controller.isPlaced){
                    int days = (controller.endDate.difference(controller.firstDate).inDays/2).round();
                    date = controller.startDate.add(Duration(days: days));
                  }
                  String month = date.month.toString();
                  String year = date.year.toString();
                  String day = date.day.toString();
                  
                  if((value <= middle + meta.appliedInterval && value >= middle - meta.appliedInterval && controller.isPlaced) || value == meta.min || value == meta.max){
                    text = Text("$day/$month/$year", style: const TextStyle(color: Colors.blueAccent, fontSize: 10));
                    controller.setIsPlaced(false);
                    return SideTitleWidget(
                      angle: -45,
                      axisSide: meta.axisSide,
                      fitInside: SideTitleFitInsideData(enabled: true, axisPosition: meta.axisPosition, parentAxisSize: meta.parentAxisSize, distanceFromEdge: 0),
                      child: text
                    );
                  }
                  else{
                    controller.setIsPlaced(true);
                    return text;
                  }
                }
                return text;
              },
            )
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(
              showTitles: false
            )
          ),
          topTitles: AxisTitles(
            axisNameWidget: Text("תרשים של: ${controller.chosenName}"),
          )
        )
      ),
    );
  }
}