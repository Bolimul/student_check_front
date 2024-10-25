import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_check/UI/Charts/Table/cell.dart';
import 'package:student_check/UI/Providers/user_provider.dart';

class TableTrueFalse extends StatelessWidget{
  const TableTrueFalse({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              Center(child: Text("טבלה של: ${context.watch<UserProvider>().studentName}")),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    if(context.watch<UserProvider>().tableSpots.isNotEmpty) ...[
                      const DataColumn(label: Center(child: Text('תאריכים:'))),
                      ...context.watch<UserProvider>().tableSpots.values.first.map((el) => DataColumn(
                      label: Center(child: Text(el.$1)),
                      headingRowAlignment: MainAxisAlignment.center))
                    ]
                  ],
                  rows: [
                    if(context.watch<UserProvider>().tableSpots.isNotEmpty) ...[
                      ...context.watch<UserProvider>().categotyTableList.where((el) => context.watch<UserProvider>().listOfTablesCheckboxes[context.watch<UserProvider>().categotyTableList.indexOf(el)] == true).map((e) =>
                        DataRow(
                          cells: [
                            DataCell(Center(child: Text(e.$2),)),
                            ...context.watch<UserProvider>().tableSpots[e.$1]!.map((el) => DataCell(Cell(switcher: el.$2 == 1? true:false,)))
                          ]
                        )
                      )
                    ]
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  } 
}