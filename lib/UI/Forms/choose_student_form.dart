import 'dart:io';

import 'package:flutter/material.dart';
import 'package:student_check/Controller%20and%20Middleware/controller.dart';
import 'package:student_check/UI/Forms/sync_form.dart';
import 'package:student_check/UI/Lists/checkbox_list.dart';
import 'package:student_check/UI/Providers/user_provider.dart';
import 'package:provider/provider.dart';

class ChooseStudentForm extends StatefulWidget{
  const ChooseStudentForm({super.key, required this.itemWidth, required this.itemHeight});
  final double itemWidth;
  final double itemHeight;
     
  @override
  State<ChooseStudentForm> createState() => _ChooseStudentForm();
}

class _ChooseStudentForm extends State<ChooseStudentForm>{
  final TextEditingController _nameEditingController = TextEditingController();
  final Controller controller = Controller();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Center(
        child: ListView(
          shrinkWrap: true,
          addAutomaticKeepAlives: true,
          children: [

            Center(
              child: Offstage(
                offstage: context.watch<UserProvider>().isConnected,
                child: Container(
                  decoration: BoxDecoration(border: Border.all()),
                  width: widget.itemWidth-50,
                  height: 150,
                  child: SyncForm(
                    controller: controller
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: DropdownMenu(
                width: widget.itemWidth-100,
                dropdownMenuEntries: List<DropdownMenuEntry<String>>.from(context.watch<UserProvider>().groups.map((item) {return DropdownMenuEntry(label: item, value: item);}).toList()),
                hintText: "תבחר.י את הקבוצת הסטודנטים...",
                enableSearch: true,
                leadingIcon: const Icon(Icons.search),
                onSelected: (value) {
                    context.read<UserProvider>().setDefault();
                    context.read<UserProvider>().setGroupName(value.toString());
                    context.read<UserProvider>().setNames();
                    context.read<UserProvider>().setListOfSpots();
                  setState(() { 
                     _nameEditingController.clear();
                  });
                },
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: DropdownMenu(
                width: widget.itemWidth-100,
                dropdownMenuEntries: List.from(context.watch<UserProvider>().names.map((item) {return DropdownMenuEntry(label: item, value: item);}).toList()),
                hintText: "תבחר.י את הקוד המזהה של הסטודנט...",
                enableSearch: true,
                leadingIcon: const Icon(Icons.search),
                onSelected: (value) {
                  context.read<UserProvider>().setDefault();
                  context.read<UserProvider>().setStudentName(value.toString());
                  context.read<UserProvider>().setListOfSpots();
                },
                controller: _nameEditingController,
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Container(
                decoration: BoxDecoration(border: Border.all()),
                width: widget.itemWidth-100,
                height: Platform.isAndroid?widget.itemHeight/2:widget.itemHeight/4,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed:()async {
                        await controller.setTimeUI(context);
                        if(context.mounted){
                          context.read<UserProvider>().setStartAndEndDate();
                          context.read<UserProvider>().setListOfSpots();
                        }
                      },
                      child: const Text("תבחר.י את התווך התאריכים")
                    ),
                    Text("תאריך ההתחלה: ${context.watch<UserProvider>().startDate.day}/${context.watch<UserProvider>().startDate.month}/${context.watch<UserProvider>().startDate.year}"),
                    Text("תאריך הסוף: ${context.watch<UserProvider>().endDate.day}/${context.watch<UserProvider>().endDate.month}/${context.watch<UserProvider>().endDate.year}")
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CheckboxList(type: 'chart', width: widget.itemWidth/3, height: widget.itemHeight/2),
                  CheckboxList(type: 'table',width: widget.itemWidth/3, height: widget.itemHeight/2)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}