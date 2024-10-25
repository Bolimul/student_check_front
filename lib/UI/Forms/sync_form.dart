import 'dart:io';

import 'package:flutter/material.dart';
import 'package:student_check/Controller%20and%20Middleware/controller.dart';
import 'package:student_check/UI/Buttons/choice_button.dart';
class SyncForm extends StatefulWidget {
  const SyncForm({super.key,required this.controller});
  final Controller controller;

  @override
  State<SyncForm> createState() => _SyncFromState();
}

class _SyncFromState extends State<SyncForm>{
  String _studentsId = '';

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          flex: 5,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  label: Text('תכניס.י את הקודים המזהים של הסטודנטים, כמו: id1, id2', style: Platform.isAndroid? const TextStyle(fontSize: 10): const TextStyle(fontSize: 16),),
                ),
                onChanged: (value) {
                  setState(() {
                    _studentsId = value;
                  });
                },
              ),
              Row(
                //mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: ChoiceButton(
                      title: "בקשה לסנכרון",
                      buttonText: "לסנכרן",
                      content: "האם את.ה רוצה לסנכרן את הסטודנטים במסד המתונים ממקומי?",
                      approvalMessage: "סנכרון עבר בצלחה",
                      disapprovalMessage: "סנכרון נכשל: נסה.י שוב",
                      function: widget.controller.syncDataUI,
                      stList: _studentsId,
                    ),
                  ),
                  Expanded(
                    child: ChoiceButton(
                      title: "בקשה למחיקה",
                      buttonText: "למחוק",
                      content: "האם את.ה רוצה למחוק את הסטודנטים ממסד המתונים ממקומי?",
                      approvalMessage: "מחיקה עברה בצלחה",
                      disapprovalMessage: "מחיקה נכשלה: נסה.י שוב",
                      function: widget.controller.deleteDataUI,
                      stList: _studentsId,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Expanded(
          flex: 2,
            child: Column(
              children: [
                Expanded(
                  child: ChoiceButton(
                    title: "בקשה לסנכרון הכולל",
                    buttonText: "לסנכרן את כולם",
                    content: "האם את.ה רוצה לסנכרן את הסטודנטים במסד המתונים ממקומי?",
                    approvalMessage: "סנכרון עבר בצלחה",
                    disapprovalMessage: "סנכרון הכולל נכשל: נסה.י שוב",
                    function: widget.controller.syncAllUI,
                    stList: 'all',
                  ),
                ),
                Expanded(
                  child: ChoiceButton(
                    title: "בקשה למחיקה הכוללת",
                    buttonText: "למחוק את כולם",
                    content: "האם את.ה רוצה למחוק את הסטודנטים ממסד המתונים ממקומי?",
                    approvalMessage: "מחיקה עברה בצלחה",
                    disapprovalMessage: "מחיקה נכשלה: נסה.י שוב",
                    function: widget.controller.deleteAllDataUI,
                    stList: 'all',
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}