import 'package:flutter/material.dart';
import 'package:student_check/Controller%20and%20Middleware/controller.dart';
import 'package:student_check/UI/Charts/Table/cell.dart';

class TableTrueFalseForScreenshot extends StatelessWidget{
  TableTrueFalseForScreenshot({super.key});
  final Controller _controller = Controller();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(child: Text("טבלה של: ${_controller.chosenName}",style: const TextStyle(color: Colors.black), textDirection: TextDirection.rtl,)),
        DataTable(
          columns: [
            const DataColumn(label: Center(child: Text('תאריכים:'))),
            ..._controller.tableSpots.values.first.map((el) => DataColumn(
              label: Center(child: Text(el.$1)),
              headingRowAlignment: MainAxisAlignment.center)
            )
          ],
          rows: [
            ..._controller.categotyTableList.where((el) => _controller.listOfTablesCheckboxes[_controller.categotyTableList.indexOf(el)] == true).map((e) =>
              DataRow(
                cells: [
                  DataCell(Center(child: Text(e.$2),)),
                  ..._controller.tableSpots[e.$1]!.map((el) => DataCell(Cell(switcher: el.$2 == 1? true:false,)))
                ]
              )
            )
          ],
        ),
      ],
    );
  }
  
}