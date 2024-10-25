import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:student_check/UI/Charts/table_true_false.dart';
import 'package:student_check/UI/Charts/chart_for_categories_in_range.dart';
import 'package:student_check/Controller%20and%20Middleware/controller.dart';
import 'package:student_check/UI/Providers/user_provider.dart';

class ChartDownload extends StatelessWidget{
  const ChartDownload({super.key, required this.context, required this.controller, required this.itemHeight, required this.itemWidth});
  final Controller controller;
  final BuildContext context;
  final double itemHeight;
  final double itemWidth;
  

  @override
  Widget build(BuildContext context) {
    String type = 'chart';
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InteractiveViewer(
          panEnabled: false,
          child: Screenshot(
          controller: controller.scrCont,
          child: Container(
            margin: const EdgeInsets.only(bottom: 20),
            width: itemWidth,
            height: itemHeight/1.5,
            child: Builder(
              builder: (context){
                if(context.watch<UserProvider>().studentName != '' && context.watch<UserProvider>().groupName != ''){
                  if(context.watch<UserProvider>().checkBoxes.contains(true) && !context.watch<UserProvider>().listOfTablesCheckboxes.contains(true)){
                    type = 'chart';
                    return const ChartForCategoriesInRange();
                  }
                  else if(context.watch<UserProvider>().listOfTablesCheckboxes.contains(true) && !context.watch<UserProvider>().checkBoxes.contains(true)){
                    type = 'table';
                    return const TableTrueFalse();
                  }
                  else{
                    return const Center(child: Text("תבחר.י את הקטגוריה לתצוגה"),);
                  }
                }
                else{
                  return const Center(child: Text("תבחר.י את הקטגוריה לתצוגה"),);
                }
              }))
          )
        ),
      ElevatedButton(
        onPressed: () async => {await controller.makeAndDownloadImage(context, type)},
          child: const Text("הורדה")
        )
      ]
    );
  }
}
