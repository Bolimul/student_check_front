import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/user_provider.dart';

class CheckboxList extends StatelessWidget {
  final String type;
  final double height;
  final double width;
  const CheckboxList({super.key, required this.type, required this.height, required this.width});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all()),
      width: width,
      height: height,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            //flex: 1,
            child: Center(child: Text(type == 'table'? "כטבלה": "כתרשים"))
          ),
          Expanded(
            //flex: 4,
            child: ListView.builder(
            itemCount: type == 'table'?context.watch<UserProvider>().listOfTablesCheckboxes.length:context.watch<UserProvider>().checkBoxes.length,
            itemBuilder: (context, index) {
              return Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Param ${index + (type == 'table'?5:1)}"),
                    Checkbox(
                      value: type == 'table'?context.watch<UserProvider>().listOfTablesCheckboxes[index]:context.watch<UserProvider>().checkBoxes[index],
                      onChanged: ((value) {
                        if(type == 'table'){
                          context.read<UserProvider>().setCheckboxForListOfTables(index, value);
                        }else{
                          context.read<UserProvider>().setCheckbox(index, value);
                        }
                        context.read<UserProvider>().setListOfSpots();
                      })
                    ),
                  ],
                )
              );
            }
            )
          ),
        ],
      ),
    );
  }
}